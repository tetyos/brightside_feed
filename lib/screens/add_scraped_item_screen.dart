import 'package:flutter/material.dart';
import 'package:brightside_feed/backend_connection/api_connector.dart';
import 'package:brightside_feed/backend_connection/item_update.dart';
import 'package:brightside_feed/bloc/item_list_model_cubit.dart';
import 'package:brightside_feed/components/add_url_preview_card.dart';
import 'package:brightside_feed/model/category_tree_model.dart';
import 'package:brightside_feed/model/item_data.dart';
import 'package:brightside_feed/components/category_chooser/category_chooser.dart';
import 'package:brightside_feed/model/list_models/incubator_list_model.dart';
import 'package:brightside_feed/utils/ui_utils.dart';
import 'package:provider/provider.dart';

class AddScrapedItemScreen extends StatefulWidget {
  final ItemData _itemData;

  AddScrapedItemScreen({required ItemData itemData}) : _itemData = itemData;

  @override
  _AddScrapedItemScreenState createState() => _AddScrapedItemScreenState();
}

class _AddScrapedItemScreenState extends State<AddScrapedItemScreen> {
  List<CategoryElement> _categoriesSelection = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
      decoration: BoxDecoration(
        color: Color(0xFFfafafa),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Add item', textAlign: TextAlign.center, style: TextStyle(fontSize: 30.0)),
            AddUrlPreviewCard(linkPreviewData: widget._itemData),
            SizedBox(height: 10),
            Text('Choose categories of content', textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 10),
            CategoryChooser(callback: (currentCategories) => _categoriesSelection = currentCategories),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: onAdd,
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onAdd() async {
    bool successful =
        await APIConnector.updateScrapedItem(ItemUpdate(itemId: widget._itemData.id, categories: _categoriesSelection));
    if (successful) {
      context.read<ItemListModelCubit>().deleteItem(IncubatorType.scraped, widget._itemData);
      context.read<ItemListModelCubit>().resetIncubatorModel(IncubatorType.inc1);
      UIUtils.showSnackBar("Item added!", context);
    } else {
      UIUtils.showSnackBar("Server could not be reached!", context);
    }
    Navigator.pop(context);
  }
}
