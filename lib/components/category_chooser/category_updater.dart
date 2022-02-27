import 'package:flutter/material.dart';
import 'package:brightside_feed/backend_connection/api_connector.dart';
import 'package:brightside_feed/backend_connection/item_update.dart';
import 'package:brightside_feed/components/category_chooser/category_chooser.dart';
import 'package:brightside_feed/model/category_tree_model.dart';
import 'package:brightside_feed/model/item_data.dart';
import 'package:brightside_feed/utils/constants.dart';
import 'package:brightside_feed/utils/ui_utils.dart';

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
