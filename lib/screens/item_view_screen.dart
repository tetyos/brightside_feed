import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inspired/components/item_card_custom.dart';
import 'package:inspired/components/item_card_custom.dart';
import 'package:inspired/components/item_card_link_preview.dart';
import 'package:inspired/components/item_card_link_preview_generator..dart';
import 'package:inspired/components/item_card_link_previewer.dart';
import 'package:inspired/components/item_card_simple_url_preview.dart';
import 'package:inspired/components/item_card_simple_url_preview_enhanced.dart';
import 'package:inspired/components/preview_data_loader.dart';

class ItemViewScreen extends StatelessWidget {
  final List<LinkPreviewData> _initialData;
  static const String id = 'item_view_screen';

  static const String spotify_url = 'https://open.spotify.com/track/7abZZqdxmt369pf6VSHiy7?si=y2NdAmC_QW6MrhjVtgAjrA&utm_source=whatsapp';
  static const String twitter_url = 'https://twitter.com/elonmusk/status/1381273076709478403';
  static const String youtube_url = 'https://www.youtube.com/watch?v=bfvyJ40HW60';
  static const String spiegel_url =
      'https://www.spiegel.de/politik/ausland/recep-tayyip-erdogan-tuerkei-nimmt-zehn-pensionierte-admirale-nach-kritik-am-kanal-istanbul-fest-a-166bdd33-6227-4fe9-92aa-94e12626d9be';

  ItemViewScreen({required List<LinkPreviewData> initialData}) : _initialData = initialData;


  @override
  Widget build(BuildContext context) {
    List<Widget> itemList = [];
    for (LinkPreviewData linkPreviewData in _initialData) {
      itemList.add(ItemCardCustom(linkPreviewData: linkPreviewData));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Item viewer"),
      ),
      body: SafeArea(
        child: ListView(
          reverse: false,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          children: itemList,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _doSomething,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void _doSomething() {
    // setState(() {
    //   // This call to setState tells the Flutter framework that something has
    //   // changed in this State, which causes it to rerun the build method below
    //   // so that the display can reflect the updated values. If we changed
    //   // _counter without calling setState(), then the build method would not be
    //   // called again, and so nothing would appear to happen.
    //   _counter++;
    // });
  }

  List<Widget> staticItemList = [
    // ItemCardSimpleUrlPreviewEnhanced(url: spiegel_url),
    // ItemCardSimpleUrlPreviewEnhanced(url: youtube_url),
    // ItemCardSimpleUrlPreviewEnhanced(url: spotify_url),
    // ItemCardSimpleUrlPreviewEnhanced(url: twitter_url),
    // ItemCardLinkPreviewer(url: spiegel_url),
    // ItemCardLinkPreviewer(url: youtube_url),
    // ItemCardLinkPreviewer(url: spotify_url),
    // ItemCardLinkPreviewer(url: twitter_url),
    // ItemCardLinkPreviewer(url: spiegel_url),
    // ItemCardLinkPreviewer(url: youtube_url),
    // ItemCardLinkPreviewer(url: spotify_url),
    // ItemCardLinkPreviewer(url: twitter_url),
    // ItemCardLinkPreviewer(url: spiegel_url),
    // ItemCardLinkPreviewer(url: youtube_url),
    // ItemCardLinkPreviewer(url: spotify_url),
    // ItemCardLinkPreviewer(url: twitter_url),
    // ItemCardLinkPreviewer(url: spiegel_url),
    // ItemCardLinkPreviewer(url: youtube_url),
    // ItemCardLinkPreviewer(url: spotify_url),
    // ItemCardLinkPreviewer(url: twitter_url),
    // ItemCardLinkPreviewer(url: spiegel_url),
    // ItemCardLinkPreviewer(url: youtube_url),
    // ItemCardLinkPreviewer(url: spotify_url),
    // ItemCardLinkPreviewer(url: twitter_url),
    // ItemCardCustom(url: twitter_url),
    // ItemCardCustom(url: twitter_url),
    // ItemCardCustom(url: twitter_url),
    // ItemCardCustom(url: twitter_url),
    // ItemCardCustom(url: spiegel_url),
    // ItemCardCustom(url: spotify_url),
    // ItemCardCustom(url: youtube_url),
    // ItemCardCustom(url: spiegel_url),
    // ItemCardCustom(url: spotify_url),
    // ItemCardCustom(url: youtube_url),
    // ItemCardCustom(url: spiegel_url),
    // ItemCardCustom(url: spotify_url),
  ];
}
