import 'package:nexth/backend_connection/api_key_identifier.dart' as APIKeys;
import 'package:nexth/backend_connection/database_query.dart';
import 'package:nexth/model/item_list_model.dart';

class IncubatorListModel extends ItemListModel {

  @override
  final int itemsToFetchDuringAppStart = 0;
  @override
  final int imagesToPreloadDuringAppStart = 0;

  final IncubatorType incubatorType;

  IncubatorListModel({required this.incubatorType});

  @override
  DatabaseQuery? getDBQueryForInitialization() {
    return null;
  }

  @override
  DatabaseQuery getDBQuery() {
    return new DatabaseQuery(sortBy: APIKeys.searchQuery_SortBy_DateAdded, limit: numberOfItemsToRequest, incubatorStatus: incubatorType.key);
  }

  @override
  DatabaseQuery getMoreItemsDBQuery(String ltDate) {
    return new DatabaseQuery(sortBy: APIKeys.searchQuery_SortBy_DateAdded, limit: numberOfItemsToRequest, dateLT: ltDate, incubatorStatus: incubatorType.key);
  }
}

enum IncubatorType {inc1, unsafe}

extension IncubatorTypeExtension on IncubatorType {
  String get key {
    switch (this) {
      case IncubatorType.inc1:
        return 'inc1';
      case IncubatorType.unsafe:
        return 'unsafe';
    }
  }
}