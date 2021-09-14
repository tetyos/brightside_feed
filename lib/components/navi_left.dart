import 'dart:convert' as Dart;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspired/components/item_card_custom.dart';
import 'package:inspired/components/item_list_view.dart';

class NaviLeft extends StatelessWidget {
  final ItemListViewModel itemListViewModel;


  NaviLeft({required this.itemListViewModel});

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
              for (ItemCardCustom itemCardCustom  in itemListViewModel.itemList) {
                print(Dart.jsonEncode(itemCardCustom.linkPreviewData));
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Export JSON'),
            onTap: () {
              _showMyDialog(context, itemListViewModel);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Import JSON'),
          ),
        ],
      ),
    );
  }
}

Future<void> _showMyDialog(BuildContext context, ItemListViewModel itemListViewModel) async {
  String clipboardString = '';
  for (ItemCardCustom itemCardCustom  in itemListViewModel.itemList) {
    clipboardString  += Dart.jsonEncode(itemCardCustom.linkPreviewData) + '\n';
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