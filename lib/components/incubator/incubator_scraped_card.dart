import 'package:flutter/material.dart';
import 'package:nexth/components/more_menu.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/screens/add_scraped_item_screen.dart';
import 'package:nexth/utils/constants.dart';
import 'package:nexth/utils/preview_data_loader.dart';
import 'package:nexth/utils/ui_utils.dart';
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
        onTap: () => launchUrl(),
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
                      PromoteButton(itemData: _itemData),
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
    Widget image = _itemData.fadeInImage ?? Image.asset('images/default_card_images/no_picture.png');
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

class PromoteButton extends StatelessWidget {
  final ItemData itemData;

  PromoteButton({required this.itemData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPromoteItemDialog(context),
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        color: Colors.transparent,
        child: TextButton(
          child: Row(
            children: [
              SizedBox(width: 10),
              Icon(Icons.add_circle_outline, color: Theme.of(context).primaryColor),
              SizedBox(width: 5),
            ],
          ),
          onPressed: () => showPromoteItemDialog(context),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size(30, 48),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ),
    );
  }

  void showPromoteItemDialog(BuildContext context) {
    if (!Provider.of<AppState>(context, listen: false).isUserLoggedIn) {
      UIUtils.showSnackBar("Adding items is currently only supported in app.", context);
      return;
    }

    // we need to fetch root backButtonDispatcher and give priority back to it.
    // otherwise inner-backButtonDispatcher has priority
    ChildBackButtonDispatcher childBackButtonDispatcher = Router.of(context).backButtonDispatcher as ChildBackButtonDispatcher;
    childBackButtonDispatcher.parent.takePriority();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: MediaQuery.of(context).viewInsets.bottom == 0.0 ? 0.9 : 0.9,
        child: AddScrapedItemScreen(itemData: itemData),
      ),
    ).whenComplete(() {
      Router.of(context).backButtonDispatcher!.takePriority();
    });
  }
}