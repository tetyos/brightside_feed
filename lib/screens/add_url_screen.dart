import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inspired/components/add_url_preview_card.dart';
import 'package:inspired/screens/item_list_view_model.dart';
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
  ItemCategory? _categorySelection;
  String? _languageSelection;

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
            SizedBox(height: 40),
            Text(
              'Add meta data',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20),
            CategoryDropdownButton(callback: (ItemCategory? value) => _categorySelection = value),
            SizedBox(height: 10),
            LanguageDropdownButton(callback: (String? value) => _languageSelection = value),
            SizedBox(height: 30),
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
      _itemData!.itemCategory = _categorySelection;
      BasicTestUrls.testItemsRecent.add(_itemData!);
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

class CategoryDropdownButton extends StatefulWidget {
  final Function(ItemCategory?) callback;

  CategoryDropdownButton({required this.callback});

  @override
  _CategoryDropdownButtonState createState() => _CategoryDropdownButtonState();
}

class _CategoryDropdownButtonState extends State<CategoryDropdownButton> {
  ItemCategory? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.category_rounded,
      ),
      title: DropdownButton<ItemCategory>(
        value: dropdownValue,
        hint: Text('Choose a category for content'),
        //icon: const Icon(Icons.arrow_downward),
        //iconSize: 24,
        //elevation: 16,
        isExpanded: true,
        style: const TextStyle(color: Constants.kColorPrimary),
        underline: Container(
          height: 2,
          color: Color(0xFFBDBDBD),
        ),
        onChanged: (ItemCategory? newValue) {
          widget.callback(newValue);
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: ItemCategory.values.map<DropdownMenuItem<ItemCategory>>((ItemCategory value) {
          return DropdownMenuItem<ItemCategory>(
            value: value,
            child: Text(value.displayTitle),
          );
        }).toList(),
      ),
    );
  }
}

class LanguageDropdownButton extends StatefulWidget {
  final Function(String?) callback;

  LanguageDropdownButton({required this.callback});

  @override
  _LanguageDropdownButtonState createState() => _LanguageDropdownButtonState();
}

class _LanguageDropdownButtonState extends State<LanguageDropdownButton> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.language,
      ),
      title: DropdownButton<String>(
        value: dropdownValue,
        hint: Text('Language of content'),
        //icon: const Icon(Icons.arrow_downward),
        //iconSize: 24,
        //elevation: 16,
        isExpanded: true,
        style: const TextStyle(color: Constants.kColorPrimary),
        underline: Container(
          height: 2,
          color: Color(0xFFBDBDBD),
        ),
        onChanged: (String? newValue) {
          widget.callback(newValue);
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: <String>[
          'English', 'German',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
