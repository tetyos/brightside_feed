import 'dart:convert' as Dart;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart' as LinkPreviewer;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:brightside_feed/backend_connection/api_connector.dart';
import 'package:brightside_feed/bloc/item_list_model_cubit.dart';
import 'package:brightside_feed/components/add_url_preview_card.dart';
import 'package:brightside_feed/model/category_tree_model.dart';
import 'package:brightside_feed/model/list_models/incubator_list_model.dart';
import 'package:brightside_feed/model/item_data.dart';
import 'package:brightside_feed/navigation/app_state.dart';
import 'package:brightside_feed/navigation/route_paths.dart';
import 'package:brightside_feed/components/category_chooser/category_chooser.dart';
import 'package:brightside_feed/utils/constants.dart' as Constants;
import 'package:brightside_feed/utils/preview_data_loader.dart';
import 'package:brightside_feed/utils/ui_utils.dart';
import 'package:provider/provider.dart';

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
  List<CategoryElement> _categoriesSelection = [];
  String? _languageSelection;

  bool isDefaultPreviewDataLoader = true;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(urlInputChanged);
    isDefaultPreviewDataLoader = Provider.of<AppState>(context, listen: false).isDefaultPreviewDataLoader;
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
            Text('Add a link', textAlign: TextAlign.center, style: TextStyle(fontSize: 30.0)),
            if (!isDefaultPreviewDataLoader)
              Text('(Using non-default preview-data-loader)', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0)),
            _previewCard,
            Row(children: [
              Expanded(child: TextField(controller: _textEditingController)),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(onPressed: onPaste, child: Text('Paste'))
            ]),
            SizedBox(height: 40),
            Text('Choose categories of content', textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 20),
            CategoryChooser(callback: (currentCategories) => _categoriesSelection = currentCategories),
            // SizedBox(height: 10),
            // Text('Add optional meta data', textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0)),
            // SizedBox(height: 10),
            // SizedBox(height: 10),
            // LanguageDropdownButton(callback: (String? value) => _languageSelection = value),
            SizedBox(height: 10),
            UIUtils.renderDivider(),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.secondaryVariant),
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
    if (input == '' || _itemData == null) {
      UIUtils.showSnackBar("Please insert valid link", context);
    } else {
      _itemData!.categories = _categoriesSelection;
      ItemData? itemData = await APIConnector.postItem(Dart.jsonEncode(_itemData));
      if (itemData != null) {
        IncubatorType? incubatorTypeOfItem = itemData.incubatorStatus;
        if (incubatorTypeOfItem == null) {
          UIUtils.showSnackBar("Glitch in the matrix detected. Run!", context);
          print("Item with id: '" + itemData.id + "' had no incubatorStatus. This should not happen.");
        } else {
          Provider.of<AppState>(context, listen: false).setIncubatorScreenCurrentTabAndNotify(incubatorTypeOfItem.tabNumber);
          Provider.of<AppState>(context, listen: false).currentRoutePath = IncubatorPath();
          context.read<ItemListModelCubit>().resetIncubatorModel(incubatorTypeOfItem);
          UIUtils.showSnackBar("Link added!", context);
        }
      } else {
        UIUtils.showSnackBar("Server could not be reached!", context);
      }
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

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }


  Future<void> urlInputChanged() async {
    // todo introduce mechanism, so that in case text is changed trough typing not x-http requests are triggered.
    String input = _textEditingController.text;

    if (input == _lastInput) {
      return;
    }
    if (input == "") {
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
    final emailRegexp = RegExp(LinkPreviewer.regexEmail, caseSensitive: false);
    final textWithoutEmails = input.replaceAllMapped(emailRegexp, (match) => '').trim();
    if (textWithoutEmails.isEmpty) return false;

    final urlRegexp = RegExp(LinkPreviewer.regexLink, caseSensitive: false);
    final matches = urlRegexp.allMatches(textWithoutEmails);
    if (matches.isEmpty) return false;
    return true;
  }

  void loadPreviewData(String input) async {
    setState(() {
      _previewCard =
          PreviewPlaceHolderCard(child: SpinKitCircle(color: Constants.kColorPrimaryLight,),);
      _lastInput = input;
    });
    try {
      _itemData = await PreviewDataLoader.fetchDataFromUrl(input, isDefaultPreviewDataLoader);
      _previewCard = AddUrlPreviewCard(linkPreviewData: _itemData!);
    } catch (e, s) {
      print(e);
      print(s);
      _previewCard = PreviewPlaceHolderCard(child: Text("Link does not work."));
    }
    if (mounted) {
      setState(() {});
    }
  }
}

class PreviewPlaceHolderCard extends StatelessWidget {

  final Widget child;

  PreviewPlaceHolderCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: child),
        ),
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
