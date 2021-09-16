import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inspired/components/add_url_preview_card.dart';
import 'package:inspired/testdata/basic_test_urls.dart';
import 'package:inspired/utils/constants.dart' as Constants;
import 'package:inspired/utils/import_export_utils.dart';
import 'package:inspired/utils/preview_data_loader.dart';
import 'package:inspired/utils/ui_utils.dart';

class AddUrlScreen extends StatefulWidget {
  @override
  _AddUrlScreenState createState() => _AddUrlScreenState();
}

class _AddUrlScreenState extends State<AddUrlScreen> {
  static const String no_input_yet_label = "Preview appears after entering a link.";
  TextEditingController _textEditingController = TextEditingController();
  Widget _previewCard = PreviewPlaceHolderCard(child: Text(no_input_yet_label),);
  ItemData? _itemData;
  String? _lastInput;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(urlInputChanged);
  }

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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add Url',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30.0),
            ),
            _previewCard,
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
                  onPressed: onPaste,
                  child: Text('Paste'),
                )
              ],
            ),
            SizedBox(height: 20),
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
    String input = _textEditingController.text;
    FocusScope.of(context).unfocus();
    if (input == '' || _itemData == null) {
      UIUtils.showSnackBar("Please insert valid link", context);
    } else {
      BasicTestUrls.testPreviewData.add(_itemData!);
      ImportExportUtils.addURLToLocalData(_itemData!);
      UIUtils.showSnackBar("Link added!", context);
    }
    Navigator.pop(context);
  }

  Future<void> onPaste() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    if (data != null) {
      setState(() {
        _textEditingController.text = data.text.toString();
        // _textEditingController.value = TextEditingValue(text : data.text.toString());
      });
    }
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


  Future<void> urlInputChanged() async {
    String input = _textEditingController.text;

    if (input == _lastInput) {
      return;
    }
    if (input ==  "") {
      setState(() {
        _lastInput = input;
        _itemData = null;
        _previewCard = PreviewPlaceHolderCard(child: Text(no_input_yet_label),);
      });
    } else if (isValidUrl(input)) {
      loadPreviewData(input);
    } else {
      setState(() {
        _lastInput = input;
        _itemData = null;
        _previewCard = PreviewPlaceHolderCard(child: Text("Not a valid link."));
      });
    }

  }

  bool isValidUrl(String input) {
    final emailRegexp = RegExp(REGEX_EMAIL, caseSensitive: false);
    final textWithoutEmails = input.replaceAllMapped(emailRegexp, (match) => '').trim();
    if (textWithoutEmails.isEmpty) return false;

    final urlRegexp = RegExp(REGEX_LINK, caseSensitive: false);
    final matches = urlRegexp.allMatches(textWithoutEmails);
    if (matches.isEmpty) return false;
    return true;
  }

  void loadPreviewData(String input) async {
    setState(() {
      _previewCard = PreviewPlaceHolderCard(child: SpinKitCircle(color: Constants.kColorPrimaryLight,),);
      _lastInput = input;
    });
    _itemData = await PreviewDataLoader.fetchDataFromUrl(input);
    setState(() {
      _previewCard = AddUrlPreviewCard(linkPreviewData: _itemData!);
      // todo catch parsing exception (also valid semantic links might lead to nowhere)
    });
  }
}

class PreviewPlaceHolderCard extends StatelessWidget {

  final Widget child;

  PreviewPlaceHolderCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Card(
        color: Constants.kColorGreyLight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: child),
        ),
      ),
    );
  }
}
