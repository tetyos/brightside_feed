import 'dart:async';
import 'package:flutter/material.dart';
import 'package:link_preview_generator/link_preview_generator.dart';

class ItemCardLinkPreviewGenerator extends StatelessWidget {

  final String url;

  ItemCardLinkPreviewGenerator({required this.url});


  @override
  Widget build(BuildContext context) {
    final Future<WebInfo> info = LinkPreview.scrapeFromURL(url);
    info.then(webinfo);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal:  2.0),
      child: LinkPreviewGenerator(
        bodyMaxLines: 5,
        link: url,
        linkPreviewStyle: LinkPreviewStyle.large,
        showGraphic: true,
      ),
    );
  }

  String webinfo(value) {
    return value.title;
  }
}
