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
    List<ItemData> initialDataRecent = BasicTestUrls.testItemsRecent.sublist(0,2);
    List<List<ItemData>> initialDataPerCategory = getItemsPerCategory();
    List<ItemData> initialDataIncubator = BasicTestUrls.testItemsIncubator.sublist(0,2);

    // preload images
    List<Future<void>> futures = [];
    futures.addAll(loadAllImages(initialDataRecent));
    futures.addAll(loadAllImages(initialDataIncubator));
    for (List<ItemData> itemsOfCategory in initialDataPerCategory) {
      futures.addAll(loadAllImages(itemsOfCategory));
    }

    await Future.wait(futures);
    ItemListViewModel itemListViewModel = Provider.of<AppState>(context, listen: false).itemListViewModel;
    itemListViewModel.initialDataRecent.addAll(initialDataRecent);
    itemListViewModel.initialDataIncubator.addAll(initialDataIncubator);
    for (ItemCategory itemCategory in ItemCategory.values) {
      itemListViewModel.setCategoryItems(itemCategory, initialDataPerCategory.elementAt(itemCategory.index));
    }
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
}
