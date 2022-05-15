import 'dart:html';

import 'package:flutter/material.dart';
import 'package:brightside_feed/utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  final TextStyle descriptionTextStyle = const TextStyle(color: Colors.black87, fontSize: 14);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 800),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Welcome to the Brightside-Feed!",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                          constraints: BoxConstraints(maxWidth: 500),
                        child: Text(
                          "Here you will find news on events, tech and other things that help to advance our society into a brighter age.",
                          style: descriptionTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30),
                      Image.asset( 'images/intro4.png'),
                      SizedBox(height: 30),
                      Text("A brighter age?", style: TextStyle(color: Colors.black87, fontSize: 18)),
                      SizedBox(height: 10),
                      Container(
                        constraints: BoxConstraints(maxWidth: 500),
                        child: Text(
                          "The numerous challenges of today make it easy to overlook that we are also living in times that offer enormous possibilities for our future.",
                          style: descriptionTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        constraints: BoxConstraints(maxWidth: 500),
                        child: Text(
                          "Goal of this project is to highlight the progress that our society makes everyday - a progress enabled by millions of people around the globe.",
                          style: descriptionTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 0,
                            maxWidth: 300,
                          ),
                          child: Card(
                            color: kColorSecondary,
                            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                            child: ListTile(
                                leading: FaIcon(FontAwesomeIcons.download, color: Colors.white,),
                                title: Text(
                                  "Download Android App",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  showOpenUrlDialog(context);
                                  // Provider.of<AppState>(context, listen: false).currentRoutePath = AboutPath();
                                  // Navigator.of(context).pop();
                                }
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 0,
                            maxWidth: 300,
                          ),
                          child: Card(
                            color: kColorSecondary,
                            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                            child: ListTile(
                              leading: Icon(
                                Icons.contact_mail,
                                color: Colors.white,
                              ),
                              title: SelectableText(
                                "renfilpe@googlemail.com",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                color: kColorPrimaryLight,
              ),
            ],
          ),
        ),
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