import 'package:flutter/material.dart';
import 'package:nexth/components/category_scroll_view.dart';
import 'package:nexth/model/item_list_view_model.dart';
import 'package:nexth/utils/constants.dart';
import 'package:nexth/utils/custom_page_view_scroll_physics.dart';

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
    _tabController = new TabController(length: ItemCategory.values.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        color: kColorPrimary,
        child: TabBar(
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
      Expanded(
        child: TabBarView(controller: _tabController, physics: CustomPageViewScrollPhysics(), children: [
          for (ItemCategory itemCategory in ItemCategory.values)
            CategoryScrollView(
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