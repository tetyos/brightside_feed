import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexth/model/category_list_model.dart';
import 'package:nexth/backend_connection/api_key_identifier.dart' as APIKeys;
import 'package:nexth/model/vote_model.dart';
import 'package:nexth/utils/preview_data_loader.dart';

class ItemData {
  String id;
  String title;
  String? description;
  CachedNetworkImage? image;
  CachedNetworkImageProvider? imageProvider;
  String url;
  String dateAdded;
  String? imageUrl;
  ItemCategory? itemCategory;

  UpVoteModel upVoteModel;
  ImpactVoteModel impactVoteModel;

  ItemData(
      {required this.url,
      required this.title,
      String? description,
      this.imageUrl,
      this.itemCategory})
      : id = "",
        description = PreviewDataLoader.shortenDescriptionIfNecessary(description, 300),
        dateAdded = DateTime.now().toIso8601String(),
        upVoteModel = UpVoteModel.empty(),
        impactVoteModel = ImpactVoteModel.empty();

  ItemData.fromJson(Map<String, dynamic> json)
      : id = json[APIKeys.itemId],
        url = json['url'],
        dateAdded = json['dateAdded'],
        title = json['title'],
        description = json['description'],
        imageUrl = json['imageUrl'],
        itemCategory = getItemCategoryFromString(json['itemCategory']),
        upVoteModel = UpVoteModel(
            itemId: json[APIKeys.itemId],
            numberOfRatings: json[APIKeys.totalUpVotes] ?? 0,
            voted: false),
        impactVoteModel = ImpactVoteModel(
            itemId: json[APIKeys.itemId],
            numberOfRatings: json[APIKeys.totalImpactVotes] ?? 0,
            voted: false) {
    List<dynamic>? userVotesArray = json['userVotes'];
    if (userVotesArray != null) {
      upVoteModel.voted = userVotesArray.contains(APIKeys.postUpVote);
      impactVoteModel.voted = userVotesArray.contains(APIKeys.postImpactVote);
    }
  }

  ItemData update(Map<String, dynamic> newJson) {
    url = newJson['url'];
    dateAdded = newJson['dateAdded'];
    title = newJson['title'];
    description = newJson['description'];
    imageUrl = newJson['imageUrl'];
    itemCategory = getItemCategoryFromString(newJson['itemCategory']);
    upVoteModel.numberOfRatings = newJson[APIKeys.totalUpVotes] ?? 0;
    impactVoteModel.numberOfRatings = newJson[APIKeys.totalImpactVotes] ?? 0;
    List<dynamic>? userVotesArray = newJson['userVotes'];
    if (userVotesArray != null) {
      upVoteModel.voted = userVotesArray.contains(APIKeys.postUpVote);
      impactVoteModel.voted = userVotesArray.contains(APIKeys.postImpactVote);
    } else {
      upVoteModel.voted = false;
      impactVoteModel.voted = false;
    }
    return this;
  }

  Map<String, String?> toJson() => {
    'title': title,
    'description': description,
    'url': url,
    'imageUrl': imageUrl,
    'itemCategory' : itemCategory.toString(),
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