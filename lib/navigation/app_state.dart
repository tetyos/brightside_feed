import 'package:flutter/material.dart';
import 'package:inspired/components/item_list_view.dart';
import 'package:inspired/navigation/inspired_route_paths.dart';

class AppState extends ChangeNotifier {
  final GlobalKey itemListViewKey = GlobalKey();
  bool _isInitializing = true;
  InspiredRoutePath _routePath = InspiredHomePath();
  ItemListViewModel _itemListViewModel = ItemListViewModel(initialData:[]);

  bool get isInitializing => _isInitializing;

  set isInitializing(bool isInitializing) {
    _isInitializing = isInitializing;
    notifyListeners();
  }

  InspiredRoutePath get routePath => _routePath;

  set routePath(InspiredRoutePath newRoutePath) {
    _routePath = newRoutePath;
    notifyListeners();
  }

  ItemListViewModel get itemListViewModel => _itemListViewModel;

  set itemListViewModel (ItemListViewModel itemListViewModel) {
    _itemListViewModel = itemListViewModel;
    notifyListeners();
  }
}