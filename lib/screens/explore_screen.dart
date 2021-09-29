import 'package:flutter/material.dart';
import 'package:inspired/components/category_scroll_view.dart';
import 'package:inspired/screens/item_list_view_model.dart';

class ExplorerScreen extends StatefulWidget {
  ExplorerScreen({required Key key}) : super(key: key);

  @override
  _ExplorerScreenState createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<NestedScrollViewState> _globalKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: ItemCategory.values.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      key: _globalKey,
      floatHeaderSlivers: true,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              title: Text('Explore'),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                tabs: [
                  for (ItemCategory itemCategory in ItemCategory.values)
                    CategoryTab(
                      itemCategory: itemCategory,
                    ),
                ],
                isScrollable: true,
                controller: _tabController,
              ),
            ),
          ),
        ];
      },
      body: Builder(builder: (BuildContext context) {
        return TabBarView(controller: _tabController, children: [
          for (ItemCategory itemCategory in ItemCategory.values)
            CategoryScrollView(category: itemCategory, controller: innerController, key: PageStorageKey<String>(itemCategory.displayTitle),),
        ]);
      }),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  ScrollController get innerController {
    return _globalKey.currentState!.outerController;
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