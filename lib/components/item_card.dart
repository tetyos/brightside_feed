import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nexth/model/item_data.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemCard extends StatelessWidget {
  final ItemData _linkPreviewData;

  ItemCard({required ItemData linkPreviewData})
      : _linkPreviewData = linkPreviewData;

  @override
  Widget build(BuildContext context) {
    // Widget imageWidget = _linkPreviewData.image!;
    Widget imageWidget = _linkPreviewData.imageProvider == null
        ? SpinKitCircle(color: Colors.blueAccent)
        : ClipRRect(child: Image(image: _linkPreviewData.imageProvider!), borderRadius: BorderRadius.circular(8),);
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
                const SizedBox(height: 10),
                ListTile(
                  title: Text(
                    _linkPreviewData.title,
                  ),
                  subtitle: Text(_linkPreviewData.description),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: Text(Uri.parse(_linkPreviewData.url).host),
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
