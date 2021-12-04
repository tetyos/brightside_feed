import 'package:flutter/material.dart';
import 'package:nexth/components/incubator_start_page.dart';
import 'package:nexth/components/item_list_scroll_view.dart';
import 'package:nexth/model/incubator_list_model.dart';
import 'package:nexth/model/item_list_model.dart';
import 'package:nexth/model/model_manager.dart';
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
    _tabController = new TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      Provider.of<AppState>(context, listen: false).incubatorScreenCurrentTab = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _tabController.index = Provider.of<AppState>(context, listen: true).incubatorScreenCurrentTab;
    return Column(children: [
      Container(
        color: kColorPrimary,
        width: double.infinity,
        child: Center(
          child: TabBar(
            tabs: [
              Tab(
                child: Row(children: [Icon(Icons.add_chart), SizedBox(width: 5), Text("Incubator")]),
              ),
              Tab(
                child: Row(children: [
                  Icon(Icons.people_alt_outlined),
                  SizedBox(width: 5),
                  Text('Trusted sources')
                ]),
              ),
              Tab(
                child: Row(children: [
                  Icon(Icons.warning_amber_outlined),
                  SizedBox(width: 5),
                  Text('Unknown sources')
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
              IncubatorStartPage(),
              IncubatorScrollView(
                incubatorType: IncubatorType.inc1,
                key: PageStorageKey<String>(IncubatorType.inc1.toString()),
              ),
              IncubatorScrollView(
                incubatorType: IncubatorType.unsafe,
                key: PageStorageKey<String>(IncubatorType.unsafe.toString()),
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
    _itemListModel = _modelManager.getModelForIncubatorType(widget.incubatorType);
  }

  @override
  Widget build(BuildContext context) {
    return ItemListScrollView(itemListModel: _itemListModel);
  }
}