/// Helper class for generating the json-query that is needed for the HTTP-API.
class DatabaseQuery {

  String? sortBy;
  int? sortType;
  int? limit;
  List<String>? categories;

  DatabaseQuery({this.sortBy, this.sortType, this.limit, this.categories});


  Map<String, dynamic> toJson() => {
    'sortBy': sortBy,
    'sortType': sortType,
    'limit': limit,
    'categories' : categories,
  };
}