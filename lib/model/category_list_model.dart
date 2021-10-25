import 'package:nexth/backend_connection/database_query.dart';
import 'package:nexth/model/item_list_model.dart';
import 'package:nexth/model/model_manager.dart';

class CategoryListModel extends ItemListModel {

  @override
  int itemsToFetchDuringAppStart = 5;
  @override
  int imagesToPreloadDuringAppStart = 3;

  final ItemCategory itemCategory;

  CategoryListModel({required this.itemCategory});

  @override
  DatabaseQuery? getDBQueryForInitialization() {
    if (itemsToFetchDuringAppStart <= 0) return null;
    return new DatabaseQuery(sortBy: "dateAdded", limit: itemsToFetchDuringAppStart, categories: [itemCategory.toString()]);
  }

  @override
  DatabaseQuery getDBQuery() {
    return new DatabaseQuery(sortBy: "dateAdded", limit: numberOfItemsToRequest, categories: [itemCategory.toString()]);
  }

  @override
  DatabaseQuery getMoreItemsDBQuery(String dateLT) {
    return new DatabaseQuery(sortBy: "dateAdded", limit: numberOfItemsToRequest, categories: [itemCategory.toString()], dateLT: dateLT);
  }
}