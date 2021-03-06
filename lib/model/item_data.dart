import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brightside_feed/model/category_tree_model.dart';
import 'package:brightside_feed/backend_connection/api_key_identifier.dart' as API_Identifier;
import 'package:brightside_feed/model/list_models/incubator_list_model.dart';
import 'package:brightside_feed/model/model_manager.dart';
import 'package:brightside_feed/model/vote_model.dart';
import 'package:brightside_feed/utils/preview_data_loader.dart';

class ItemData {
  String id;
  String title;
  String? description;
  CachedNetworkImageProvider? imageProvider;
  String url;
  String dateAdded;
  String? datePublished;
  String? dateScraped;
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
        dateScraped = json['dateScraped'],
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
    dateScraped = newJson['dateScraped'];
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

  Future<void> preLoadImage() async {
    if (imageUrl != null) {
      final completer = Completer<void>();
      this.imageProvider = CachedNetworkImageProvider(imageUrl!, maxWidth: 800);
      ImageStream imageStream = imageProvider!.resolve(ImageConfiguration.empty);
      late ImageStreamListener streamListener;

      final onError = (Object error, StackTrace? stackTrace) {
        completer.completeError(error, stackTrace);
      };

      final listener = (ImageInfo info, bool _) {
        if (!completer.isCompleted) {
          //print('Completer complete' + imageUrl!);
          completer.complete();
        }
        imageStream.removeListener(streamListener);
      };

      streamListener = ImageStreamListener(listener, onError: onError);

      imageStream.addListener(streamListener);
      await completer.future.onError((error, stackTrace) {
        imageProvider = null;
      });
      //print('Future complete' + imageUrl!);
    }
  }
}