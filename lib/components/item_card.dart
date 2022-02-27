import 'package:flutter/material.dart';
import 'package:brightside_feed/components/category_chooser/category_updater.dart';
import 'package:brightside_feed/components/more_menu.dart';
import 'package:brightside_feed/components/vote_buttons.dart';
import 'package:brightside_feed/model/item_data.dart';
import 'package:brightside_feed/navigation/app_state.dart';
import 'package:brightside_feed/utils/constants.dart';
import 'package:brightside_feed/utils/preview_data_loader.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemCard extends StatelessWidget {
  final ItemData _itemData;
  final String? _shortDescription;
  final String _dateString;
  final String _host;

  late final Widget imageWidget;
  final bool isAdminCard;

  ItemCard({required ItemData linkPreviewData, this.isAdminCard = false})
      : _itemData = linkPreviewData,
        _dateString = PreviewDataLoader.getFormattedDateFromIso8601(linkPreviewData.dateAdded),
        _shortDescription =
        PreviewDataLoader.shortenDescriptionIfNecessary(linkPreviewData.description, 150),
        _host = PreviewDataLoader.getHostFromUrl(linkPreviewData.url) {
    createImageWidget();
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context, listen: false);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: GestureDetector(
        onTap: () => launchWebView(context),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 800),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  imageWidget,
                  const SizedBox(height: 10),
                  renderTitleAndDescription(appState.isShowContentDescription),
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
                        MoreMenu(itemData: _itemData, buttonColor: Colors.grey,),
                      ],
                    ),
                  ),
                  if (appState.isShowCategoryUpdater)
                    CategoryUpdater(itemData: _itemData),
                ],
              ),
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

  renderTitleAndDescription(bool isShowContentDescription) {
    if (isShowContentDescription && _shortDescription != null ) {
      return ListTile(
        title: Text(
          _itemData.title,
        ),
        subtitle: Text(_shortDescription!),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 3, top: 3),
        child: Text(
          _itemData.title,
          style: TextStyle(fontSize: 16),
        ),
      );
    }
  }
}
