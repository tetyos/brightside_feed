import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart'
as FlutterLinkPreviewer;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:nexth/screens/item_list_view_model.dart';
import 'package:link_preview_generator/link_preview_generator.dart';

class PreviewDataLoader {
  static final RegExp _twitterUrl =
  RegExp(r'^(https?:\/\/(www)?\.?)?twitter\.com\/.+');

  static Future<ItemData> fetchDataFromUrl(String url) async {
    ItemData itemData;
    if (!isTwitter(url)) {
      PreviewData previewData = await FlutterLinkPreviewer.getPreviewData(url);
      String? imageURL = previewData.image == null ? null : previewData.image!.url;
      itemData = ItemData(url: previewData.link!,
          title: previewData.title,
          description: previewData.description,
          imageUrl: imageURL);
    } else {
      WebInfo webInfo = await LinkPreview.scrapeFromURL(url);
      itemData = ItemData(
          url: url,
          title: webInfo.title,
          description: webInfo.description,
          imageUrl: webInfo.image);
    }
    // print('\n\n\nLinkPreviewData('
    //     +' url: \'' + itemData.url + '\','
    //     +'title: \'' + itemData.title + '\','
    //     +'description: \'' + itemData.description + '\','
    //     +'imageUrl: \'' + itemData.imageUrl! + '\'),');
    await itemData.preLoadImage();
    return itemData;
  }

  static bool isTwitter(String url) => _twitterUrl.hasMatch(url);
}

class ItemData {
  String title = "Undefined";
  String description = "Undefined";
  CachedNetworkImage? image;
  CachedNetworkImageProvider? imageProvider;
  String url;
  String? imageUrl;
  ItemCategory? itemCategory;

  ItemData({required this.url, String? title, String? description, this.imageUrl, this.itemCategory}) {
    if (title != null) {
      this.title = title;
    }
    if (description != null) {
      this.description = description;
    }
    // if (imageUrl != null) {
    //   this.image = CachedNetworkImage(
    //     imageUrl: imageUrl!,
    //     maxWidthDiskCache: 800,
    //     progressIndicatorBuilder: (context, url, progress) =>  SpinKitCircle(color: Colors.blueAccent),
    //   //   // todo add future or listener to image, so that we know when its finished loading
    //   );
    // }
  }

  ItemData.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? 'Undefined',
        description = json['description'] ?? 'Undefined',
        url = json['url'] ?? '',
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