import 'package:flutter/material.dart';
import 'package:nexth/components/more_menu.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/utils/constants.dart';
import 'package:nexth/utils/preview_data_loader.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class IncubatorScrapedCard extends StatelessWidget {
  final ItemData _itemData;
  final String? _shortDescription;
  final String _dateString;
  final String _host;
  late final Widget imageWidget;
  final bool isAdminCard;

  IncubatorScrapedCard({required ItemData linkPreviewData, this.isAdminCard = false})
      : _itemData = linkPreviewData,
        _dateString = PreviewDataLoader.getFormattedDateFromIso8601(linkPreviewData.datePublished!),
        _shortDescription =
            PreviewDataLoader.shortenDescriptionIfNecessary(linkPreviewData.description, 150),
        _host = PreviewDataLoader.getHostFromUrl(linkPreviewData.url) {
    createImageWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: GestureDetector(
        onTap: () => launchWebView(context),
        child: Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                imageWidget,
                const SizedBox(height: 10),
                ListTile(
                  title: Text(
                    _itemData.title,
                  ),
                  subtitle: _shortDescription == null ? null : Text(_shortDescription!),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(_host, style: TextStyle(color: kColorPrimary, fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      Expanded(child: renderDate(context)),
                      MoreMenu(itemData: _itemData, buttonColor: Colors.grey,)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createImageWidget() {
    Image image;
    if (_itemData.imageProvider != null) {
      image = Image(image: _itemData.imageProvider!);
    } else {
      image = Image.asset('images/default_card_images/no_picture.png');
    }
    imageWidget = ClipRRect(
      child: image,
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget renderDate(BuildContext context) {
    Widget dateText = Text(
      _dateString,
      style: TextStyle(color: Colors.grey[500]),
    );
    return dateText;
  }

  void launchWebView(BuildContext context) async {
    Provider.of<AppState>(context, listen: false).currentWebViewItem = _itemData;
  }

  Future<void> showOpenUrlDialog(BuildContext context) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Open website'),
        content: Text(_itemData.url),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              launchUrl();
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void launchUrl() async {
    String url = _itemData.url;
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

  ItemData get linkPreviewData => _itemData;
}
