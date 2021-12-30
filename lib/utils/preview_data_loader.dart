import 'dart:async';
import 'dart:io';

import 'package:flutter_link_previewer/flutter_link_previewer.dart'
as FlutterLinkPreviewer;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:intl/intl.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:nexth/model/item_data.dart';

class PreviewDataLoader {

  static Future<ItemData> fetchDataFromUrl(String url, bool isDefaultPreviewDataLoader) async {
    ItemData itemData;

    if (isDefaultPreviewDataLoader) {
      WebInfo webInfo = await LinkPreview.scrapeFromURL(url);
      if (webInfo.type == LinkPreviewType.error) {
        throw HttpException("Could not read data for url");
      }
      itemData = ItemData(
          url: url,
          title: webInfo.title,
          description: webInfo.description,
          imageUrl: webInfo.image);
    } else {
      PreviewData previewData = await FlutterLinkPreviewer.getPreviewData(url);
      if (previewData.title == null) {
        throw HttpException("Could not read title for url");
      }
      String? imageURL = previewData.image == null ? null : previewData.image!.url;
      itemData = ItemData(url: previewData.link!,
          title: previewData.title!,
          description: previewData.description,
          imageUrl: imageURL);
    }

    await itemData.preLoadImage();
    return itemData;
  }

  static String? shortenDescriptionIfNecessary(String? description, int maxLength) {
    if (description == null || description == "")  {
      return null;
    }
    if (description.length > maxLength) {
      description = description.substring(0, maxLength);
      int posOfLastWhitespace = description.lastIndexOf(' ');
      if (posOfLastWhitespace != -1) {
        description = description.substring(0, posOfLastWhitespace);
      }
      description = description + "...";
    }
    return description;
  }

  static String getFormattedDateFromIso8601(String dateAsIso) {
    DateTime dateTime = DateTime.parse(dateAsIso);
    return DateFormat.yMMMd().format(dateTime);
  }

  static String getHostFromUrl(String url) {
    String host = Uri.parse(url).host;
    if (host.startsWith('www.')) {
      host = host.substring(4, host.length);
    }
    return host;
  }
}