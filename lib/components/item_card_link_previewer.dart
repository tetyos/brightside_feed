import 'package:flutter/material.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

class ItemCardLinkPreviewer extends StatefulWidget {

  final String url;

  ItemCardLinkPreviewer({required this.url});

  @override
  _ItemCardLinkPreviewerState createState() => _ItemCardLinkPreviewerState();
}

class _ItemCardLinkPreviewerState extends State<ItemCardLinkPreviewer> {
  PreviewData? _previewData;

  @override
  Widget build(BuildContext context) {
    Future<PreviewData> previewData2 = getPreviewData(widget.url);
    return LinkPreview(
      enableAnimation: true,
      onPreviewDataFetched: (data) {
        setState(() {
          _previewData = data;
        });
      },
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      previewData: _previewData, // Pass the preview data from the state
      text: widget.url,
      width: MediaQuery.of(context).size.width,
    );
  }
}
