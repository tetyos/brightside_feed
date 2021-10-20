import 'dart:convert' as Dart;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexth/components/import_json_dialog.dart';
import 'package:nexth/components/item_card_custom.dart';
import 'package:nexth/model/item_list_view_model.dart';

class NaviLeft extends StatelessWidget {
  final ModelManager modelManager;


  NaviLeft({required this.modelManager});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal[800],
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Print JSON'),
            onTap: () {
              for (ItemCardCustom itemCardCustom  in modelManager.recentItemList) {
                print(Dart.jsonEncode(itemCardCustom.linkPreviewData));
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Export JSON'),
            onTap: () {
              _showExportJsonDialog(context, modelManager);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Import JSON'),
            onTap: () {
              Navigator.of(context).pop();
              _showImportJsonDialog(context);
            },
          ),
        ],
      ),
    );
  }
}

Future<void> _showExportJsonDialog(BuildContext context, ModelManager modelManager) async {
  String clipboardString = '';
  for (ItemCardCustom itemCardCustom  in modelManager.recentItemList) {
    clipboardString  += Dart.jsonEncode(itemCardCustom.linkPreviewData) + '___\n ';
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Export item data as JSON '),
        content: SingleChildScrollView(
          child: TextButton(
            child: const Text('Copy json to clipboard'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: clipboardString));
            },
          )
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> _showImportJsonDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return ImportJsonDialog();
    },
  );
}