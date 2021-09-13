import 'package:flutter/material.dart';
import 'package:inspired/components/item_card_custom.dart';
import 'package:inspired/components/preview_data_loader.dart';
import 'package:inspired/testdata/basic_test_urls.dart';

class ItemListView extends StatefulWidget {
  final List<LinkPreviewData> _initialData;

  ItemListView({required List<LinkPreviewData> initialData}) : _initialData = initialData;

  @override
  _ItemListViewState createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
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

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          title: Text('Horizons'),
          backgroundColor: Colors.teal[800],
          floating: true,
          // expandedHeight: 200.0,
          // TODO: Add a FlexibleSpaceBar
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == itemList.length) {
                return _buildProgressIndicator();
              } else {
                return itemList[index];
              }
            },
            childCount: itemList.length + 1,
          ),
        ),
        // padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Tries to load more data, as soon as there is less to scroll then 3 times the average item size.
  void scrollingListener() {
    double maxScrollExtent = _scrollController.position.maxScrollExtent;
    double currentScrollPosition = _scrollController.position.pixels;
    double averageItemSize = maxScrollExtent / itemList.length;
    double scrollAmountLeft = maxScrollExtent - currentScrollPosition;
    bool isEnoughItemsLeft = scrollAmountLeft / averageItemSize > 3;
    if (!isEnoughItemsLeft) {
      _getMoreData();
    }
  }

  Future<void> _getMoreData() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      List<Widget> newEntries = await requestMoreItems(itemList.length, itemList.length + 2);
      if (newEntries.isEmpty) {
        double edge = 50.0;
        double offsetFromBottom =
            _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          _scrollController.animateTo(_scrollController.offset - (edge - offsetFromBottom),
              duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
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
}
