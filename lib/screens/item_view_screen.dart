import 'package:flutter/material.dart';
import 'package:inspired/components/item_list_view.dart';
import 'package:inspired/components/navi_left.dart';
import 'package:inspired/components/preview_data_loader.dart';

class ItemViewScreen extends StatelessWidget {
  final List<LinkPreviewData> _initialData;
  static const String id = 'item_view_screen';

  ItemViewScreen({required List<LinkPreviewData> initialData}) : _initialData = initialData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NaviLeft(),
      body: SafeArea(
        child: ItemListView(initialData: _initialData),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _doSomething,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
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
