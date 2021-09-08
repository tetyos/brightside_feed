import 'package:flutter/material.dart';
import 'package:link_preview_flutter/link_preview_flutter.dart';
import 'package:simple_url_preview/simple_url_preview.dart';

class ItemCardLinkPreview extends StatefulWidget {
  final String url;

  ItemCardLinkPreview({required this.url});

  @override
  _ItemCardLinkPreviewState createState() => _ItemCardLinkPreviewState();
}

class _ItemCardLinkPreviewState extends State<ItemCardLinkPreview> {
  Widget? card;

  @override
  Widget build(BuildContext context) {
    // todo return widget with loading spinner and show stuff or error message as soon as something is there
    setLinkPreviewWidget();
    // return null;
    return Expanded(
      child: Center(child: card),
    );

    return SimpleUrlPreview(
      url: widget.url,
      previewHeight: 130,
      previewContainerPadding: EdgeInsets.all(10),
      titleLines: 2,
      descriptionLines: 3,
      imageLoaderColor: Colors.white,
      bgColor: Colors.grey,
    );
  }

  void setLinkPreviewWidget() async {
    Widget widget2 = await LinkPreviewFlutter.create(
        widget.url,
        type: 'square-image-up',
        size: 300,
        background: Colors.black,
        fontColor: Colors.white);
    setState(() {
      card = widget2;
    });
  }
}
