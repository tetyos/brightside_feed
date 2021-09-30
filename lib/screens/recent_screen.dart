import 'package:flutter/material.dart';
import 'package:nexth/components/item_card_custom.dart';
import 'package:nexth/screens/item_list_view_model.dart';
import 'package:nexth/utils/preview_data_loader.dart';
import 'package:nexth/testdata/basic_test_urls.dart';

class RecentScreen extends StatefulWidget {
  final ItemListViewModel _itemListViewModel;

  RecentScreen({required ItemListViewModel itemListViewModel, required Key key})
      : _itemListViewModel = itemListViewModel,
        super(key: key);

  @override
  _RecentScreenState createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;

  @override
  void initState() {
    super.initState();
    for (ItemData linkPreviewData in widget._itemListViewModel.initialDataRecent) {
      _itemList.add(ItemCardCustom(linkPreviewData: linkPreviewData));
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
          title: Text('Recent'),
          floating: true,
          // expandedHeight: 200.0,
          // TODO: Add a FlexibleSpaceBar
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == _itemList.length) {
                return _buildProgressIndicator();
              } else {
                return _itemList[index];
              }
            },
            childCount: _itemList.length + 1,
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

  List<ItemCardCustom> get _itemList => widget._itemListViewModel.recentItemList;

  /// Tries to load more data, as soon as there is less to scroll then 3 times the average item size.
  void scrollingListener() {
    double maxScrollExtent = _scrollController.position.maxScrollExtent;
    double currentScrollPosition = _scrollController.position.pixels;
    double averageItemSize = maxScrollExtent / _itemList.length;
    double scrollAmountLeft = maxScrollExtent - currentScrollPosition;
    bool isEnoughItemsLeft = scrollAmountLeft / averageItemSize > 3;
    if (!isEnoughItemsLeft) {
      _getMoreData();
    }
  }

  Future<void> _getMoreData() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      List<ItemCardCustom> newEntries = await requestMoreItems(_itemList.length, _itemList.length + 2);
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
        _itemList.addAll(newEntries);
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

  Future<List<ItemCardCustom>> requestMoreItems(int from, int to) async {
    var testDataLength = BasicTestUrls.testItemsRecent.length;
    if (from > testDataLength) {
      return [];
    }
    int end = to > testDataLength ? testDataLength : to;
    List<ItemData> newData = BasicTestUrls.testItemsRecent.sublist(from, end);

    List<Future<void>> futures = [];
    for (ItemData linkPreviewData in newData) {
      futures.add(linkPreviewData.preLoadImage());
    }
    await Future.wait(futures);
    List<ItemCardCustom> newItems = [];
    for (ItemData linkPreviewData in newData) {
      newItems.add(ItemCardCustom(linkPreviewData: linkPreviewData));
    }
    return newItems;
  }
}