import 'package:nexth/backend_connection/api_key_identifier.dart' as API_Identifier;
import 'package:nexth/backend_connection/database_query.dart';
import 'package:nexth/model/list_models/item_list_model.dart';

class IncubatorListModel extends ItemListModel {
  @override
  final int itemsToFetchDuringAppStart = 0;
  @override
  final int imagesToPreloadDuringAppStart = 0;

  @override
  final bool isPreloadImages;

  final IncubatorType incubatorType;

  IncubatorListModel({required this.incubatorType, this.isPreloadImages = true});

  @override
  DatabaseQuery? getDBQueryForInitialization() {
    return null;
  }

  @override
  DatabaseQuery getDBQuery() {
    String sortBy = incubatorType == IncubatorType.scraped
        ? API_Identifier.searchQuery_SortBy_DateScraped
        : API_Identifier.searchQuery_SortBy_DateAdded;
    return new DatabaseQuery(
        sortBy: sortBy,
        limit: numberOfItemsToRequest,
        incubatorStatus: incubatorType.identifier);
  }

  @override
  DatabaseQuery getMoreItemsDBQuery(String ltDate) {
    if (incubatorType == IncubatorType.scraped) {
      return new DatabaseQuery(
          sortBy: API_Identifier.searchQuery_SortBy_DateScraped,
          limit: numberOfItemsToRequest,
          dateScrapedLT: items.last.dateScraped!,
          incubatorStatus: incubatorType.identifier);
    }
    return new DatabaseQuery(
        sortBy: API_Identifier.searchQuery_SortBy_DateAdded,
        limit: numberOfItemsToRequest,
        dateLT: ltDate,
        incubatorStatus: incubatorType.identifier);
  }
}

enum IncubatorType { inc1, unsafe, scraped}

IncubatorType? getIncubatorTypeFromString(String? incubatorType) {
  if (incubatorType == null) return null;
  if (incubatorType == IncubatorType.inc1.identifier) return IncubatorType.inc1;
  if (incubatorType == IncubatorType.unsafe.identifier) return IncubatorType.unsafe;
  if (incubatorType == IncubatorType.scraped.identifier) return IncubatorType.scraped;
}

extension IncubatorTypeExtension on IncubatorType {
  String get identifier {
    switch (this) {
      case IncubatorType.inc1:
        return 'inc1';
      case IncubatorType.unsafe:
        return 'unsafe';
      case IncubatorType.scraped:
        return 'scraped';
    }
  }

  int get tabNumber {
    switch (this) {
      case IncubatorType.scraped:
        return 1;
      case IncubatorType.inc1:
        return 0;
      case IncubatorType.unsafe:
        return 2;
    }
  }
}
