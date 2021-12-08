import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexth/components/explore/category_tabs.dart';
import 'package:nexth/components/explore/explore_add_filter_tab.dart';
import 'package:nexth/components/explore/explore_popular_tab.dart';
import 'package:nexth/components/explore/explore_likes_tab.dart';
import 'package:nexth/components/explore/explore_home_tab.dart';
import 'package:nexth/model/category_list_model.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/utils/constants.dart';
import 'package:nexth/utils/custom_page_view_scroll_physics.dart';
import 'package:provider/provider.dart';

class ExplorerScreen extends StatefulWidget {
  ExplorerScreen({required Key key}) : super(key: key);

  @override
  _ExplorerScreenState createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    AppState appState = Provider.of<AppState>(context, listen: false);
    _tabController = new TabController(
        length: 3 + appState.numberOfUserDefinedTabs + ItemCategory.values.length,
        vsync: this,
        initialIndex: appState.explorerScreenStartTab);
    _tabController.addListener(() {
      appState.setExplorerScreenCurrentTabAndNotify(_tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    _tabController.index = Provider.of<AppState>(context, listen: false).explorerScreenCurrentTab;
    return Column(children: [
      Container(
        color: kColorPrimary,
        child: TabBar(
          tabs: [
            Tab(
              child: Row(children: [Icon(Icons.add_outlined), SizedBox(width: 5), Text("Custom filter")]),
            ),
            Tab(
              child: Row(children: [Icon(Icons.favorite_border_outlined), SizedBox(width: 5), Text("Your likes")]),
            ),
            Tab(
              child: Row(children: [Icon(Icons.dashboard_outlined), SizedBox(width: 5), Text("Explore Home")]),
            ),
            Tab(
              child: Row(children: [FaIcon(FontAwesomeIcons.award), SizedBox(width: 5), Text("Popular")]),
            ),
            for (ItemCategory itemCategory in ItemCategory.values)
              CategoryTab(
                itemCategory: itemCategory,
              ),
          ],
          isScrollable: true,
          controller: _tabController,
        ),
      ),
      Expanded(
        child: TabBarView(controller: _tabController, physics: CustomPageViewScrollPhysics(), children: [
          ExploreAddFilterTab(),
          ExploreLikesTab(),
          ExploreHomeTab(),
          ExplorePopularTab(),
          for (ItemCategory itemCategory in ItemCategory.values)
            CategoryTabs(
              category: itemCategory,
              key: PageStorageKey<String>(itemCategory.displayTitle),
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