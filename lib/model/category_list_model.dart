import 'package:nexth/backend_connection/database_query.dart';
import 'package:nexth/model/item_list_model.dart';
import 'package:nexth/model/model_manager.dart';

class CategoryListModel extends ItemListModel {

  final ItemCategory itemCategory;

  CategoryListModel({required this.itemCategory});

  @override
  DatabaseQuery getDatabaseQueryForInitialization() {
    return new DatabaseQuery(sortBy: "dateAdded", limit: 5, categories: [itemCategory.toString()]);
  }
}