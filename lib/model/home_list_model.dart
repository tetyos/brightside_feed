import 'package:nexth/model/database_query.dart';
import 'package:nexth/model/item_list_model.dart';

class HomeListModel extends ItemListModel {

  @override
  DatabaseQuery getDatabaseQueryForInitialization() {
    return new DatabaseQuery(sortBy: "dateAdded", limit: 10);
  }
}