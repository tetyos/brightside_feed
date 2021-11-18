import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/model_manager.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/utils/constants.dart';
import 'package:nexth/utils/preview_data_loader.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetailScreen extends StatefulWidget {

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  bool _hasItem = true;
  late ItemData _itemData;
  late GestureDetector _imageWidget;
  late String _dateString;
  late String _host;


  @override
  void initState() {
    super.initState();

    ItemData? item = Provider.of<AppState>(context, listen: false).currentSelectedItem;
    if (item == null) {
      _hasItem = false;
      return;
    }

    _itemData = item;
    _dateString = PreviewDataLoader.getFormattedDateFromIso8601(_itemData.dateAdded);
    _host = PreviewDataLoader.getHostFromUrl(_itemData.url);

    Widget imageWidget = _itemData.imageProvider == null
        ? SpinKitCircle(color: Colors.blueAccent)
        : ClipRRect(
            child: Image(
              image: _itemData.imageProvider!,
            ),
            borderRadius: BorderRadius.circular(8),
          );
    _imageWidget = GestureDetector(
        onTap: launchUrl,
        child: imageWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasItem) {
      return Text("Glitch in the Matrix");
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          renderImage(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_itemData.title, style: TextStyle(fontSize: 16),),
                SizedBox(height: 5),
                if (_itemData.description != null) ...[
                  Text(
                    _itemData.description!,
                    style: TextStyle(color: Color(0x8a000000), fontSize: 14),
                  )
                ],
                renderDivider(),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.remove_red_eye_outlined),
                          SizedBox(width: 2),
                          Text("4.505"),
                        ],
                      ),
                    ),
                    if (_itemData.itemCategory != null) ...[
                      Icon(Icons.thumb_up_alt_outlined),
                      SizedBox(width: 2),
                      Text("120"),
                      SizedBox(width: 5),
                      Icon(Icons.whatshot_outlined),
                      SizedBox(width: 2),
                      Text("20"),
                      SizedBox(width: 5),
                      Icon(Icons.lightbulb_outline),
                      SizedBox(width: 2),
                      Text("20"),
                    ],
                  ],
                ),
                SizedBox(height: 15),
                Text(_host, style: TextStyle(color: kColorPrimary, fontWeight: FontWeight.bold),),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Added on: " +  _dateString,
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                    if (_itemData.itemCategory != null) ...[
                      Text(_itemData.itemCategory!.displayTitle),
                      SizedBox(width: 2),
                      Icon(_itemData.itemCategory!.icon),
                    ],
                  ],
                ),
              ],
            ),
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

  Widget renderImage() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Padding(
        child: _imageWidget,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }

  Widget renderDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(color: Colors.black),
    );
  }
}