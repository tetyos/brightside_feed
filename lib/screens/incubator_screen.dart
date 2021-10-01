import 'package:flutter/material.dart';
import 'package:nexth/components/incubator_scroll_view.dart';
import 'package:nexth/model/basic_test_urls.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/item_list_view_model.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/utils/constants.dart';
import 'package:nexth/utils/custom_page_view_scroll_physics.dart';
import 'package:provider/provider.dart';

class IncubatorScreen extends StatefulWidget {
  IncubatorScreen({required Key key}): super(key: key);

  @override
  _IncubatorScreenState createState() => _IncubatorScreenState();
}

class _IncubatorScreenState extends State<IncubatorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        color: kColorPrimary,
        width: double.infinity,
        child: Center(
          child: TabBar(
            tabs: [
              Tab(
                child: Row(children: [
                  Icon(Icons.people_alt_outlined),
                  SizedBox(width: 5),
                  Text('Crowdsourced')
                ]),
              ),
              Tab(
                child: Row(children: [
                  Icon(Icons.people_alt_outlined),
                  SizedBox(width: 5),
                  Text('Scraped')
                ]),
              ),
            ],
            isScrollable: true,
            controller: _tabController,
          ),
        ),
      ),
      Expanded(
        child: TabBarView(
            controller: _tabController,
            physics: CustomPageViewScrollPhysics(),
            children: [
              IncubatorListView(
                incubatorType: IncubatorType.manual,
                key: PageStorageKey<String>(IncubatorType.manual.toString()),
              ),
              IncubatorListView(
                incubatorType: IncubatorType.scraped,
                key: PageStorageKey<String>(IncubatorType.scraped.toString()),
              ),
            ]),
      ),
    ]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class IncubatorListView extends StatefulWidget {
  final Key key;
  final IncubatorType incubatorType;

  const IncubatorListView({required this.key, required this.incubatorType}) : super(key: key);

  @override
  _IncubatorListViewState createState() => _IncubatorListViewState();
}

class _IncubatorListViewState extends State<IncubatorListView> {
  late ItemListViewModel _itemListViewModel;
  late List<ItemData> _itemList;

  @override
  void initState() {
    super.initState();
    _itemListViewModel = Provider.of<AppState>(context, listen: false).itemListViewModel;
    if (widget.incubatorType == IncubatorType.scraped) {
      _itemList = _itemListViewModel.incubatorScrapedItemList;
    } else {
      _itemList = _itemListViewModel.incubatorManualItemList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GenericScrollView(key: widget.key, loadData: requestMoreItems, items: _itemList,);
  }

  Future<List<ItemData>> requestMoreItems(int from, int to) async {
    List<ItemData> newData;
    if (widget.incubatorType == IncubatorType.manual) {
      var testDataLength = BasicTestUrls.testItemsManualIncubator.length;
      if (from > testDataLength) {
        return [];
      }
      int end = to > testDataLength ? testDataLength : to;
      newData = BasicTestUrls.testItemsManualIncubator.sublist(from, end);
    } else {
      var testDataLength = BasicTestUrls.testItemsScrapedIncubator.length;
      if (from > testDataLength) {
        return [];
      }
      int end = to > testDataLength ? testDataLength : to;
      newData = BasicTestUrls.testItemsScrapedIncubator.sublist(from, end);
    }

    List<Future<void>> futures = [];
    for (ItemData linkPreviewData in newData) {
      futures.add(linkPreviewData.preLoadImage());
    }
    await Future.wait(futures);
    return newData;
  }
}

enum IncubatorType {manual, scraped}