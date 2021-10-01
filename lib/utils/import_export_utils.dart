import 'dart:convert' as Dart;
import 'package:flutter/cupertino.dart';
import 'package:nexth/model/basic_test_urls.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/utils/ui_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImportExportUtils {

  static Future<void> loadItemsFromJson(String input, BuildContext context) async {
    try {
      bool anythingImported = false;
      List<String> inputs = input.split('___');
      for (String jsonRow in inputs) {
        if (jsonRow != " " && jsonRow != '') {
          Map<String, dynamic> itemMap = Dart.jsonDecode(jsonRow);
          ItemData itemData = ItemData.fromJson(itemMap);
          await addJsonToLocalData(jsonRow);
          BasicTestUrls.testItemsRecent.add(itemData);
          anythingImported = true;
        }
      }
      if (anythingImported) {
        UIUtils.showSnackBar("Import successful!", context);
        Navigator.of(context).pop();
      } else {
        UIUtils.showSnackBar("Nothing could be imported.", context);
      }
    } on FormatException catch (formatException) {
      print(formatException);
      UIUtils.showSnackBar("Json could not be parsed. Exception: " + formatException.message, context);
    }
  }

  static Future<void> addURLToLocalData(ItemData itemData) async {
    String itemAsJson = Dart.jsonEncode(itemData);
    await addJsonToLocalData(itemAsJson);
  }

  static Future<void> addJsonToLocalData(String jsonRow) async {
    final prefs = await SharedPreferences.getInstance();
    int itemsStored = prefs.getInt(BasicTestUrls.items_stored_string) ?? 0;
    // access to persistent storage could be improved for item stored count. overkill for now.
    prefs.setInt(BasicTestUrls.items_stored_string, itemsStored + 1);
    prefs.setString(itemsStored.toString(), jsonRow);
  }
}