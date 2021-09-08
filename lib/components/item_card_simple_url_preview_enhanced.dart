import 'package:flutter/material.dart';
import 'package:inspired/simple_url_preview_enhanced/simple_url_preview_enhanced.dart';

class ItemCardSimpleUrlPreviewEnhanced extends StatelessWidget {

  final String url;

  ItemCardSimpleUrlPreviewEnhanced({required this.url});


  @override
  Widget build(BuildContext context) {
    return SimpleUrlPreviewEnhanced(
      url: url,
      previewHeight: 130,
      previewContainerPadding: EdgeInsets.all(10),
      titleLines: 2,
      descriptionLines: 3,
      imageLoaderColor: Colors.white,
      bgColor: Colors.grey,
    );
  }
}
