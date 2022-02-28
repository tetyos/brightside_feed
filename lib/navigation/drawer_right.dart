import 'dart:html';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:brightside_feed/navigation/route_paths.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class DrawerRight extends StatelessWidget {

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
              'Brightside Feed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.infoCircle),
            title: Text('About'),
            onTap: () {
              Provider.of<AppState>(context, listen: false).currentRoutePath = AboutPath();
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.download),
            title: Text('Android App'),
            onTap: () {
              showOpenUrlDialog(context);
              // Provider.of<AppState>(context, listen: false).currentRoutePath = AboutPath();
              // Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void downloadFile(String url) {
    AnchorElement anchorElement =  new AnchorElement(href: url);
    anchorElement.download = "brightside-feed.apk";
    anchorElement.click();
  }

  Future<void> showOpenUrlDialog(BuildContext context) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Download the Android app?'),
        content: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black, fontSize: 14),
            children: <TextSpan>[
              TextSpan(text: "Starts download of "),
              TextSpan(
                text: "brightside-feed.apk",
                style: TextStyle(color: Colors.black, fontSize: 14, fontStyle: FontStyle.italic),
              ),
              TextSpan(text: " (14MB)"),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              downloadFile("assets/downloads/brightside-feed.apk");
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}