import 'package:nexth/backend_connection/api_key_identifier.dart' as API_Identifier;
import 'package:nexth/backend_connection/database_query.dart';
import 'package:nexth/model/category_tree_model.dart';
import 'package:nexth/model/category_tree_tech.dart';
import 'package:nexth/model/list_models/item_list_model.dart';

class CategoryListModel extends ItemListModel {
  @override
  int itemsToFetchDuringAppStart = 0;
  @override
  int imagesToPreloadDuringAppStart = 0;

  List<CategoryElement> categories = [storageCategory];

  CategoryListModel();

  @override
  DatabaseQuery? getDBQueryForInitialization() {
    if (itemsToFetchDuringAppStart <= 0) return null;
    return new DatabaseQuery(
        sortBy: API_Identifier.searchQuery_SortBy_DateAdded,
        limit: itemsToFetchDuringAppStart,
        categories: categories);
  }

  @override
  DatabaseQuery getDBQuery() {
    return new DatabaseQuery(
        sortBy: API_Identifier.searchQuery_SortBy_DateAdded,
        limit: numberOfItemsToRequest,
        categories: categories);
  }

  @override
  DatabaseQuery getMoreItemsDBQuery(String dateLT) {
    return new DatabaseQuery(
        sortBy: API_Identifier.searchQuery_SortBy_DateAdded,
        limit: numberOfItemsToRequest,
        categories: categories,
        dateLT: dateLT);
  }
}
