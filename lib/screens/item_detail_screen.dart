import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nexth/backend_connection/api_connector.dart';
import 'package:nexth/backend_connection/api_key_identifier.dart' as API_Identifier;
import 'package:nexth/bloc/item_list_model_cubit.dart';
import 'package:nexth/components/vote_buttons.dart';
import 'package:nexth/model/list_models/category_list_model.dart';
import 'package:nexth/model/list_models/incubator_list_model.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/model_manager.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/utils/constants.dart';
import 'package:nexth/utils/preview_data_loader.dart';
import 'package:nexth/utils/ui_utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetailScreen extends StatefulWidget {

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  bool _hasItem = true;
  late ItemData _itemData;
  late GestureDetector _imageWidget;
  late String _dateString;
  late String _host;
  bool isAdmin = false;
  bool isUnsafeIncubatorItem = false;
  bool isInc1IncubatorItem = false;


  @override
  void initState() {
    super.initState();

    ItemData? item = Provider.of<AppState>(context, listen: false).currentSelectedItem;
    if (item == null) {
      _hasItem = false;
      return;
    }

    _itemData = item;
    isAdmin = ModelManager.instance.isAdmin();
    isUnsafeIncubatorItem = _itemData.incubatorStatus == IncubatorType.unsafe;
    isInc1IncubatorItem = _itemData.incubatorStatus == IncubatorType.inc1;
    _dateString = PreviewDataLoader.getFormattedDateFromIso8601(_itemData.dateAdded);
    _host = PreviewDataLoader.getHostFromUrl(_itemData.url);

    if (isUnsafeIncubatorItem) {
      _itemData.preLoadImage().then((value) => setState(() {}));
    }

    Widget imageWidget = _itemData.imageProvider == null
        ? SpinKitCircle(color: Colors.blueAccent)
        : ClipRRect(
            child: Image(
              image: _itemData.imageProvider!,
            ),
            borderRadius: BorderRadius.circular(8),
          );
    _imageWidget = GestureDetector(
        onTap: launchUrl,
        child: imageWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasItem) {
      return Text("Glitch in the Matrix");
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          renderImage(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_itemData.title, style: TextStyle(fontSize: 16),),
                if (_itemData.description != null) ...[
                  SizedBox(height: 5),
                  Text(
                    _itemData.description!,
                    style: TextStyle(color: Color(0x8a000000), fontSize: 14),
                  )
                ],
                SizedBox(height: 5),
                Text(_host, style: TextStyle(color: kColorPrimary, fontWeight: FontWeight.bold),),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Added on: " +  _dateString,
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                    if (_itemData.itemCategory != null) ...[
                      Text(_itemData.itemCategory!.displayTitle),
                      SizedBox(width: 2),
                      Icon(_itemData.itemCategory!.icon),
                    ],
                  ],
                ),
                renderDivider(),
                renderSocialIcons(),
                if (isUnsafeIncubatorItem)
                  Center(child: ElevatedButton(onPressed: () => showRemoveUnsafeDialog(), child: Text("Remove unsafe status"))),
                if (isInc1IncubatorItem)
                  Center(child: ElevatedButton(onPressed: () => showRemoveIncStatusDialog(), child: Text("Remove incubator status"))),
                Center(child: ElevatedButton(onPressed: () => showDeleteDialog(), child: Text("Delete"))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void launchUrl() async {
    String url = _itemData.url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      try {
        await launch(url);
      } catch (err) {
        throw Exception('Could not launch $url. Error: $err');
      }
    }
  }

  Widget renderImage() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Padding(
        child: _imageWidget,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }

  Widget renderDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Divider(color: Colors.black),
    );
  }

  renderSocialIcons() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Icons.remove_red_eye_outlined),
              SizedBox(width: 2),
              Text("4.505"),
            ],
          ),
        ),
        VoteButtons(itemData: _itemData),
      ],
    );
  }

  Future<void> showDeleteDialog() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete this item'),
        content: const Text('Item will removed from app.'),
        actions: <Widget>[
          renderCancelButton(context),
          TextButton(
            onPressed: () async {
              bool actionSuccessful = await APIConnector.postAdminAction(API_Identifier.adminAction_deleteItem, _itemData.id);
              if (actionSuccessful) {
                ModelManager.instance.deleteItem(_itemData);
                Provider.of<AppState>(context, listen: false).currentSelectedItem = null;
                UIUtils.showSnackBar("Item deleted!", context);
              } else {
                UIUtils.showSnackBar("Item could not be deleted!", context);
              }
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> showRemoveUnsafeDialog() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remove unsafe status'),
        content: const Text('Item will be moved to trusted sources.'),
        actions: <Widget>[
          renderCancelButton(context),
          TextButton(
            onPressed: () async {
              bool actionSuccessful = await APIConnector.postAdminAction(API_Identifier.adminAction_removeUnsafeStatus, _itemData.id);
              if (actionSuccessful) {
                Provider.of<AppState>(context, listen: false).setIncubatorScreenCurrentTabAndNotify(IncubatorType.inc1.tabNumber);
                context.read<ItemListModelCubit>().resetIncubatorModel(IncubatorType.inc1);
                context.read<ItemListModelCubit>().resetIncubatorModel(IncubatorType.unsafe);
                Provider.of<AppState>(context, listen: false).currentSelectedItem = null;
                UIUtils.showSnackBar("Unsafe status removed!", context);
              } else {
                UIUtils.showSnackBar("Could not remove unsafe status!", context);
              }
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> showRemoveIncStatusDialog() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remove incubator status'),
        content: const Text('Item is visible in whole app after this action.'),
        actions: <Widget>[
          renderCancelButton(context),
          TextButton(
            onPressed: () async {
              bool actionSuccessful = await APIConnector.postAdminAction(API_Identifier.adminAction_removeIncStatus, _itemData.id);
              if (actionSuccessful) {
                context.read<ItemListModelCubit>().resetIncubatorModel(IncubatorType.inc1);
                Provider.of<AppState>(context, listen: false).currentSelectedItem = null;
                UIUtils.showSnackBar("Incubator status removed!", context);
              } else {
                UIUtils.showSnackBar("Could not remove incubator status!", context);
              }
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget renderCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context, 'Cancel'),
      child: const Text('Cancel'),
    );
  }
}

