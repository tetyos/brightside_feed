import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nexth/utils/preview_data_loader.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemCardCustom extends StatelessWidget {
  final ItemData _linkPreviewData;

  ItemCardCustom({required ItemData linkPreviewData})
      : _linkPreviewData = linkPreviewData;

  @override
  Widget build(BuildContext context) {
    // Widget imageWidget = _linkPreviewData.image!;
    Widget imageWidget = _linkPreviewData.imageProvider == null ? SpinKitCircle(color: Colors.blueAccent) : Image(image: _linkPreviewData.imageProvider!);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: GestureDetector (
        onTap: launchUrl,
        child: Center(
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
        ),
      ),
    );
  }

  void launchUrl() async {
        String url = _linkPreviewData.url;
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          try {
            await launch(url);
          } catch (err) {
            throw Exception('Could not launch $url. Error: $err');
          }
        }
      }

  ItemData get linkPreviewData => _linkPreviewData;
}
