import 'package:flutter/material.dart';
import 'package:nexth/components/item_card_custom.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/screens/item_list_view_model.dart';
import 'package:nexth/testdata/basic_test_urls.dart';
import 'package:nexth/utils/preview_data_loader.dart';
import 'package:provider/provider.dart';

class CategoryScrollView extends StatefulWidget {
  final ItemCategory category;

  CategoryScrollView({required this.category, required key}) : super(key: key);

  @override
  _CategoryScrollViewState createState() => _CategoryScrollViewState();
}

class _CategoryScrollViewState extends State<CategoryScrollView> {
  late ItemListViewModel _itemListViewModel;
  bool isPerformingRequest = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _itemListViewModel = Provider.of<AppState>(context, listen: false).itemListViewModel;
    _scrollController.addListener(scrollingListener);
    // initial data is kept low, so loading screen is short. Hence, we need to load more data here.
    _getMoreData(true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: CustomScrollView(
        controller: _scrollController,
        key: PageStorageKey<String>(widget.category.displayTitle),
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == _itemList.length) {
                    return _buildProgressIndicator();
                  } else {
                    return ItemCardCustom(linkPreviewData: _itemList[index]);
                  }
                },
                childCount: _itemList.length + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollingListener);
    super.dispose();
  }

  List<ItemData> get _itemList => _itemListViewModel.getCategoryItems(widget.category);


  /// Tries to load more data, as soon as there is less to scroll then 3 times the average item size.
  void scrollingListener() {
    double maxScrollExtent = _scrollController.position.maxScrollExtent;
    double currentScrollPosition = _scrollController.position.pixels;
    double averageItemSize = maxScrollExtent / _itemList.length;
    double scrollAmountLeft = maxScrollExtent - currentScrollPosition;
    bool isEnoughItemsLeft = scrollAmountLeft / averageItemSize > 3;
    if (!isEnoughItemsLeft) {
      _getMoreData(false);
    }
  }

  Future<void> _getMoreData(bool isInitializing) async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      List<ItemData> newEntries = await requestMoreItems(_itemList.length, _itemList.length + 2);
      if (newEntries.isEmpty && !isInitializing) {
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

  Future<List<ItemData>> requestMoreItems(int from, int to) async {
    List<ItemData> categoryItems = BasicTestUrls.testItemsRecent
        .where((itemData) => itemData.itemCategory == widget.category)
        .toList();
    var categoryItemsLength = categoryItems.length;
    if (from > categoryItemsLength) {
      return [];
    }
    int end = to > categoryItemsLength ? categoryItemsLength : to;
    List<ItemData> newData = categoryItems.sublist(from, end);

    List<Future<void>> futures = [];
    for (ItemData linkPreviewData in newData) {
      futures.add(linkPreviewData.preLoadImage());
    }
    await Future.wait(futures);
    return newData;
  }
}
