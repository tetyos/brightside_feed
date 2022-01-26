import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexth/components/incubator/incubator_scraped_card.dart';
import 'package:nexth/components/incubator/news_scanner_intro_card.dart';
import 'package:nexth/components/incubator/incubator_intro_card.dart';
import 'package:nexth/components/incubator/incubator_unsafe_card.dart';
import 'package:nexth/components/intro_card.dart';
import 'package:nexth/components/item_list_scroll_view.dart';
import 'package:nexth/model/list_models/incubator_list_model.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/list_models/item_list_model.dart';
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
      Provider.of<AppState>(context, listen: false).setIncubatorScreenCurrentTabAndNotify(_tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    _tabController.index = Provider.of<AppState>(context, listen: false).incubatorScreenCurrentTab;
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
                  FaIcon(FontAwesomeIcons.globe),
                  SizedBox(width: 5),
                  Text('News-scanner')
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
              IncubatorScrollView(
                incubatorType: IncubatorType.inc1,
                key: PageStorageKey<String>(IncubatorType.inc1.toString()),
              ),
              IncubatorScrollView(
                incubatorType: IncubatorType.scraped,
                key: PageStorageKey<String>(IncubatorType.scraped.toString()),
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
  Widget Function(ItemData)? _itemCardProvider;
  Widget? exploreIntroCard;

  @override
  void initState() {
    super.initState();
    ModelManager _modelManager = ModelManager.instance;
    _itemListModel = _modelManager.getModelForIncubatorType(widget.incubatorType);
    if (widget.incubatorType == IncubatorType.scraped) {
      _itemCardProvider = (itemData) => IncubatorScrapedCard(
            linkPreviewData: itemData,
            isAdminCard: ModelManager.instance.isAdmin(),
          );
      exploreIntroCard = const SliverToBoxAdapter(child: const NewsScannerIntroCard());
    } else if (widget.incubatorType == IncubatorType.unsafe) {
      _itemCardProvider = (itemData) => IncubatorUnsafeCard(
          linkPreviewData: itemData, isAdminCard: ModelManager.instance.isAdmin());
      exploreIntroCard = const SliverToBoxAdapter(
        child: const IntroCard(
            title: "New items: unknown websites",
            message:
                "Content from unknown sources is sorted into this list until approved. Preview images are not shown on purpose here."),
      );
    } else {
      exploreIntroCard = const SliverToBoxAdapter(
        child: const IncubatorIntroCard(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ItemListScrollView(
      itemListModel: _itemListModel,
      customItemCardProvider: _itemCardProvider,
      introCard: exploreIntroCard,
    );
  }
}