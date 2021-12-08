import 'package:flutter/material.dart';
import 'package:nexth/components/intro_card.dart';
import 'package:nexth/components/item_list_scroll_view.dart';
import 'package:nexth/model/item_list_model.dart';
import 'package:nexth/model/model_manager.dart';

class ExplorePopularTab extends StatefulWidget {

  @override
  _ExplorePopularTabState createState() => _ExplorePopularTabState();
}

class _ExplorePopularTabState extends State<ExplorePopularTab> {
  late ItemListModel _itemListModel;
  late Widget _introCard;

  @override
  void initState() {
    super.initState();
    _itemListModel = ModelManager.instance.exploreLikesModel;

    _introCard = SliverToBoxAdapter(
      child: const IntroCard(
          title: "Popular items",
          message:
              "In this list you find all items that received awards by the community. "),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ItemListScrollView(itemListModel: _itemListModel, introCard: _introCard,);
  }
}