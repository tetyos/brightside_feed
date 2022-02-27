import 'dart:html';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:brightside_feed/navigation/nexth_route_paths.dart';
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
              downloadFile("assets/downloads/brightside-feed.apk");
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
}