import 'package:flutter/material.dart';
import 'package:inspired/components/item_any_link.dart';
import 'package:inspired/components/item_card.dart';
import 'package:inspired/components/item_card_2.dart';
import 'package:inspired/components/item_flutter_link_preview.dart';

class ItemViewScreen extends StatelessWidget {
  static const String id = 'item_view_screen';

  static const String spotify_url = 'https://open.spotify.com/track/7abZZqdxmt369pf6VSHiy7?si=y2NdAmC_QW6MrhjVtgAjrA&utm_source=whatsapp';
  static const String twitter_url = 'https://twitter.com/elonmusk/status/1381273076709478403';
  static const String youtube_url = 'https://www.youtube.com/watch?v=bfvyJ40HW60';
  static const String spiegel_url =
      'https://www.spiegel.de/politik/ausland/recep-tayyip-erdogan-tuerkei-nimmt-zehn-pensionierte-admirale-nach-kritik-am-kanal-istanbul-fest-a-166bdd33-6227-4fe9-92aa-94e12626d9be';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Item viewer"),
      ),
      body: SafeArea(
        child: ListView(
          reverse: false,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          children: [
            // ItemCard2(url: spiegel_url),
            ItemCard2(url: youtube_url),
            ItemCard2(url: youtube_url),
            ItemCard2(url: youtube_url),
            ItemCard2(url: spotify_url),
            ItemCard2(url: twitter_url),
            // ItemCard2(url: 'https://pub.dev/'),
            ItemAnyLink(url: twitter_url),
            ItemAnyLink(url: spotify_url),
            // ItemAnyLink(url: spiegel_url),
            ItemAnyLink(url: youtube_url),
            // ItemAnyLink(url: 'https://pub.dev/'),
            ItemFlutterLinkPreview(url: twitter_url),
            ItemFlutterLinkPreview(url: spotify_url),
            // ItemFlutterLinkPreview(url: spiegel_url),
            ItemFlutterLinkPreview(url: youtube_url),
            // ItemFlutterLinkPreview(url: 'https://pub.dev/'),
            // ItemCard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _doSomething,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _doSomething() {
    // setState(() {
    //   // This call to setState tells the Flutter framework that something has
    //   // changed in this State, which causes it to rerun the build method below
    //   // so that the display can reflect the updated values. If we changed
    //   // _counter without calling setState(), then the build method would not be
    //   // called again, and so nothing would appear to happen.
    //   _counter++;
    // });
  }
}
