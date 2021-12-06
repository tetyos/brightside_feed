import 'package:flutter/material.dart';
import 'package:nexth/components/item_card_2.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/item_list_model.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:provider/provider.dart';

/// Creates a scroll view from the given [ItemListModel]. <br>
/// The [ItemListScrollView] automatically notifies the [ItemListModel], if new items need to be loaded.<br>
/// During loading progress a loading-spinner is shown. <br><br>
///
/// The ItemList can be preceded by an AppBar and WelcomeCard if needed.
class ItemListScrollView extends StatefulWidget {
  final ItemListModel itemListModel;
  final Widget? _appBar;
  final Widget? _introCard;
  final Widget Function(ItemData)? _customItemCardProvider;

  ItemListScrollView({
    required this.itemListModel,
    Widget? appBar,
    Widget? introCard,
    Widget Function(ItemData)? customItemCardProvider
  })  : _appBar = appBar,
        _introCard = introCard,
        _customItemCardProvider = customItemCardProvider;

  @override
  _ItemListScrollViewState createState() => _ItemListScrollViewState();
}

class _ItemListScrollViewState extends State<ItemListScrollView> {
  Widget Function(ItemData) _itemCardProvider = (itemData) => ItemCard2(linkPreviewData: itemData);
  ScrollController _scrollController = ScrollController();
  bool isLoadingImages = false;
  bool isFetchingItemData = false;

  @override
  void initState() {
    super.initState();
    if (widget._customItemCardProvider != null) {
      _itemCardProvider = widget._customItemCardProvider!;
    }
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
      child: RefreshIndicator(
        onRefresh: () async {await _executeRefresh();},
        child: CustomScrollView(
          controller: _scrollController,
          slivers: getSlivers(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Widget> getSlivers(){
    return <Widget>[
      if (widget._appBar != null)
        widget._appBar!,
      if (widget._introCard != null)
        widget._introCard!,
      SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            if (index == _itemList.length) {
              return _buildProgressIndicator();
            } else {
              return _itemCardProvider(_itemList[index]);
            }
          },
          childCount: _itemList.length + 1,
        ),
      ),
    ];
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
    bool isUserLoggedIn = Provider.of<AppState>(context, listen: false).isUserLoggedIn;
    itemListModel.assureMinNumberOfItems(isUserLoggedIn).then((_) {
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
      bool isUserLoggedIn = Provider.of<AppState>(context, listen: false).isUserLoggedIn;
      await itemListModel.requestMoreItemsFromDB(isUserLoggedIn);
      _loadMoreItems();

      if (mounted) {
        setState(() {
          isFetchingItemData = false;
        });
      }
    }
  }

  Future<void> _executeRefresh() async {
    if (isFetchingItemData || isLoadingImages) {
      // in case something is still loading, wait for it to finish, before beginning refresh
      // (it would be better to cancel the running process, but that would make things a lot more complicated..)
      await Future.delayed(Duration(milliseconds: 100));
      return await _executeRefresh();
    }
    isFetchingItemData = true;
    isLoadingImages = true;

    bool isUserLoggedIn = Provider.of<AppState>(context, listen: false).isUserLoggedIn;
    await itemListModel.executeRefresh(isUserLoggedIn);
    if (mounted) {
      setState(() {
        isFetchingItemData = false;
        isLoadingImages = false;
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
}