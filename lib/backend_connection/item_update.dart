import 'package:brightside_feed/model/category_tree_model.dart';

/// Helper class for generating the json-query that is needed for an item-update.
class ItemUpdate {
  String itemId;
  List<CategoryElement> categories;

  ItemUpdate({required this.itemId, this.categories = const [], });

  Map<String, dynamic> toJson() => {
    'itemId': itemId,
    'categories': categories,
  };
}