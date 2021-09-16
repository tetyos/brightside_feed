import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspired/testdata/basic_test_urls.dart';
import 'package:inspired/utils/import_export_utils.dart';
import 'package:inspired/utils/preview_data_loader.dart';
import 'package:inspired/utils/ui_utils.dart';

class AddUrlScreen extends StatefulWidget {
  @override
  _AddUrlScreenState createState() => _AddUrlScreenState();
}

class _AddUrlScreenState extends State<AddUrlScreen> {
  TextEditingController _textEditingController = TextEditingController();
  String _input = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add Url',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textEditingController,
                  // autofocus: true,
                ),
              ),
              SizedBox(width: 10,),
              ElevatedButton(
                onPressed: () async {
                  ClipboardData? data = await Clipboard.getData('text/plain');
                  if (data != null) {
                    setState(() {
                      _textEditingController.text = data.text.toString();
                      // _textEditingController.value = TextEditingValue(text : data.text.toString());
                    });
                  }
                },
                child: Text('Paste'),
              )
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              String input = _textEditingController.text;
              FocusScope.of(context).unfocus();
              if (input == '') {
                UIUtils.showSnackBar("Please insert json", context);
              } else {
                ItemData itemData = await PreviewDataLoader.fetchDataFromUrl(input);
                BasicTestUrls.testPreviewData.add(itemData);
                ImportExportUtils.addURLToLocalData(itemData);
              }
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  // void _printLatestValue() {
  //   _input = _textEditingController.text;
  //   print('Second text field: ${_textEditingController.text}');
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _textEditingController.addListener(_printLatestValue);
  // }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

}
