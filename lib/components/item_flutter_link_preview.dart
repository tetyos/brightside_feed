import 'package:flutter/material.dart';
import 'package:flutter_link_preview/flutter_link_preview.dart';

class ItemFlutterLinkPreview extends StatelessWidget {

  final String url;

  ItemFlutterLinkPreview({this.url});


  @override
  Widget build(BuildContext context) {
    return FlutterLinkPreview(
      url: url,
      titleStyle: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}