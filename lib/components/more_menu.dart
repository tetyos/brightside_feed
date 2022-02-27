import 'package:flutter/material.dart';
import 'package:brightside_feed/model/item_data.dart';
import 'package:brightside_feed/utils/ui_utils.dart';
import 'package:share_plus/share_plus.dart';

class MoreMenu extends StatelessWidget {
  final ItemData itemData;
  final Color buttonColor;
  const MoreMenu({required this.itemData, this.buttonColor = Colors.white, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      child: Row(
        children: [
          SizedBox(height: 48, width: 3),
          Icon(Icons.more_vert, color: buttonColor),
          SizedBox(width: 10),
        ],
      ),
      onSelected: (String value) {
        switch (value) {
          case "share":
            // Share.share(itemData.url);
            // todo fix app name, as soon as set
            Share.share('Check what I found on some-app ' + itemData.url);
            break;
          case "flag":
            UIUtils.showSnackBar("Not yet implemented", context);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          value: "share",
          child: ListTile(
            leading: Icon(Icons.share_outlined),
            title: const Text('Share'),
            dense: true,
            horizontalTitleGap: 0,
          ),
        ),
        PopupMenuItem<String>(
          value: "flag",
          child: ListTile(
            leading: Icon(Icons.report_outlined),
            title: const Text('Report content'),
            dense: true,
            horizontalTitleGap: 0,
          ),
        ),
      ],
    );
  }
}
