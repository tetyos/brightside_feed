import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inspired/components/preview_data_loader.dart';

class ItemCardCustom extends StatelessWidget {
  final LinkPreviewData _linkPreviewData;

  ItemCardCustom({required LinkPreviewData linkPreviewData})
      : _linkPreviewData = linkPreviewData;

  @override
  Widget build(BuildContext context) {
    // Widget imageWidget = _linkPreviewData.image!;
    Widget imageWidget = _linkPreviewData.imageProvider == null ? SpinKitCircle(color: Colors.blueAccent) : Image(image: _linkPreviewData.imageProvider!);
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            imageWidget,
            ListTile(
              leading: Icon(Icons.album),
              title: Text(
                _linkPreviewData.title,
              ),
              subtitle: Text(_linkPreviewData.description),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {
                    /* ... */
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('LISTEN'),
                  onPressed: () {
                    /* ... */
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
