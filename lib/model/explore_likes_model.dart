import 'package:nexth/backend_connection/api_key_identifier.dart' as APIKeys;
import 'package:nexth/backend_connection/database_query.dart';
import 'package:nexth/model/item_list_model.dart';

class ExploreLikesModel extends ItemListModel {

  @override
  final int itemsToFetchDuringAppStart = 0;
  @override
  final int imagesToPreloadDuringAppStart = 0;

  @override
  DatabaseQuery? getDBQueryForInitialization() {
    return null;
  }

  @override
  DatabaseQuery getDBQuery() {
    return new DatabaseQuery(sortBy: APIKeys.searchQuery_SortBy_lastVoteOn, limit: numberOfItemsToRequest, isFetchUserLikes: true);
  }

  @override
  DatabaseQuery getMoreItemsDBQuery(String ltDate) {
    return new DatabaseQuery(sortBy: APIKeys.searchQuery_SortBy_lastVoteOn, limit: numberOfItemsToRequest, skip: items.length, isFetchUserLikes: true);
  }
}