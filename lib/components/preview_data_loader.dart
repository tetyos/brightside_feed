import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart'
as FlutterLinkPreviewer;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:link_preview_generator/link_preview_generator.dart';

class PreviewDataLoader {
  static final RegExp _twitterUrl =
  RegExp(r'^(https?:\/\/(www)?\.?)?twitter\.com\/.+');

  static Future<LinkPreviewData> fetchDataFromUrl(String url) async {
    LinkPreviewData linkPreviewData;
    if (!isTwitter(url)) {
      PreviewData previewData = await FlutterLinkPreviewer.getPreviewData(url);
      String? imageURL = previewData.image == null ? null : previewData.image!.url;
      linkPreviewData = LinkPreviewData(url: previewData.link!,
          title: previewData.title,
          description: previewData.description,
          imageUrl: imageURL);
    } else {
      WebInfo webInfo = await LinkPreview.scrapeFromURL(url);
      linkPreviewData = LinkPreviewData(
          url: url,
          title: webInfo.title,
          description: webInfo.description,
          imageUrl: webInfo.image);
    }
    await linkPreviewData.preLoadImage();
    return linkPreviewData;
  }

  static bool isTwitter(String url) => _twitterUrl.hasMatch(url);
}

class LinkPreviewData {
  String title = "Undefined";
  String description = "Undefined";
  CachedNetworkImage? image;
  CachedNetworkImageProvider? imageProvider;
  String url;
  String? imageUrl;

  LinkPreviewData({required this.url, String? title, String? description, this.imageUrl, }) {
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
          print('Completer complete' + imageUrl!);
          completer.complete();
        }
        imageStream.removeListener(streamListener);
      };

      streamListener = ImageStreamListener(listener, onError: onError);

      imageStream.addListener(streamListener);
      await completer.future;
      print('Future complete' + imageUrl!);
    }
  }
}