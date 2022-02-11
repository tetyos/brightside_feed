import 'package:nexth/model/category_tree_model.dart';

/// Helper class for generating the json-query that is needed for the HTTP-API.
class DatabaseQuery {

  String? sortBy;
  int? sortType;
  int? limit;
  /// skip-parameter only works if 'isFetchUserLikes' is true
  int? skip;
  List<CategoryElement>? categories;
  String? incubatorStatus;
  String? dateLT;
  String? dateGT;
  String? datePublishedLT;
  String? datePublishedGT;
  String? dateScrapedLT;
  String? dateScrapedGT;
  String? voteType;
  bool? isFetchUserLikes;

  DatabaseQuery(
      {this.sortBy,
      this.sortType,
      this.limit,
      this.categories,
      this.incubatorStatus,
      this.dateLT,
      this.dateGT,
      this.datePublishedLT,
      this.datePublishedGT,
      this.dateScrapedLT,
      this.dateScrapedGT,
      this.voteType,
      this.skip,
      this.isFetchUserLikes});

  Map<String, dynamic> toJson() => {
        if (sortBy != null) 'sortBy': sortBy,
        if (sortType != null) 'sortType': sortType,
        if (limit != null) 'limit': limit,
        if (skip != null) 'skip': skip,
        if (categories != null) 'categories': categories,
        if (incubatorStatus != null) 'incubatorStatus': incubatorStatus,
        if (voteType != null) 'voteType': voteType,
        if (dateLT != null) 'dateLT': dateLT,
        if (datePublishedLT != null) 'datePublishedLT': datePublishedLT,
        if (datePublishedGT != null) 'datePublishedGT': datePublishedGT,
        if (dateScrapedLT != null) 'dateScrapedLT': dateScrapedLT,
        if (dateScrapedGT != null) 'dateScrapedGT': dateScrapedGT,
        if (dateGT != null) 'dateGT': dateGT,
        if (isFetchUserLikes != null) 'isFetchUserLikes': isFetchUserLikes,
      };
}