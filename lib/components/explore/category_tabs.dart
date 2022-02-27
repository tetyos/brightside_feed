import 'package:flutter/material.dart';
import 'package:brightside_feed/components/item_list_scroll_view.dart';
import 'package:brightside_feed/model/list_models/item_list_model.dart';
import 'package:brightside_feed/model/model_manager.dart';

class CategoryTab extends StatefulWidget {

  @override
  _CategoryTabState createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  late ItemListModel _itemListModel;

  @override
  void initState() {
    super.initState();
    _itemListModel = ModelManager.instance.categoryItemModel;
  }

  @override
  Widget build(BuildContext context) {
    return ItemListScrollView(itemListModel: _itemListModel);
  }
}
