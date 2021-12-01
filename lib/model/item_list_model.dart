import 'package:nexth/backend_connection/database_query.dart';
import 'package:nexth/components/item_list_scroll_view.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/model_manager.dart';

/// The ItemListModel provides the basic functions for managing the model behind all item-lists.
abstract class ItemListModel {

  /// List which holds all items, whose images have already been preloaded.
  List<ItemData> fullyLoadedItems = [];
  List<ItemData> items = [];

  /// The number of items a model requests when app is starting. It is rather small, since during app start items are loaded for many models in one request.
  final int itemsToFetchDuringAppStart = 0;
  /// The number of images a model preloads during app start.
  final int imagesToPreloadDuringAppStart = 0;

  /// The number of items that need to be available after a user has opened a the scroll-view to which this model belongs.
  final int minNumberOfItems = 5;
  /// The number of fully loaded items that need to be available after a user has opened a the scroll-view to which this model belongs.
  final int minNumberOfFullyLoadedItems = 5;

  /// The number of unloaded item data, which should always be available (if possible).
  final int fetchItemDataThreshold = 5;

  /// The number of items a model requests, when request is executed standalone (aka. not during initialization)
  final int numberOfItemsToRequest = 25;

  bool _moreItemsAvailable = true;
  int _numberOfImagesCurrentlyLoading = 0;

  DatabaseQuery? getDBQueryForInitialization();

  DatabaseQuery getDBQuery();

  DatabaseQuery getMoreItemsDBQuery(String ltDate);

  /// Adds the given items to the model.<br>
  /// If less items are provided then were requested for initialization, it is assumed that no more items are currently available in DB.
  /// <br><br>
  /// Also loads the images for the first items of the model.
  Future<void> prepareModel(List<ItemData> initialItems) async {
    assert(initialItems.length <= itemsToFetchDuringAppStart, "More items were provided than requested. This should not happen.");

    _moreItemsAvailable = initialItems.length == itemsToFetchDuringAppStart;
    items.addAll(initialItems);
    await preloadNextItems(imagesToPreloadDuringAppStart);
  }

  /// Method checks if the min number of items has been requested and the min number of images is loaded.
  /// If not, it loads them.
  Future<void> assureMinNumberOfItems(bool isUserLoggedIn) async {
    if (_moreItemsAvailable && items.length < minNumberOfItems) {
      await requestMoreItemsFromDB(isUserLoggedIn);
    }
    // during initialization of an ItemListScrollView it can happen that no images have been preloaded (if no items had been requested so far)
    // => do it now
    int loadedItems = fullyLoadedItems.length + _numberOfImagesCurrentlyLoading;
    if (loadedItems < minNumberOfFullyLoadedItems) {
      await preloadNextItems(minNumberOfFullyLoadedItems - loadedItems);
    }
  }

  /// Preloads the images for the next items. Only preloaded items are used by [ItemListScrollView]
  Future<void> preloadNextItems(int numberOfItemsToPreload) async {
    int numberOfFullyLoadedItems = fullyLoadedItems.length;
    if (numberOfFullyLoadedItems == items.length) {
      return;
    }

    int to = numberOfFullyLoadedItems + numberOfItemsToPreload;
    _numberOfImagesCurrentlyLoading = numberOfItemsToPreload;
    if (to > items.length) {
      to = items.length;
      _numberOfImagesCurrentlyLoading = items.length - numberOfFullyLoadedItems;
    }
    List<ItemData> itemsToLoad = items.sublist(numberOfFullyLoadedItems, to);

    List<Future<void>> futures = [];
    for (ItemData linkPreviewData in itemsToLoad) {
      futures.add(linkPreviewData.preLoadImage());
    }
    await Future.wait(futures);
    _numberOfImagesCurrentlyLoading = 0;
    fullyLoadedItems.addAll(itemsToLoad);
  }

  /// Preloads the images for the first items. Only preloaded items are used by [ItemListScrollView]
  Future<void> preloadItemsAfterRefresh() async {
    int numberOfItemsToPreload = minNumberOfFullyLoadedItems > items.length ? items.length : minNumberOfFullyLoadedItems;
    _numberOfImagesCurrentlyLoading = numberOfItemsToPreload;
    List<ItemData> itemsToLoad = items.sublist(0, numberOfItemsToPreload);

    List<Future<void>> futures = [];
    for (ItemData linkPreviewData in itemsToLoad) {
      futures.add(linkPreviewData.preLoadImage());
    }
    await Future.wait(futures);
    _numberOfImagesCurrentlyLoading = 0;
    fullyLoadedItems = itemsToLoad;
  }

  Future<void> requestMoreItemsFromDB(bool isUserLoggedIn) async {
    DatabaseQuery dbQuery = items.length > 0 ? getMoreItemsDBQuery(items.last.dateAdded) : getDBQuery();
    List<ItemData> newItems = await ModelManager.instance.getItems(dbQuery, isUserLoggedIn);
    items.addAll(newItems);
    if (newItems.length < numberOfItemsToRequest) {
      // todo in case of backend error / network error or anything -> 0 items are currently returned. throw exception there and catch here
      _moreItemsAvailable = false;
    }
  }

  bool hasMoreItems() {
    return _moreItemsAvailable;
  }

  bool isEverythingLoaded() {
    return !_moreItemsAvailable &&
        fullyLoadedItems.length == items.length &&
        _numberOfImagesCurrentlyLoading == 0;
  }

  bool hasImagesToPreload() {
    return fullyLoadedItems.length < items.length;
  }

  bool hasNotEnoughItemsLeft() {
    bool isNotEnoughItemsLeft = items.length - fullyLoadedItems.length - _numberOfImagesCurrentlyLoading < fetchItemDataThreshold;
    return _moreItemsAvailable && isNotEnoughItemsLeft;
  }

  Future<void > executeRefresh(bool isUserLoggedIn) async {
    List<ItemData> newItems = await ModelManager.instance.getItems(getDBQuery(), isUserLoggedIn);
    items = newItems;
    if (newItems.length < numberOfItemsToRequest) {
      // todo in case of backend error / network error or anything -> 0 items are currently returned. throw exception there and catch here
      _moreItemsAvailable = false;
    }
    await preloadItemsAfterRefresh();
  }
}