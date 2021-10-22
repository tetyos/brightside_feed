import 'dart:async';

import 'package:flutter_link_previewer/flutter_link_previewer.dart'
as FlutterLinkPreviewer;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:nexth/model/item_data.dart';

class PreviewDataLoader {
  static final RegExp _twitterUrl =
  RegExp(r'^(https?:\/\/(www)?\.?)?twitter\.com\/.+');

  static Future<ItemData> fetchDataFromUrl(String url) async {
    ItemData itemData;
    if (!isTwitter(url)) {
      PreviewData previewData = await FlutterLinkPreviewer.getPreviewData(url);
      String title = previewData.title ?? "Undefined"; // todo return null or throw exception or something
      String? imageURL = previewData.image == null ? null : previewData.image!.url;
      itemData = ItemData(url: previewData.link!,
          title: title,
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