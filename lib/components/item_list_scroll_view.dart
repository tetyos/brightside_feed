import 'package:flutter/material.dart';
import 'package:nexth/components/item_card.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/item_list_model.dart';

/// Creates a scroll view from the given [ItemListModel]. <br>
/// The [ItemListScrollView] automatically notifies the [ItemListModel], if new items need to be loaded.<br>
/// During loading progress a loading-spinner is shown. <br><br>
///
/// The ItemList can be preceded by an AppBar and WelcomeCard if needed.
class ItemListScrollView extends StatefulWidget {
  final ItemListModel itemListModel;
  final Widget? _appBar;
  final Widget? _welcomeCard;

  ItemListScrollView({
    required this.itemListModel,
    Widget? appBar,
    Widget? welcomeCard,
  })  : _appBar = appBar,
        _welcomeCard = welcomeCard;

  @override
  _ItemListScrollViewState createState() => _ItemListScrollViewState();
}

class _ItemListScrollViewState extends State<ItemListScrollView> {
  ScrollController _scrollController = ScrollController();
  bool isLoadingImages = false;
  bool isFetchingItemData = false;

  @override
  void initState() {
    super.initState();
    _initModel();
    _scrollController.addListener(scrollingListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      // todo interaction does not work
      interactive: true,
      thickness: 4,
      controller: _scrollController,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          if (widget._appBar != null)
            widget._appBar!,
          if (widget._welcomeCard != null)
            widget._welcomeCard!,
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == _itemList.length) {
                  return _buildProgressIndicator();
                } else {
                  return ItemCard(linkPreviewData: _itemList[index]);
                }
              },
              childCount: _itemList.length + 1,
            ),
          ),
        ],
      ),
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
    double averageItemSize = maxScrollExtent / _itemList.length;
    double scrollAmountLeft = maxScrollExtent - currentScrollPosition;
    bool isEnoughItemsLeft = scrollAmountLeft / averageItemSize > 3;
    if (!isEnoughItemsLeft) {
      _loadMoreItems();
      _requestMoreItemsFromDBIfNecessary();
    }

    double edge = 50.0;
    double offsetFromBottom = maxScrollExtent - currentScrollPosition;
    if (offsetFromBottom < edge && !isPerformingRequest && itemListModel.isEverythingLoaded()) {
      _scrollController.animateTo(_scrollController.offset - (edge - offsetFromBottom),
          duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
    }
  }

  ItemListModel get itemListModel => widget.itemListModel;

  List<ItemData> get _itemList => itemListModel.fullyLoadedItems;

  bool get isPerformingRequest => isLoadingImages || isFetchingItemData;

  Future<void> _initModel() async {
    setState(() {
      isFetchingItemData = true;
      isLoadingImages = true;
    });

    // initially only few items and images are preloaded, so loading times are short. Some ItemListModel don't preload items/images at all.
    // Hence, we need to load more data here.
    itemListModel.assureMinNumberOfItems().then((_) {
      if (mounted) {
        setState(() {
          isFetchingItemData = false;
          isLoadingImages = false;
        });
      }
    });
  }

  Future<void> _loadMoreItems() async {
    if (!isLoadingImages && itemListModel.hasImagesToPreload()) {
      setState(() => isLoadingImages = true);
      await itemListModel.preloadNextItems(2);

      if (mounted) {
        setState(() {
          isLoadingImages = false;
        });
      }
    }
  }

  Future<void> _requestMoreItemsFromDBIfNecessary() async {
    if (!isFetchingItemData && itemListModel.hasNotEnoughItemsLeft()) {
      setState(() => isFetchingItemData = true);
      await itemListModel.requestMoreItemsFromDB();
      _loadMoreItems();

      if (mounted) {
        setState(() {
          isFetchingItemData = false;
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