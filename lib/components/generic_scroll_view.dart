import 'package:flutter/material.dart';
import 'package:nexth/components/item_card_custom.dart';
import 'package:nexth/model/item_data.dart';

class GenericScrollView extends StatefulWidget {
  final List<ItemData> items;
  final Function dataLoader;
  final Key key;

  GenericScrollView({required this.items, required this.dataLoader, required this.key}) : super(key: key);

  @override
  _GenericScrollViewState createState() => _GenericScrollViewState();
}

class _GenericScrollViewState extends State<GenericScrollView> {
  ScrollController _scrollController = ScrollController();
  bool isPerformingRequest = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(scrollingListener);
    // initial data is kept low, so loading times are short. Hence, we need to load more data here.
    _getMoreData(true);
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollingListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scrollbar(
        // todo interaction does not work
        interactive: true,
        thickness: 4,
        child: CustomScrollView(
          controller: _scrollController,
          key: widget.key,
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
      ),
    );
  }

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

  List<ItemData> get _itemList => widget.items;

  Future<void> _getMoreData(bool isInitializing) async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      List<ItemData> newEntries = await widget.dataLoader(_itemList.length, _itemList.length + 2);
      if (newEntries.isEmpty && !isInitializing) {
        double edge = 50.0;
        double offsetFromBottom =
            _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          _scrollController.animateTo(_scrollController.offset - (edge - offsetFromBottom),
              duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
        }
      }
      if (mounted) {
        setState(() {
          _itemList.addAll(newEntries);
          isPerformingRequest = false;
        });
      }
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
}