/// Helper class for generating the json-query that is needed for the HTTP-API.
class DatabaseQuery {

  String? sortBy;
  int? sortType;
  int? limit;
  /// skip-parameter only works if 'isFetchUserLikes' is true
  int? skip;
  List<String>? categories;
  String? incubatorStatus;
  String? dateLT;
  String? dateGT;
  String? voteType;
  bool? isFetchUserLikes;

  DatabaseQuery({this.sortBy, this.sortType, this.limit, this.categories, this.incubatorStatus, this.dateLT, this.dateGT, this.voteType, this.skip, this.isFetchUserLikes});

  Map<String, dynamic> toJson() => {
        if (sortBy != null) 'sortBy': sortBy,
        if (sortType != null) 'sortType': sortType,
        if (limit != null) 'limit': limit,
        if (skip != null && (isFetchUserLikes?? false)) 'skip': skip,
        if (categories != null) 'categories': categories,
        if (incubatorStatus != null) 'incubatorStatus': incubatorStatus,
        if (voteType != null) 'voteType': voteType,
        if (dateLT != null) 'dateLT': dateLT,
        if (dateGT != null) 'dateGT': dateGT,
        if (isFetchUserLikes != null) 'isFetchUserLikes': isFetchUserLikes,
      };
}