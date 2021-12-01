import 'package:nexth/backend_connection/api_key_identifier.dart' as APIKeys;
import 'package:nexth/backend_connection/database_query.dart';
import 'package:nexth/model/item_list_model.dart';

class HomeListModel extends ItemListModel {

  @override
  final int itemsToFetchDuringAppStart = 10;
  @override
  final int imagesToPreloadDuringAppStart = 3;

  @override
  DatabaseQuery? getDBQueryForInitialization() {
    if (itemsToFetchDuringAppStart <= 0) return null;
    return new DatabaseQuery(sortBy: APIKeys.searchQuery_SortBy_DateAdded, limit: itemsToFetchDuringAppStart);
  }

  @override
  DatabaseQuery getDBQuery() {
    return new DatabaseQuery(sortBy: APIKeys.searchQuery_SortBy_DateAdded, limit: numberOfItemsToRequest);
  }

  @override
  DatabaseQuery getMoreItemsDBQuery(String ltDate) {
    return new DatabaseQuery(sortBy: APIKeys.searchQuery_SortBy_DateAdded, limit: numberOfItemsToRequest, dateLT: ltDate);
  }
}