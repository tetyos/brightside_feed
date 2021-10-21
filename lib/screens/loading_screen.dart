import 'dart:convert' as Dart;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nexth/backend_connection/database_query.dart';
import 'package:nexth/backend_connection/http_request_helper.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/item_list_model.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/model/model_manager.dart';
import 'package:nexth/utils/constants.dart';
import 'package:provider/provider.dart';



class LoadingScreen extends StatefulWidget {
  static const String id = 'loading_screen';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    super.initState();
    print("Initialising state");
    getInitialData();
    print("Initialising state finished.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body : Center(
          child: SpinKitCubeGrid(
            color: kColorPrimary,
            size: 100.0,
          ),
        )
    );
  }

  void getInitialData() async {
    await loadDataFromLocalStorage();
    await loadInitialItems();
    Provider.of<AppState>(context, listen: false).isAppInitializing = false;
    print("Loading initial data finished.");
  }

  /// For every item-list (home-list, categories, user-defined-lists, incubator) a small number of corresponding items is fetched from the backend. <br>
  /// The fetching is done in one http-request, in order to save traffic aka money.<br><br>
  ///
  /// The corresponding item-list-models are filled with the new items.<br>
  /// For a few of the new items the images are preloaded.
  Future<void> loadInitialItems() async {
    ModelManager modelManager = ModelManager.instance;

    // built queryJson from all model that need to be queried
    List<DatabaseQuery> queries = [];
    for (ItemListModel currentModel in modelManager.allModels) {
      queries.add(currentModel.getDatabaseQueryForInitialization());
    }
    String queryJson = Dart.jsonEncode(queries);

    // sent request
    http.Response response = await HttpRequestHelper.getInitialData(queryJson);
    if (response.statusCode != 200) {
      print("Items could not be loaded. Statuscode: ${response.statusCode}");
      print(response.body);
      return;
    }

    // parse results
    dynamic allResults = Dart.jsonDecode(response.body);
    int currentModelNumber = 0;
    for (dynamic resultForQuery in allResults) {
      ItemListModel currentModel = modelManager.allModels.elementAt(currentModelNumber);
      for (dynamic itemJson in resultForQuery) {
        currentModel.itemList.add(ItemData.fromJson(itemJson));
      }
      currentModelNumber++;
    }

    // preload images
    List<Future<bool>> futures = [];
    for (ItemListModel currentModel in modelManager.allModels) {
      futures.add(currentModel.preloadNextItems(5));
    }
    await Future.wait(futures);
  }

  /// Loads user defined categories.
  /// Adds all items stored as json in shared preferences to the hardcoded test data.
  Future<void> loadDataFromLocalStorage() async {
    // final prefs = await SharedPreferences.getInstance();
    initializeUserDefinedCategories();
  }

  void initializeUserDefinedCategories() {
    // todo load user defined screens here and set base tab correctly.
    Provider.of<AppState>(context, listen: false).numberOfUserDefinedTabs = 1;
  }
}
