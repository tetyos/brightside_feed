import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inspired/utils/constants.dart' as Constants;
import 'package:inspired/utils/preview_data_loader.dart';

class AddUrlPreviewCard extends StatelessWidget {
  final ItemData _linkPreviewData;
  final String _description;

  AddUrlPreviewCard({required ItemData linkPreviewData})
      : _linkPreviewData = linkPreviewData,
        _description = linkPreviewData.description.length < 100
            ? linkPreviewData.description
            : linkPreviewData.description.substring(0, 100) + "...";

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _linkPreviewData.imageProvider == null ? SpinKitCircle(color: Colors.blueAccent) : Image(image: _linkPreviewData.imageProvider!);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Center(
        child: Card(
          color: Constants.kColorGreyLight,
          elevation: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              imageWidget,
              ListTile(
                title: Text(
                  _linkPreviewData.title,
                ),
                subtitle: Text(_description),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ItemData get linkPreviewData => _linkPreviewData;
}
