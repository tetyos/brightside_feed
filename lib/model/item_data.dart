import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexth/model/category_tree_model.dart';
import 'package:nexth/backend_connection/api_key_identifier.dart' as API_Identifier;
import 'package:nexth/model/list_models/incubator_list_model.dart';
import 'package:nexth/model/model_manager.dart';
import 'package:nexth/model/vote_model.dart';
import 'package:nexth/utils/preview_data_loader.dart';
import 'package:nexth/utils/ui_utils.dart';

class ItemData {
  String id;
  String title;
  String? description;
  FadeInImage? fadeInImage;
  String url;
  String dateAdded;
  String? datePublished;
  String? imageUrl;
  List<CategoryElement> categories = [];
  IncubatorType? incubatorStatus;

  UpVoteModel upVoteModel;
  ImpactVoteModel impactVoteModel;
  InspiringVoteModel inspiringVoteModel;
  WellWrittenVoteModel wellWrittenVoteModel;

  ItemData(
      {required this.url,
      required this.title,
      String? description,
      this.imageUrl,
      List<CategoryElement>? categories})
      : id = "",
        description = PreviewDataLoader.shortenDescriptionIfNecessary(description, 300),
        categories = categories ?? [],
        dateAdded = DateTime.now().toIso8601String(),
        upVoteModel = UpVoteModel.empty(),
        impactVoteModel = ImpactVoteModel.empty(),
        inspiringVoteModel = InspiringVoteModel.empty(),
        wellWrittenVoteModel = WellWrittenVoteModel.empty();

  ItemData.fromJson(Map<String, dynamic> json)
      : id = json[API_Identifier.itemId],
        url = json['url'],
        dateAdded = json['dateAdded'] ?? DateTime.now().toIso8601String(),
        datePublished = json['datePublished'],
        title = json['title'],
        description = json['description'],
        imageUrl = json['imageUrl'],
        categories = ModelManager.instance.getItemCategoriesFromJson(json['categories']),
        incubatorStatus = getIncubatorTypeFromString(json['incubatorStatus']),
        upVoteModel = UpVoteModel(
            itemId: json[API_Identifier.itemId],
            numberOfRatings: json[API_Identifier.totalUpVotes] ?? 0,
            voted: false),
        impactVoteModel = ImpactVoteModel(
            itemId: json[API_Identifier.itemId],
            numberOfRatings: json[API_Identifier.totalImpactVotes] ?? 0,
            voted: false),
        inspiringVoteModel = InspiringVoteModel(
            itemId: json[API_Identifier.itemId],
            numberOfRatings: json[API_Identifier.totalInspiringVotes] ?? 0,
            voted: false),
        wellWrittenVoteModel = WellWrittenVoteModel(
            itemId: json[API_Identifier.itemId],
            numberOfRatings: json[API_Identifier.totalWellWrittenVotes] ?? 0,
            voted: false) {
    List<dynamic>? userVotesArray = json['userVotes'];
    if (userVotesArray != null) {
      upVoteModel.voted = userVotesArray.contains(API_Identifier.upVote);
      impactVoteModel.voted = userVotesArray.contains(API_Identifier.impactVote);
      inspiringVoteModel.voted = userVotesArray.contains(API_Identifier.inspiringVote);
      wellWrittenVoteModel.voted = userVotesArray.contains(API_Identifier.wellWrittenVote);
    }
  }

  ItemData update(Map<String, dynamic> newJson) {
    url = newJson['url'];
    dateAdded = newJson['dateAdded'];
    datePublished = newJson['datePublished'];
    title = newJson['title'];
    description = newJson['description'];
    imageUrl = newJson['imageUrl'];
    categories = ModelManager.instance.getItemCategoriesFromJson(newJson['categories']);
    upVoteModel.numberOfRatings = newJson[API_Identifier.totalUpVotes] ?? 0;
    impactVoteModel.numberOfRatings = newJson[API_Identifier.totalImpactVotes] ?? 0;
    inspiringVoteModel.numberOfRatings = newJson[API_Identifier.totalInspiringVotes] ?? 0;
    wellWrittenVoteModel.numberOfRatings = newJson[API_Identifier.totalWellWrittenVotes] ?? 0;

    List<dynamic>? userVotesArray = newJson['userVotes'];
    if (userVotesArray != null) {
      upVoteModel.voted = userVotesArray.contains(API_Identifier.upVote);
      impactVoteModel.voted = userVotesArray.contains(API_Identifier.impactVote);
      inspiringVoteModel.voted = userVotesArray.contains(API_Identifier.inspiringVote);
      wellWrittenVoteModel.voted = userVotesArray.contains(API_Identifier.wellWrittenVote);
    } else {
      upVoteModel.voted = false;
      impactVoteModel.voted = false;
      inspiringVoteModel.voted = false;
      wellWrittenVoteModel.voted = false;
    }
    return this;
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'url': url,
    'imageUrl': imageUrl,
    'categories': categories,
  };

  Future<void> preLoadImage(BuildContext context) async {
    if (imageUrl != null) {
      fadeInImage = FadeInImage.memoryNetwork(placeholder: UIUtils.kTransparentImage, image: imageUrl!, width: 800, imageCacheWidth: 800, placeholderCacheWidth: 800,);
      await precacheImage(fadeInImage!.image, context);
    }
  }
}