import 'package:flutter/material.dart';
import 'package:nexth/components/item_list_scroll_view.dart';
import 'package:nexth/model/item_list_model.dart';
import 'package:nexth/model/model_manager.dart';
import 'package:nexth/utils/constants.dart';
import 'package:nexth/utils/custom_page_view_scroll_physics.dart';

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
                  Icon(Icons.travel_explore_outlined),
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
              IncubatorScrollView(
                incubatorType: IncubatorType.manual,
                key: PageStorageKey<String>(IncubatorType.manual.toString()),
              ),
              IncubatorScrollView(
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

class IncubatorScrollView extends StatefulWidget {
  final IncubatorType incubatorType;

  const IncubatorScrollView({required Key key, required this.incubatorType}) : super(key: key);

  @override
  _IncubatorScrollViewState createState() => _IncubatorScrollViewState();
}

class _IncubatorScrollViewState extends State<IncubatorScrollView> {
  late ItemListModel _itemListModel;

  @override
  void initState() {
    super.initState();
    ModelManager _modelManager = ModelManager.instance;
    if (widget.incubatorType == IncubatorType.scraped) {
      _itemListModel = _modelManager.getModelForCategory(ItemCategory.food);
    } else {
      _itemListModel = _modelManager.getModelForCategory(ItemCategory.energy);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ItemListScrollView(itemListModel: _itemListModel);
  }
}

enum IncubatorType {manual, scraped}