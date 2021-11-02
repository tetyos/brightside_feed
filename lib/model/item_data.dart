import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexth/model/model_manager.dart';
import 'package:nexth/utils/preview_data_loader.dart';

class ItemData {
  String title;
  String? description;
  CachedNetworkImage? image;
  CachedNetworkImageProvider? imageProvider;
  String url;
  String dateAdded;
  String? imageUrl;
  ItemCategory? itemCategory;

  ItemData(
      {required this.url,
      required this.title,
      String? description,
      this.imageUrl,
      this.itemCategory})
      : description = PreviewDataLoader.shortenDescriptionIfNecessary(description, 300),
        dateAdded = DateTime.now().toIso8601String();

  ItemData.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        dateAdded = json['dateAdded'],
        title = json['title'],
        description = json['description'],
        imageUrl = json['imageUrl'],
        itemCategory = getItemCategoryFromString(json['itemCategory']);

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