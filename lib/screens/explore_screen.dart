import 'package:flutter/material.dart';
import 'package:inspired/components/item_card_custom.dart';
import 'package:inspired/screens/item_list_view_model.dart';
import 'package:inspired/utils/preview_data_loader.dart';
import 'package:inspired/testdata/basic_test_urls.dart';

class ExplorerScreen extends StatefulWidget {
  final ItemListViewModel _itemListViewModel;

  ExplorerScreen({required ItemListViewModel itemListViewModel, required Key key})
      : _itemListViewModel = itemListViewModel,
        super(key: key);

  @override
  _ExplorerScreenState createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isPerformingRequest = false;
  final GlobalKey<NestedScrollViewState> _globalKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    for (ItemData linkPreviewData in widget._itemListViewModel.initialDataExplore) {
      _itemList.add(ItemCardCustom(linkPreviewData: linkPreviewData));
    }
    // initial data is kept low, so loading screen is short. Hence, we need to load more data here.
    _getMoreData(true);
    _tabController = new TabController(length: ItemCategory.values.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      key: _globalKey,
      floatHeaderSlivers: true,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
              title: Text('Explore'),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                tabs: [
                  for (ItemCategory itemCategory in ItemCategory.values)
                    CategoryTab(itemCategory: itemCategory,),
                ],
                isScrollable: true,
                controller: _tabController,
              ),
            ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
          children: [
            SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                // This Builder is needed to be able to add listener to inner controller
                builder: (BuildContext context) {
                  innerController.addListener(scrollingListener);
                  return CustomScrollView(
                    controller: innerController,
                    key: PageStorageKey<String>("tab1"),
                    slivers: <Widget>[
                      SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        sliver: SliverList(
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
                      ),
                    ],
                  );
                },
              ),
            ),
            SafeArea(child: Text('test')),
            SafeArea(child: Text('test')),
            SafeArea(child: Text('test')),
            SafeArea(child: Text('test')),
            SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                // This Builder is needed to be able to add listener to inner controller
                builder: (BuildContext context) {
                  innerController.addListener(scrollingListener);
                  return CustomScrollView(
                    controller: innerController,
                    key: PageStorageKey<String>("tab1"),
                    slivers: <Widget>[
                      SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        sliver: SliverList(
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
                      ),
                    ],
                  );
                },
              ),
            ),
          ]
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  ScrollController get innerController {
    return _globalKey.currentState!.innerController;
  }

  List<ItemCardCustom> get _itemList => widget._itemListViewModel.exploreItemList;

  /// Tries to load more data, as soon as there is less to scroll then 3 times the average item size.
  void scrollingListener() {
    double maxScrollExtent = innerController.position.maxScrollExtent;
    double currentScrollPosition = innerController.position.pixels;
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
      List<ItemCardCustom> newEntries = await requestMoreItems(_itemList.length, _itemList.length + 2);
      if (newEntries.isEmpty && !isInitializing) {
        double edge = 50.0;
        double offsetFromBottom =
            innerController.position.maxScrollExtent - innerController.position.pixels;
        if (offsetFromBottom < edge) {
          innerController.animateTo(innerController.offset - (edge - offsetFromBottom),
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
    List<ItemData> categoryItems = BasicTestUrls.testItemsRecent
        .where((itemData) => itemData.itemCategory == ItemCategory.energy)
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
    List<ItemCardCustom> newItems = [];
    for (ItemData linkPreviewData in newData) {
      newItems.add(ItemCardCustom(linkPreviewData: linkPreviewData));
    }
    return newItems;
  }
}

class CategoryTab extends StatelessWidget {
  final ItemCategory itemCategory;

  CategoryTab({required this.itemCategory});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(children: [
        Icon(itemCategory.icon),
        SizedBox(width: 5),
        Text(itemCategory.displayTitle)
      ]),
    );
  }
}