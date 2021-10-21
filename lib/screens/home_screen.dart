import 'package:flutter/material.dart';
import 'package:nexth/components/item_card_custom.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/item_list_model.dart';
import 'package:nexth/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  final ItemListModel _homeModel;

  HomeScreen({required ItemListModel homeModel, required Key key})
      : _homeModel = homeModel,
        super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController = ScrollController();
  bool isPerformingRequest = false;

  @override
  void initState() {
    super.initState();
    // initial data is kept low, so loading times are short. Hence, we need to load more data here.
    _getMoreData(true);
    _scrollController.addListener(scrollingListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      // todo: interaction does not work
      interactive: true,
      thickness: 4,
      controller: _scrollController,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            title: Text('Recently added'),
            floating: true,
            // expandedHeight: 200.0,
            // TODO: Add a FlexibleSpaceBar
          ),
          SliverToBoxAdapter(
            child: const WelcomeCard(),
          ),
          SliverList(
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
          // padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<ItemData> get _itemList => widget._homeModel.loadedItemList;

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
      bool anyItemsLoaded = await widget._homeModel.preloadNextItems(2);
      if (!isInitializing && !anyItemsLoaded && !widget._homeModel.hasMoreItems()) {
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

class WelcomeCard extends StatelessWidget {
  const WelcomeCard();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              children: [
                Text(
                  "Welcome back!",
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: "Pacifico",
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Scroll down, to catch up on what happened since your last login.",
                  // "Scroll down, to catch up on the good things fellow human beings have done since your last login.",
                  style: TextStyle(color: kColorSecondaryDark),
                )
              ],
            ),
          ),
          color: kColorPrimaryLight,
        ),
      ),
    );
  }
}