import 'package:flutter/material.dart';
import 'package:inspired/utils/import_export_utils.dart';
import 'package:inspired/utils/ui_utils.dart';

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
              UIUtils.showSnackBar("Please insert json", context);
            } else {
              await ImportExportUtils.loadItemsFromJson(input, context);
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
}

