import 'package:flutter/material.dart';
import 'package:nexth/components/intro_card.dart';
import 'package:nexth/components/item_list_scroll_view.dart';
import 'package:nexth/model/list_models/item_list_model.dart';
import 'package:nexth/model/model_manager.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:provider/provider.dart';

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
              "In this list you find every item you liked or gave an award to."),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Provider.of<AppState>(context, listen: false).isUserLoggedIn) {
      return renderInfoCard();
    }
    return ItemListScrollView(itemListModel: _itemListModel, introCard: _introCard,);
  }

  Widget renderInfoCard() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [const IntroCard(
        title: "Your likes",
        message: "Likes are currently only supported in app.",
      ),]
    );
  }
}
