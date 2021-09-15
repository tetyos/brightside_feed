import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inspired/components/preview_data_loader.dart';
import 'package:inspired/testdata/basic_test_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImportJsonDialog extends StatefulWidget {

  @override
  _ImportJsonDialogState createState() => _ImportJsonDialogState();
}

class _ImportJsonDialogState extends State<ImportJsonDialog> {
  String input = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Import item data from JSON '),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Paste json here:'),
            TextField(
              maxLines: 3,
              onChanged: (value) {
                input = value;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Import'),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            if (input == '') {
              showSnackBar("Please insert json");
            } else {
              await loadItemsFromJson(input);
            }
          },
        ),
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future<void> loadItemsFromJson(String input) async {
    try {
      bool anythingImported = false;
      List<String> inputs = input.split('___');
      for (String jsonRow in inputs) {
        if (jsonRow != " " && jsonRow != '') {
          Map<String, dynamic> itemMap = jsonDecode(jsonRow);
          ItemData itemData = ItemData.fromJson(itemMap);
          await addJsonToLocalData(jsonRow);
          BasicTestUrls.testPreviewData.add(itemData);
          anythingImported = true;
        }
      }
      if (anythingImported) {
        showSnackBar("Import successful!");
        Navigator.of(context).pop();
      } else {
        showSnackBar("Nothing could be imported.");
      }
    } on FormatException catch (formatException) {
      print(formatException);
      showSnackBar("Json could not be parsed. Exception: " + formatException.message);
    }
  }

  void showSnackBar(String content){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        backgroundColor: Colors.teal[800],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> addJsonToLocalData(String jsonRow) async {
    final prefs = await SharedPreferences.getInstance();
    int itemsStored = prefs.getInt(BasicTestUrls.items_stored_string) ?? 0;
    // access to persistent storage could be improved for item stored count. overkill for now.
    prefs.setInt(BasicTestUrls.items_stored_string, itemsStored + 1);
    prefs.setString(itemsStored.toString(), jsonRow);
  }

}

