import 'package:flutter/material.dart';
import 'package:nexth/backend_connection/api_connector.dart';
import 'package:nexth/backend_connection/item_update.dart';
import 'package:nexth/components/category_chooser/category_chooser.dart';
import 'package:nexth/model/category_tree_model.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/utils/constants.dart';
import 'package:nexth/utils/ui_utils.dart';

class CategoryUpdater extends StatefulWidget {
  final ItemData itemData;
  const CategoryUpdater({required this.itemData, Key? key}) : super(key: key);

  @override
  _CategoryUpdaterState createState() => _CategoryUpdaterState();
}

class _CategoryUpdaterState extends State<CategoryUpdater> {
  List<CategoryElement> currentCategories = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UIUtils.renderDivider(),
        CategoryChooser(
            callback: (elements) {
              currentCategories = elements;
            },
            initElements: widget.itemData.categories),
        UIUtils.renderDivider(),
        ElevatedButton(
          onPressed: () => sentUpdate(context),
          child: Text("Update"),
          style: ElevatedButton.styleFrom(primary: kColorSecondaryDark),)
      ],
    );
  }

  Future<void> sentUpdate(BuildContext context) async {
    bool successful = await APIConnector.updateItem(ItemUpdate(itemId: widget.itemData.id, categories: currentCategories));
    if (successful) {
      UIUtils.showSnackBar("Update successful!", context);
    } else {
      UIUtils.showSnackBar("Item could not be updated!", context);
    }
  }
}
