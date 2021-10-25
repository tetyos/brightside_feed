/// Helper class for generating the json-query that is needed for the HTTP-API.
class DatabaseQuery {

  String? sortBy;
  int? sortType;
  int? limit;
  List<String>? categories;
  String? dateLT;
  String? dateGT;

  DatabaseQuery({this.sortBy, this.sortType, this.limit, this.categories, this.dateLT, this.dateGT});

  Map<String, dynamic> toJson() => {
        if (sortBy != null) 'sortBy': sortBy,
        if (sortType != null) 'sortType': sortType,
        if (limit != null) 'limit': limit,
        if (categories != null) 'categories': categories,
        if (dateLT != null) 'dateLT': dateLT,
        if (dateGT != null) 'dateGT': dateGT,
      };
}