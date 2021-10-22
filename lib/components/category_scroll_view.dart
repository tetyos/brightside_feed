import 'package:flutter/material.dart';
import 'package:nexth/model/item_list_model.dart';
import 'package:nexth/model/model_manager.dart';

import 'item_list_scroll_view.dart';

class CategoryScrollView extends StatefulWidget {
  final Key key;
  final ItemCategory category;

  CategoryScrollView({required this.category, required this.key}) : super(key: key);

  @override
  _CategoryScrollViewState createState() => _CategoryScrollViewState();
}

class _CategoryScrollViewState extends State<CategoryScrollView> {
  late ItemListModel _itemListModel;

  @override
  void initState() {
    super.initState();
    _itemListModel = ModelManager.instance.getModelForCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return ItemListScrollView(key: widget.key, itemListModel: _itemListModel);
  }
}
