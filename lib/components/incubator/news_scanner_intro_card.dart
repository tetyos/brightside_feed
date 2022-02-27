import 'package:flutter/material.dart';
import 'package:brightside_feed/utils/constants.dart';

class NewsScannerIntroCard extends StatelessWidget {

  const NewsScannerIntroCard();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 5),
            child: Column(
              children: [
                Text(
                  "News scanner",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
                TextButton(
                  onPressed: () => showWebsites(context),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(text: "Here you find all recent news from a selected number of websites ("),
                        TextSpan(
                          text: "show list",
                          style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ")."),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          color: kColorPrimaryLight,
        ),
      ),
    );
  }

  Future<void> showWebsites(BuildContext context) async {
    showDialog<String>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Currently scanned:',textAlign: TextAlign.center),
        content: Text(
          'pv-magazine.com\n'
          'reneweconomy.com.au\n'
          'futurefarming.com\n'
          'treehugger.com\n'
          'inhabitat.com\n'
          'sustainablebrands.com\n'
          'positive.news\n'
          'goodnewsnetwork.com\n'
          'euronews.com/green',
          style: TextStyle(color: Colors.black87, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}