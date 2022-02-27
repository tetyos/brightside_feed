import 'package:flutter/material.dart';
import 'package:brightside_feed/model/item_data.dart';
import 'package:brightside_feed/utils/preview_data_loader.dart';

class AddUrlPreviewCard extends StatelessWidget {
  final ItemData _linkPreviewData;
  final String? _description;

  AddUrlPreviewCard({required ItemData linkPreviewData})
      : _linkPreviewData = linkPreviewData,
        _description = PreviewDataLoader.shortenDescriptionIfNecessary(linkPreviewData.description, 100);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _linkPreviewData.imageProvider == null
        ? Image.asset('images/default_card_images/no_picture.png')
        : Image(image: _linkPreviewData.imageProvider!);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Center(
        child: Card(
          color: Colors.white,
          elevation: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              imageWidget,
              ListTile(
                title: Text(
                  _linkPreviewData.title,
                ),
                subtitle: _description == null ? null : Text(_description!),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ItemData get linkPreviewData => _linkPreviewData;
}
