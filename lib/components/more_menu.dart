import 'package:flutter/material.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/utils/ui_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
          case "browser":
            launchUrl();
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
          value: "browser",
          child: ListTile(
            leading: Icon(Icons.open_in_new_outlined),
            title: const Text('Open in browser'),
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

  void launchUrl() async {
    String url = itemData.url;
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
}
