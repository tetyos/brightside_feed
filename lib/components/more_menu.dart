import 'package:flutter/material.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/utils/ui_utils.dart';
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
            UIUtils.showSnackBar("Not yet implemented", context);
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
          child: const Text('Share'),
        ),
        PopupMenuItem<String>(
          value: "browser",
          child: const Text('Open in browser'),
        ),
        PopupMenuItem<String>(
          value: "flag",
          child: const Text('Report content'),
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
