import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';
import 'package:nexth/utils/preview_data_loader.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemCard extends StatelessWidget {
  final ItemData _itemData;
  final String? _shortDescription;
  final String _dateString;
  final String _host;
  late final Widget imageGestureDetector;

  ItemCard({required ItemData linkPreviewData})
      : _itemData = linkPreviewData,
        _dateString = PreviewDataLoader.getFormattedDateFromIso8601(linkPreviewData.dateAdded),
        _shortDescription =
            PreviewDataLoader.shortenDescriptionIfNecessary(linkPreviewData.description, 150),
        _host = PreviewDataLoader.getHostFromUrl(linkPreviewData.url) {
    Widget imageWidget = _itemData.imageProvider == null
        ? SpinKitCircle(color: Colors.blueAccent)
        : ClipRRect(
            child: Image(image: _itemData.imageProvider!),
            borderRadius: BorderRadius.circular(8),
          );
    imageGestureDetector = GestureDetector(onTap: launchUrl, child: imageWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              imageGestureDetector,
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => showDetailScreen(context),
                child: ListTile(
                  title: Text(
                    _itemData.title,
                  ),
                  subtitle: _shortDescription == null ? null : Text(_shortDescription!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _dateString,
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    TextButton(
                      child: Text(_host),
                      onPressed: () {
                        /* ... */
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

  void showDetailScreen(BuildContext context) {
    Provider.of<AppState>(context, listen: false).currentSelectedItem = _itemData;
    NexthRoutePath currentPath = Provider.of<AppState>(context, listen: false).currentRoutePath;
    ItemDetailsScreenPath nextPath;
    if (currentPath is NexthHomePath) {
      nextPath = HomeItemDetailsPath();
    } else if (currentPath is NexthExplorePath) {
      nextPath = ExploreItemDetailsPath();
    } else {
      nextPath = IncubatorItemDetailsPath();
    }
    Provider.of<AppState>(context, listen: false).currentRoutePath = nextPath;
  }
}
