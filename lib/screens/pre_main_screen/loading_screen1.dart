import 'dart:convert' as Dart;
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:brightside_feed/amplifyconfiguration.dart';
import 'package:brightside_feed/backend_connection/database_query.dart';
import 'package:brightside_feed/backend_connection/api_connector.dart';
import 'package:brightside_feed/model/basic_test_urls.dart';
import 'package:brightside_feed/model/item_data.dart';
import 'package:brightside_feed/model/list_models/item_list_model.dart';
import 'package:brightside_feed/model/user_data.dart';
import 'package:brightside_feed/navigation/app_state.dart';
import 'package:brightside_feed/model/model_manager.dart';
import 'package:brightside_feed/navigation/route_paths.dart';
import 'package:brightside_feed/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LoadingScreen1 extends StatefulWidget {
  static const String id = 'loading_screen';

  @override
  _LoadingScreen1State createState() => _LoadingScreen1State();
}

class _LoadingScreen1State extends State<LoadingScreen1> {

  @override
  void initState() {
    super.initState();
    print("Initialising app");
    _startupApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/logo.png", width: 40, height: 40,),
                SizedBox(width: 10,),
                Text("brightside-feed", style: TextStyle(fontSize: 40, color: kColorPrimary),),
              ],
            ),
            SizedBox(height: 120),
            SpinKitCubeGrid(
              color: kColorPrimary,
              size: 100.0,
            )
          ],
        ),
      ),
    );
  }

  void _startupApp() async {
    Future<void> localStorageFuture = _loadDataFromLocalStorage();
    Future<void> amplifyFuture = _configureAmplifyAndUpdateLoginStatus();
    Future<void> minDelayFuture = Future.delayed(Duration(milliseconds: 1500));

    List<Future<void>> finishOnLoadingScreenFutures = [];
    List<Future<void>> finishBeforeLoadingInitDataFutures = [];

    finishOnLoadingScreenFutures.add(localStorageFuture);
    finishOnLoadingScreenFutures.add(amplifyFuture);
    finishOnLoadingScreenFutures.add(minDelayFuture);

    finishBeforeLoadingInitDataFutures.add(localStorageFuture);
    finishBeforeLoadingInitDataFutures.add(amplifyFuture);

    Future<void> dataLoadingFuture = Future.wait(finishBeforeLoadingInitDataFutures).then((_) => _loadInitialData());
    // commend out above and uncomment to below to use hardcoded items
    // Future<void> dataLoadingFuture = Future.wait(finishBeforeLoadingInitDataFutures).then((_) => _loadInitialHardcodedItems());

    AppState appState = Provider.of<AppState>(context, listen: false);
    // appState can not be fetched inside future, since loading_screen might not be mounted then anymore (no context)
    dataLoadingFuture.then((_) {
      _handleDataLoaded(appState);
      print("Loading initial data finished.");
    });

    await Future.wait(finishOnLoadingScreenFutures);
    _navigateToNextScreen();
    print("Data from local storage loaded and min delay over.");
  }

  Future<void> _configureAmplifyAndUpdateLoginStatus() async {
    try {
      // add Amplify plugins
      AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
      await Amplify.addPlugins([authPlugin]);

      // configure Amplify
      //
      // note that Amplify cannot be configured more than once!
      await Amplify.configure(amplifyconfig);
      await _retrieveLoginStatus();
    } catch (e) {
      // todo improve error handling
      print('An error occurred while configuring Amplify: $e');
    }
  }

  Future<void> _retrieveLoginStatus() async {
    try {
      print("Checking login status. Ignore the following exception, if the user was not logged in.");
      AuthUser user = await Amplify.Auth.getCurrentUser();
      print("Login check complete. User logged in.");
      ModelManager.instance.userModel = UserModel(id: user.userId);
    } on AuthException {
      print("Login check complete. User not logged in.");
    }
  }

  /// For every item-list (home-list, categories, user-defined-lists, incubator) a small number of corresponding items is fetched from the backend. <br>
  /// The fetching is done in one http-request, in order to save traffic aka money.<br><br>
  ///
  /// The corresponding item-list-models are filled with the new items.<br>
  /// For a few of the new items the images are preloaded.<br><br>
  ///
  /// The UserData-model is initiated.
  Future<void> _loadInitialData() async {
    print("Loading of items started.");
    ModelManager modelManager = ModelManager.instance;
    List<ItemListModel> modelsWithQueries = [];

    // built queryJson from all models that need to be queried
    List<DatabaseQuery> queries = [];
    for (ItemListModel currentModel in modelManager.allModels) {
      DatabaseQuery? databaseQuery = currentModel.getDBQueryForInitialization();
      if (databaseQuery != null) {
        modelsWithQueries.add(currentModel);
        queries.add(databaseQuery);
      }
    }
    String queriesAsJson = Dart.jsonEncode(queries);

    // sent request
    bool isUserLoggedIn = Provider.of<AppState>(context, listen: false).isUserLoggedIn;
    if (isUserLoggedIn) {
      ModelManager.instance.isUserDataRetrieved = true;
    }
    dynamic resultsForAllModels = await APIConnector.getInitialData(queriesAsJson, isUserLoggedIn);
    if (resultsForAllModels == null) {
      return;
    }
    // init user model
    dynamic userDoc = resultsForAllModels['userDoc'];
    if (userDoc != null) {
      ModelManager.instance.userModel!.update(userDoc);
    }

    // parse results and init models
    int currentModelNumber = 0;
    List<Future<void>> futures = [];
    dynamic itemsMap = resultsForAllModels['items'];
    ModelManager.instance.addItemsFromJson(itemsMap);
    for (dynamic itemIdsForCurrentModel in resultsForAllModels['queriesToItemIds']) {
      ItemListModel currentModel = modelsWithQueries.elementAt(currentModelNumber);
      List<ItemData> itemsForModel = [];
      for (dynamic itemId in itemIdsForCurrentModel) {
        ItemData? itemData = ModelManager.instance.allItems[itemId];
        if (itemData != null) {
          itemsForModel.add(itemData);
        }
      }
      futures.add(currentModel.prepareModel(itemsForModel));
      currentModelNumber++;
    }

    await Future.wait(futures);
  }

  Future<void> _loadInitialHardcodedItems() async {
    ModelManager modelManager = ModelManager.instance;
    modelManager.homeModel.items.addAll(BasicTestUrls.testItemsRecent);
    await modelManager.homeModel.preloadNextItems(2);
    await Future.delayed(Duration(seconds: 5));
  }

  /// Loads user defined categories.
  /// Adds all items stored as json in shared preferences to the hardcoded test data.
  Future<void> _loadDataFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    AppState appState  = Provider.of<AppState>(context, listen: false);

    // user settings
    bool isFirstLogin = prefs.getBool(kLocalStorageFirstLogin) ?? true;
    bool isShowIncubatorIntro = prefs.getBool(kLocalStorageShowIncubatorIntro) ?? true;
    appState.isFirstLogin = isFirstLogin;
    appState.isShowIncubatorIntro = isShowIncubatorIntro;

    bool isShowContentDescription = prefs.getBool(kLocalStorageShowContentDescription) ?? true;
    appState.isShowContentDescription = isShowContentDescription;

    // admin settings
    bool isIntroWatched = prefs.getBool(kLocalStorageIntroWatched) ?? false;
    bool isAlwaysShowIntro = prefs.getBool(kLocalStorageAlwaysShowIntro) ?? false;
    bool isShowCategoryUpdater = prefs.getBool(kLocalStorageShowCategoryUpdater) ?? false;
    appState.isShowIntro = !isIntroWatched || isAlwaysShowIntro;
    appState.isShowCategoryUpdater = isShowCategoryUpdater;

    if (isFirstLogin) {
      prefs.setBool(kLocalStorageFirstLogin, false);
    }

    _initializeUserDefinedCategories();
    print("Data from local storage loaded.");
  }

  void _initializeUserDefinedCategories() {
    // todo load user defined screens here and set base tab correctly.
    Provider.of<AppState>(context, listen: false).numberOfUserDefinedTabs = 1;
  }

  void _navigateToNextScreen() {
    if (!mounted) {
      return;
    }
    bool isShowIntro = Provider.of<AppState>(context, listen: false).isShowIntro;
    bool isDataLoading = Provider.of<AppState>(context, listen: false).isDataLoading;
    bool isUserLoggedIn = Provider.of<AppState>(context, listen: false).isUserLoggedIn;

    AbstractRoutePath newPath;
    if (isShowIntro) {
      newPath = IntroScreenPath();
    } else if (!isUserLoggedIn) {
      newPath = LoginScreenPath();
    } else if (isDataLoading) {
      return;
      // if data is still loading, but intro and login are not necessary -> we want to stay on this screen
    } else {
      newPath = HomePath();
    }

    Provider.of<AppState>(context, listen: false).currentRoutePath = newPath;
  }

  _handleDataLoaded(AppState appState) async {
    if (appState.isUserLoggedIn && !ModelManager.instance.isUserDataRetrieved) {
      print("Retrieving user votes");
      await ModelManager.instance.retrieveUserData();
    }
    appState.isDataLoading = false;

    bool isNavigateToHomeScreen =
        (appState.isUserLoggedIn && !appState.isShowIntro) || appState.currentRoutePath is LoadingScreen2Path;
    if (isNavigateToHomeScreen) {
      appState.currentRoutePath = HomePath();
    }
  }
}
