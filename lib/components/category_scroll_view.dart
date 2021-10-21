import 'package:flutter/material.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/item_list_model.dart';
import 'package:nexth/model/model_manager.dart';
import 'package:nexth/model/basic_test_urls.dart';

import 'generic_scroll_view.dart';

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
    return GenericScrollView(key: widget.key, itemListModel: _itemListModel);
  }

  Future<List<ItemData>> requestMoreItems(int from, int to) async {
    List<ItemData> categoryItems = BasicTestUrls.testItemsRecent
        .where((itemData) => itemData.itemCategory == widget.category)
        .toList();
    var categoryItemsLength = categoryItems.length;
    if (from > categoryItemsLength) {
      return [];
    }
    int end = to > categoryItemsLength ? categoryItemsLength : to;
    List<ItemData> newData = categoryItems.sublist(from, end);

    List<Future<void>> futures = [];
    for (ItemData linkPreviewData in newData) {
      futures.add(linkPreviewData.preLoadImage());
    }
    await Future.wait(futures);
    return newData;
  }
}
