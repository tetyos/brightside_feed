import 'package:flutter/material.dart';
import 'package:nexth/components/intro_card.dart';
import 'package:nexth/components/item_list_scroll_view.dart';
import 'package:nexth/model/list_models/item_list_model.dart';
import 'package:nexth/model/model_manager.dart';

class ExplorePopularTab extends StatefulWidget {

  @override
  _ExplorePopularTabState createState() => _ExplorePopularTabState();
}

class _ExplorePopularTabState extends State<ExplorePopularTab> {
  late ItemListModel _itemListModel;

  @override
  void initState() {
    super.initState();
    _itemListModel = ModelManager.instance.explorePopularModel;
  }

  @override
  Widget build(BuildContext context) {
    return ItemListScrollView(
      itemListModel: _itemListModel,
      introCard: const SliverToBoxAdapter(
        child: const IntroCard(
          title: "Popular items",
          message: "In this list you find only items that received awards or likes.",
        ),
      ),
    );
  }
}