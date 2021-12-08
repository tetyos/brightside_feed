import 'package:flutter/material.dart';
import 'package:nexth/components/item_list_scroll_view.dart';
import 'package:nexth/model/explore_popular_model.dart';
import 'package:nexth/model/item_list_model.dart';
import 'package:nexth/model/model_manager.dart';
import 'package:nexth/utils/constants.dart';

class ExplorePopularTab extends StatefulWidget {

  @override
  _ExplorePopularTabState createState() => _ExplorePopularTabState();
}

class _ExplorePopularTabState extends State<ExplorePopularTab> {
  late ItemListModel _itemListModel;

  @override
  void initState() {
    super.initState();
    _itemListModel = ModelManager.instance.exploreLikesModel;
  }

  @override
  Widget build(BuildContext context) {
    return ItemListScrollView(
      itemListModel: _itemListModel,
      introCard: const SliverToBoxAdapter(child: const FilterChooserCard()),
    );
  }
}

class FilterChooserCard extends StatefulWidget {

  const FilterChooserCard();

  @override
  State<FilterChooserCard> createState() => _FilterChooserCardState();
}

class _FilterChooserCardState extends State<FilterChooserCard> {
  Periodicity currentSelection = Periodicity.week;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              children: [
                Text(
                  "Popular items",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "In this list you find only items that received awards or likes.",
                  style: TextStyle(color: Colors.black87,),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          color: kColorPrimaryLight,
        ),
      ),
    );
  }
}