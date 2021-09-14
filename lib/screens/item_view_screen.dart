import 'package:flutter/material.dart';
import 'package:inspired/components/item_list_view.dart';
import 'package:inspired/components/navi_left.dart';
import 'package:inspired/components/preview_data_loader.dart';

class ItemViewScreen extends StatefulWidget {
  final List<ItemData> _initialData;
  static const String id = 'item_view_screen';

  ItemViewScreen({required List<ItemData> initialData}) : _initialData = initialData;

  @override
  _ItemViewScreenState createState() => _ItemViewScreenState(_initialData);
}

class _ItemViewScreenState extends State<ItemViewScreen> {
  ItemListViewModel _itemListViewModel;

  _ItemViewScreenState(List<ItemData> initialData)
      : _itemListViewModel = ItemListViewModel(initialData: initialData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NaviLeft(itemListViewModel: _itemListViewModel),
      body: SafeArea(
        child: ItemListView(itemListViewModel: _itemListViewModel),
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
