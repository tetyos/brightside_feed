import 'package:flutter/material.dart';
import 'package:brightside_feed/components/more_menu.dart';
import 'package:brightside_feed/components/vote_buttons.dart';
import 'package:brightside_feed/model/item_data.dart';
import 'package:brightside_feed/navigation/app_state.dart';
import 'package:brightside_feed/utils/constants.dart';
import 'package:brightside_feed/utils/preview_data_loader.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class IncubatorUnsafeCard extends StatelessWidget {
  final ItemData _itemData;
  final String? _shortDescription;
  final String _dateString;
  final String _host;
  final bool isAdminCard;

  IncubatorUnsafeCard({required ItemData linkPreviewData, this.isAdminCard = false})
      : _itemData = linkPreviewData,
        _dateString = PreviewDataLoader.getFormattedDateFromIso8601(linkPreviewData.dateAdded),
        _shortDescription =
            PreviewDataLoader.shortenDescriptionIfNecessary(linkPreviewData.description, 150),
        _host = PreviewDataLoader.getHostFromUrl(linkPreviewData.url);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: GestureDetector(
        onTap: () => showOpenUrlDialog(context),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 800),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                        VoteButtons(itemData: _itemData),
                        MoreMenu(itemData: _itemData, buttonColor: Colors.grey,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget renderDate(BuildContext context) {
    Widget dateText = Text(
      _dateString,
      style: TextStyle(color: Colors.grey[500]),
    );

    if (isAdminCard) {
      return GestureDetector(onTap: () => showDetailScreen(context), child: dateText);
    }
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

  void showDetailScreen(BuildContext context) {
    Provider.of<AppState>(context, listen: false).currentSelectedItem = _itemData;
  }

  ItemData get linkPreviewData => _itemData;
}
