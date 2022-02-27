import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:brightside_feed/components/explore/category_tabs.dart';
import 'package:brightside_feed/components/explore/explore_add_filter_tab.dart';
import 'package:brightside_feed/components/explore/explore_popular_tab.dart';
import 'package:brightside_feed/components/explore/explore_likes_tab.dart';
import 'package:brightside_feed/components/explore/explore_home_tab.dart';
import 'package:brightside_feed/model/category_tree_model.dart';
import 'package:brightside_feed/model/model_manager.dart';
import 'package:brightside_feed/navigation/app_state.dart';
import 'package:brightside_feed/utils/constants.dart';
import 'package:brightside_feed/utils/custom_page_view_scroll_physics.dart';
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
        length: 4 + appState.numberOfUserDefinedTabs,
        vsync: this,
        initialIndex: appState.explorerScreenStartTab);
    _tabController.addListener(() {
      appState.setExplorerScreenCurrentTabAndNotify(_tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    _tabController.index = Provider.of<AppState>(context, listen: false).explorerScreenCurrentTab;
    List<CategoryElement> currentCategories = ModelManager.instance.categoryItemModel.categories;
    String currentCategory = currentCategories.isEmpty ? "" : currentCategories.first.displayTitle;

    return Column(children: [
      Container(
        color: kColorPrimary,
        width: double.infinity,
        child: Center(
          child: TabBar(
            tabs: [
              Tab(
                child: Row(children: [Icon(Icons.favorite_border_outlined), SizedBox(width: 5), Text("Your likes")]),
              ),
              Tab(
                child: Row(children: [Icon(Icons.dashboard_outlined), SizedBox(width: 5), Text("Explore Home")]),
              ),
              Tab(
                child: Row(children: [FaIcon(FontAwesomeIcons.award), SizedBox(width: 5), Text("Popular")]),
              ),
              Tab(
                child: Row(
                    children: [Icon(Icons.category_rounded), SizedBox(width: 5), Text("Category: " + currentCategory)]),
              ),
              Tab(
                child: Row(children: [Icon(Icons.add_outlined), SizedBox(width: 5), Text("Custom filter")]),
              ),
            ],
            isScrollable: true,
            controller: _tabController,
          ),
        ),
      ),
      Expanded(
        child: TabBarView(controller: _tabController, physics: CustomPageViewScrollPhysics(), children: [
          ExploreLikesTab(),
          ExploreHomeTab(),
          ExplorePopularTab(),
          CategoryTab(),
          ExploreAddFilterTab(),
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