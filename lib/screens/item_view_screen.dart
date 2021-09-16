import 'package:flutter/material.dart';
import 'package:inspired/components/item_list_view.dart';
import 'package:inspired/components/navi_left.dart';
import 'package:inspired/utils/preview_data_loader.dart';
import 'package:inspired/screens/add_url_screen.dart';
import 'package:inspired/utils/constants.dart' as Constants;

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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        color: Constants.kColorPrimary,
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(icon: Icon(Icons.home, size: 24, color: Colors.white,), onPressed: () {},),
            IconButton(icon: Icon(Icons.travel_explore, color: Colors.white,), onPressed: () {},),
            IconButton(icon: Icon(Icons.post_add, color: Colors.white,), onPressed: () {},),
            IconButton(icon: Icon(Icons.person, color: Colors.white,), onPressed: () {},),
            IconButton(icon: Icon(Icons.person, color: Color.fromRGBO(0, 0, 0, 0)), onPressed: () {},),
          ],
        ),
      ),
    );
  }

  void _doSomething() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: MediaQuery.of(context).viewInsets.bottom == 0.0 ? 0.3 : 0.7,
        child: AddUrlScreen(),
      ),
    );
  }
}
