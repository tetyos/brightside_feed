import 'dart:convert' as Dart;
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nexth/amplifyconfiguration.dart';
import 'package:nexth/backend_connection/database_query.dart';
import 'package:nexth/backend_connection/api_connector.dart';
import 'package:nexth/model/basic_test_urls.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/item_list_model.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/model/model_manager.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';
import 'package:nexth/utils/constants.dart';
import 'package:provider/provider.dart';



class LoadingScreen1 extends StatefulWidget {
  static const String id = 'loading_screen';
  final Function onDataLoaded;

  LoadingScreen1({required this.onDataLoaded});

  @override
  _LoadingScreen1State createState() => _LoadingScreen1State();
}

class _LoadingScreen1State extends State<LoadingScreen1> {

  @override
  void initState() {
    super.initState();
    print("Initialising state");
    _startupApp();
    print("Initialising state finished.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Some App Name", style: TextStyle(fontSize: 40, color: kColorPrimary),),
            SizedBox(height: 50),
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
    List<Future<void>> finishOnLoadingScreenFutures = [];
    Future<void> localStorageFuture = _loadDataFromLocalStorage();
    Future<void> minDelayFuture = Future.delayed(Duration(milliseconds: 1500));
    Future<void> amplifyFuture = _configureAmplifyAndUpdateLoginStatus();
    finishOnLoadingScreenFutures.add(localStorageFuture);
    finishOnLoadingScreenFutures.add(amplifyFuture);
    finishOnLoadingScreenFutures.add(minDelayFuture);

    Future<void> dataLoadingFuture = localStorageFuture.then((_) => _loadInitialItems());
    // commend out above and uncomment to below to use hardcoded items
    // Future<void> dataLoadingFuture = localStorageFuture.then((_) => _loadInitialHardcodedItems());
    dataLoadingFuture.then((_) {
      widget.onDataLoaded();
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
      await Amplify.Auth.getCurrentUser();
      print("Login check complete. User logged in.");
      Provider.of<AppState>(context, listen: false).isUserLoggedIn = true;
    } on AuthException {
      print("Login check complete. User not logged in.");
      Provider.of<AppState>(context, listen: false).isUserLoggedIn = false;
    }
  }

  /// For every item-list (home-list, categories, user-defined-lists, incubator) a small number of corresponding items is fetched from the backend. <br>
  /// The fetching is done in one http-request, in order to save traffic aka money.<br><br>
  ///
  /// The corresponding item-list-models are filled with the new items.<br>
  /// For a few of the new items the images are preloaded.
  Future<void> _loadInitialItems() async {
    ModelManager modelManager = ModelManager.instance;
    List<ItemListModel> modelsWithQueries = [];
    modelsWithQueries.addAll(modelManager.allModels);

    // built queryJson from all models that need to be queried
    List<DatabaseQuery> queries = [];
    for (ItemListModel currentModel in modelManager.allModels) {
      DatabaseQuery? databaseQuery = currentModel.getDBQueryForInitialization();
      if (databaseQuery == null) {
        modelsWithQueries.remove(currentModel);
      } else {
        queries.add(databaseQuery);
      }
    }
    String queriesAsJson = Dart.jsonEncode(queries);

    // sent request
    http.Response response = await APIConnector.getInitialData(queriesAsJson);
    if (response.statusCode != 200) {
      print("Items could not be loaded. Statuscode: ${response.statusCode}");
      print(response.body);
      return;
    }

    // parse results and init models
    dynamic resultsForAllModels = Dart.jsonDecode(response.body);
    int currentModelNumber = 0;
    List<Future<void>> futures = [];
    dynamic itemsMap = resultsForAllModels['items'];
    for (dynamic itemIdsForCurrentModel in resultsForAllModels['queriesToItemIds']) {
      ItemListModel currentModel = modelsWithQueries.elementAt(currentModelNumber);
      List<ItemData> itemsForModel = [];
      for (dynamic itemId in itemIdsForCurrentModel) {
        itemsForModel.add(ItemData.fromJson(itemsMap[itemId]));
      }
      futures.add(currentModel.prepareModel(itemsForModel));
      currentModelNumber++;
    }

    await Future.wait(futures);
  }

  Future<void> _loadInitialHardcodedItems() async {
    ModelManager modelManager = ModelManager.instance;
    modelManager.homeModel.items.addAll( BasicTestUrls.testItemsRecent);
    modelManager.getModelForCategory(ItemCategory.food).items.addAll(BasicTestUrls.testItemsManualIncubator);
    await modelManager.homeModel.preloadNextItems(2);
    await Future.delayed(Duration(seconds: 5));
  }

  /// Loads user defined categories.
  /// Adds all items stored as json in shared preferences to the hardcoded test data.
  Future<void> _loadDataFromLocalStorage() async {
    // final prefs = await SharedPreferences.getInstance();
    _initializeUserDefinedCategories();
  }

  void _initializeUserDefinedCategories() {
    // todo load user defined screens here and set base tab correctly.
    Provider.of<AppState>(context, listen: false).numberOfUserDefinedTabs = 1;
  }

  void _navigateToNextScreen() {
    bool isShowIntro = Provider.of<AppState>(context, listen: false).isShowIntro;
    bool isDataLoading = Provider.of<AppState>(context, listen: false).isDataLoading;
    bool isUserLoggedIn = Provider.of<AppState>(context, listen: false).isUserLoggedIn;

    NexthRoutePath newPath;
    if (isShowIntro) {
      newPath = IntroScreenPath();
    } else if (!isUserLoggedIn) {
      newPath = LoginScreenPath();
    } else if (isDataLoading) {
      return;
      // if data is still loading, but intro and login are not necessary -> we want to stay on this screen
    } else {
      newPath = NexthHomePath();
    }

    Provider.of<AppState>(context, listen: false).currentRoutePath = newPath;
  }
}
