import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/model/model_manager.dart';
import 'package:nexth/utils/constants.dart';
import 'package:nexth/model/basic_test_urls.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



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
    await initializeItemListViewModel();
    Provider.of<AppState>(context, listen: false).isAppInitializing = false;
    print("Loading initial data finished.");
  }

  Future<void> initializeItemListViewModel() async {
    List<ItemData> initialDataRecent = BasicTestUrls.testItemsRecent.sublist(0,2);
    List<List<ItemData>> initialDataPerCategory = getItemsPerCategory();
    List<ItemData> initialDataManualIncubator = BasicTestUrls.testItemsManualIncubator.sublist(0,1);
    List<ItemData> initialDataScrapedIncubator = BasicTestUrls.testItemsScrapedIncubator.sublist(0,2);

    // preload images
    List<Future<void>> futures = [];
    futures.addAll(loadAllImages(initialDataRecent));
    futures.addAll(loadAllImages(initialDataManualIncubator));
    futures.addAll(loadAllImages(initialDataScrapedIncubator));
    for (List<ItemData> itemsOfCategory in initialDataPerCategory) {
      futures.addAll(loadAllImages(itemsOfCategory));
    }

    await Future.wait(futures);
    ModelManager itemListViewModel = Provider.of<AppState>(context, listen: false).modelManager;
    itemListViewModel.homeItemList.addAll(initialDataRecent);
    itemListViewModel.incubatorManualItemList.addAll(initialDataManualIncubator);
    itemListViewModel.incubatorScrapedItemList.addAll(initialDataScrapedIncubator);
    for (ItemCategory itemCategory in ItemCategory.values) {
      itemListViewModel.setCategoryItems(itemCategory, initialDataPerCategory.elementAt(itemCategory.index));
    }
  }

  /// Loads user defined categories.
  /// Adds all items stored as json in shared preferences to the hardcoded test data.
  Future<void> loadDataFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    initializeUserDefinedCategories();
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

  List<List<ItemData>> getItemsPerCategory() {
    List<List<ItemData>> itemsPerCategory = [];
    for (ItemCategory currentItemCategory in ItemCategory.values) {
      List<ItemData> itemsOfCurrentCategory = BasicTestUrls.testItemsRecent
          .where((itemData) => itemData.itemCategory == currentItemCategory)
          .toList();
      if (itemsOfCurrentCategory.length > 2) {
        itemsPerCategory.add(itemsOfCurrentCategory.sublist(0, 2));
      } else {
        itemsPerCategory.add(itemsOfCurrentCategory);
      }
    }
    return itemsPerCategory;
  }

  List<Future<void>> loadAllImages(List<ItemData> dataToLoad) {
    List<Future<void>> futures = [];
    for(ItemData itemData in dataToLoad) {
      futures.add(itemData.preLoadImage());
    }
    return futures;
  }

  void initializeUserDefinedCategories() {
    // todo load user defined screens here and set base tab correctly.
    Provider.of<AppState>(context, listen: false).numberOfUserDefinedTabs = 1;
  }
}
