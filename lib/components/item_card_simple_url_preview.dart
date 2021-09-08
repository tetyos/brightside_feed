import 'package:flutter/material.dart';
import 'package:simple_url_preview/simple_url_preview.dart';

class ItemCardSimpleUrlPreview extends StatelessWidget {

  final String url;

  ItemCardSimpleUrlPreview({required this.url});


  @override
  Widget build(BuildContext context) {
    return SimpleUrlPreview(
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
