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
import 'package:inspired/testdata/basic_test_urls.dart';

class ItemViewScreen extends StatefulWidget {
  final List<LinkPreviewData> _initialData;
  static const String id = 'item_view_screen';

  static const String spotify_url = 'https://open.spotify.com/track/7abZZqdxmt369pf6VSHiy7?si=y2NdAmC_QW6MrhjVtgAjrA&utm_source=whatsapp';
  static const String twitter_url = 'https://twitter.com/elonmusk/status/1381273076709478403';
  static const String youtube_url = 'https://www.youtube.com/watch?v=bfvyJ40HW60';
  static const String spiegel_url =
      'https://www.spiegel.de/politik/ausland/recep-tayyip-erdogan-tuerkei-nimmt-zehn-pensionierte-admirale-nach-kritik-am-kanal-istanbul-fest-a-166bdd33-6227-4fe9-92aa-94e12626d9be';

  ItemViewScreen({required List<LinkPreviewData> initialData}) : _initialData = initialData;

  @override
  _ItemViewScreenState createState() => _ItemViewScreenState();
}

class _ItemViewScreenState extends State<ItemViewScreen> {

  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  List<Widget> itemList = [];

  @override
  void initState() {
    super.initState();
    for (LinkPreviewData linkPreviewData in widget._initialData) {
      itemList.add(ItemCardCustom(linkPreviewData: linkPreviewData));
    }
    // initial data is kept low, so loading screen is short. Hence, we need to load more data here.
    _getMoreData();
    _scrollController.addListener(scrollingListener);
  }


  /// Tries to load more data, as soon as there is less to scroll then 3 times the average item size.
  void scrollingListener() {
    double maxScrollExtent = _scrollController.position.maxScrollExtent;
    double currentScrollPosition = _scrollController.position.pixels;
    double averageItemSize = maxScrollExtent / itemList.length;
    double scrollAmountLeft = maxScrollExtent - currentScrollPosition;
    bool isEnoughItemsLeft = scrollAmountLeft / averageItemSize > 3;
    if (!isEnoughItemsLeft){
      _getMoreData();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item viewer"),
      ),
      body: SafeArea(
        child:
          ListView.builder(
            itemCount: itemList.length + 1,
            itemBuilder: (context, index) {
              if (index == itemList.length) {
                return _buildProgressIndicator();
              } else {
                return itemList[index];
              }
            },
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          )
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

  Future<void> _getMoreData() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      List<Widget> newEntries = await requestMoreItems(
          itemList.length, itemList.length + 2);
      if (newEntries.isEmpty) {
        double edge = 50.0;
        double offsetFromBottom = _scrollController.position.maxScrollExtent -
            _scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          _scrollController.animateTo(
              _scrollController.offset - (edge - offsetFromBottom),
              duration: new Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
      }
      setState(() {
        itemList.addAll(newEntries);
        isPerformingRequest = false;
      });
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<List<Widget>> requestMoreItems(int from, int to) async {
    var testDataLength = BasicTestUrls.testPreviewData.length;
    if (from > testDataLength) {
      return [];
    }
    int end = to > testDataLength ? testDataLength : to;
    List<LinkPreviewData> newData = BasicTestUrls.testPreviewData.sublist(from, end);

    List<Future<void>> futures = [];
    for (LinkPreviewData linkPreviewData in newData) {
      futures.add(linkPreviewData.preLoadImage());
    }
    await Future.wait(futures);
    List<Widget> newItems = [];
    for (LinkPreviewData linkPreviewData in newData) {
      newItems.add(ItemCardCustom(linkPreviewData: linkPreviewData));
    }
    return newItems;
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
