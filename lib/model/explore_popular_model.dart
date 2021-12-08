import 'package:nexth/backend_connection/api_key_identifier.dart' as APIKeys;
import 'package:nexth/backend_connection/database_query.dart';
import 'package:nexth/model/item_list_model.dart';
import 'package:nexth/model/vote_model.dart';

class ExplorePopularModel extends ItemListModel {

  @override
  final int itemsToFetchDuringAppStart = 0;
  @override
  final int imagesToPreloadDuringAppStart = 0;

  final Periodicity periodicity;
  final VoteType votingType;

  ExplorePopularModel({required this.periodicity, required this.votingType});

  @override
  DatabaseQuery? getDBQueryForInitialization() {
    return null;
  }

  @override
  DatabaseQuery getDBQuery() {
    return new DatabaseQuery(sortBy: APIKeys.searchQuery_SortBy_DateAdded, limit: numberOfItemsToRequest, dateGT: getStartingDate(periodicity));
  }

  @override
  DatabaseQuery getMoreItemsDBQuery(String ltDate) {
    return new DatabaseQuery(sortBy: APIKeys.searchQuery_SortBy_DateAdded, limit: numberOfItemsToRequest, dateGT: getStartingDate(periodicity));
  }
}

String? getStartingDate(Periodicity periodicity) {
  DateTime currentDate = DateTime.now();
  DateTime resultingDate = DateTime.now();
  switch (periodicity) {
    case Periodicity.allTime:
      return null;
    case Periodicity.day:
      resultingDate = currentDate.subtract(Duration(days:1));
      break;
    case Periodicity.week:
      resultingDate = currentDate.subtract(Duration(days:7));
      break;
    case Periodicity.month:
      resultingDate = currentDate.subtract(Duration(days:31));
      break;
    case Periodicity.year:
      resultingDate = currentDate.subtract(Duration(days:365));
      break;
  }
  return resultingDate.toIso8601String();
}

enum Periodicity {
  day, week, month, year, allTime
}


extension PeriodicityExtension on Periodicity {
  String get displayTitle {
    switch (this) {
      case Periodicity.day:
        return 'Last day';
      case Periodicity.week:
        return 'Last week';
      case Periodicity.month:
        return 'Last month';
      case Periodicity.year:
        return 'Last year';
      case Periodicity.allTime:
        return 'All time';
    }
  }
}