import 'package:flutter/material.dart';
import 'package:nexth/components/vote_buttons.dart';
import 'package:nexth/model/category_list_model.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/utils/constants.dart';
import 'package:nexth/utils/preview_data_loader.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemCard2 extends StatelessWidget {
  final ItemData _itemData;
  final String? _shortDescription;
  final String _dateString;
  final String _host;
  late final Widget imageWidget;
  final bool isAdminCard;

  ItemCard2({required ItemData linkPreviewData, this.isAdminCard = false})
      : _itemData = linkPreviewData,
        _dateString = PreviewDataLoader.getFormattedDateFromIso8601(
            linkPreviewData.dateAdded),
        _shortDescription = PreviewDataLoader.shortenDescriptionIfNecessary(
            linkPreviewData.description, 150),
        _host = PreviewDataLoader.getHostFromUrl(linkPreviewData.url) {
    ItemCategory? itemCategory = _itemData.itemCategory;
    Image defaultImage;
    if (itemCategory == null) {
      defaultImage = Image.asset('images/no_picture.jpg');
    } else {
      defaultImage = Image.asset(itemCategory.imagePath);
    }
    imageWidget = _itemData.imageProvider == null
        ? defaultImage
        : ClipRRect(
            child: Image(image: _itemData.imageProvider!),
            borderRadius: BorderRadius.circular(8),
          );
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
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(child: renderDate(context)),
                      VoteButtons(itemData: _itemData)
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
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

  void showDetailScreen(BuildContext context) {
    Provider.of<AppState>(context, listen: false).currentSelectedItem = _itemData;
  }
}
