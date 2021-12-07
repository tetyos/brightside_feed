import 'package:flutter/material.dart';
import 'package:nexth/components/item_list_scroll_view.dart';
import 'package:nexth/model/category_list_model.dart';
import 'package:nexth/model/item_list_model.dart';
import 'package:nexth/model/model_manager.dart';

class CategoryTabs extends StatefulWidget {
  final ItemCategory category;

  CategoryTabs({required this.category, required Key key}) : super(key: key);

  @override
  _CategoryTabsState createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  late ItemListModel _itemListModel;

  @override
  void initState() {
    super.initState();
    _itemListModel = ModelManager.instance.getModelForCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return ItemListScrollView(itemListModel: _itemListModel);
  }
}
