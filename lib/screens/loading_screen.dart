import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inspired/navigation/app_state.dart';
import 'package:inspired/screens/item_list_view_model.dart';
import 'package:inspired/utils/constants.dart';
import 'package:inspired/utils/preview_data_loader.dart';
import 'package:inspired/testdata/basic_test_urls.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LoadingScreen extends StatefulWidget {
  static const String id = 'loading_screen';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  void getInitialData() async {
    await addDataFromLocalStorage();
    List<ItemData> initialData = BasicTestUrls.testItemsRecent.sublist(0,2);
    List<ItemData> initialDataExploreScreen = BasicTestUrls.testItemsRecent
        .where((itemData) => itemData.itemCategory == ItemCategory.energy)
        .toList()
        .sublist(0, 2);
    List<ItemData> initialDataIncubatorScreen = BasicTestUrls.testItemsIncubator.sublist(0,2);
    List<Future<void>> futures = [];
    for (ItemData previewData in initialData) {
      futures.add(previewData.preLoadImage());
    }
    for (ItemData previewData in initialDataIncubatorScreen) {
      futures.add(previewData.preLoadImage());
    }
    for (ItemData previewData in initialDataExploreScreen) {
      futures.add(previewData.preLoadImage());
    }
    await Future.wait(futures);
    Provider.of<AppState>(context, listen: false).itemListViewModel.initialDataRecent.addAll(initialData);
    Provider.of<AppState>(context, listen: false).itemListViewModel.initialDataIncubator.addAll(initialDataIncubatorScreen);
    Provider.of<AppState>(context, listen: false).itemListViewModel.initialDataExplore.addAll(initialDataExploreScreen);
    Provider.of<AppState>(context, listen: false).isInitializing = false;
    print("Loading initial data finished.");
  }

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

  /// Adds all items stored as json in shared preferences to the hardcoded test data.
  Future<void> addDataFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    int itemsStored = prefs.getInt(BasicTestUrls.items_stored_string) ?? 0;
    for (int i = 0; i < itemsStored; i++) {
      String? itemJson = prefs.getString(i.toString());
      if (itemJson == null) {
        continue;
      }
      Map<String, dynamic> itemMap = jsonDecode(itemJson);
      ItemData itemData = ItemData.fromJson(itemMap);
      BasicTestUrls.testItemsRecent.add(itemData);
    }
  }
}
