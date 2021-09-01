import 'package:flutter/material.dart';
import 'package:inspired/simple_url_preview/simple_url_preview.dart';

class ItemCard2 extends StatelessWidget {

  final String url;

  ItemCard2({this.url});


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
