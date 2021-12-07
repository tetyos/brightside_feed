import 'package:flutter/material.dart';
import 'package:nexth/components/intro_card.dart';
import 'package:nexth/components/item_list_scroll_view.dart';
import 'package:nexth/model/item_list_model.dart';
import 'package:nexth/model/model_manager.dart';

class ExploreLikesTab extends StatefulWidget {

  @override
  _ExploreLikesTabState createState() => _ExploreLikesTabState();
}

class _ExploreLikesTabState extends State<ExploreLikesTab> {
  late ItemListModel _itemListModel;
  late Widget _introCard;

  @override
  void initState() {
    super.initState();
    _itemListModel = ModelManager.instance.exploreLikesModel;

    _introCard = SliverToBoxAdapter(
      child: const IntroCard(
          title: "Your likes",
          message:
              "In this list you find every item you liked or you gave an award to."),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ItemListScrollView(itemListModel: _itemListModel, introCard: _introCard,);
  }
}
