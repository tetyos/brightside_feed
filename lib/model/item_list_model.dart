import 'package:nexth/model/database_query.dart';
import 'package:nexth/model/item_data.dart';

/// The ItemListModel provides the basic functions for managing the model behind all item-lists.
abstract class ItemListModel {

  List<ItemData> loadedItemList = [];
  List<ItemData> itemList = [];


  bool hasMoreItems() {
    return false;
  }

  DatabaseQuery getDatabaseQueryForInitialization();

  /// preloads the images for the next items. <br>
  /// returns false, if there were no more images to be preload.
  Future<bool> preloadNextItems(int numberOfItemsToPreload) async {
    int currentlyLoadedItems = loadedItemList.length;
    if (currentlyLoadedItems == itemList.length) {
      return false;
    }

    int to = currentlyLoadedItems + numberOfItemsToPreload;
    if (to > itemList.length) {
      to = itemList.length;
    }
    List<ItemData> newData = itemList.sublist(currentlyLoadedItems, to);

    List<Future<void>> futures = [];
    for (ItemData linkPreviewData in newData) {
      futures.add(linkPreviewData.preLoadImage());
    }
    await Future.wait(futures);
    loadedItemList.addAll(newData);
    return true;
  }
}