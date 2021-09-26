import 'package:flutter/material.dart';
import 'package:inspired/screens/item_list_view_model.dart';
import 'package:inspired/navigation/inspired_route_paths.dart';

class AppState extends ChangeNotifier {
  final GlobalKey recentScreenKey = GlobalKey();
  final GlobalKey incubatorScreenKey = GlobalKey();
  final GlobalKey explorerScreenKey = GlobalKey();
  bool _isInitializing = true;
  InspiredRoutePath _routePath = InspiredHomePath();
  ItemListViewModel _itemListViewModel = ItemListViewModel();

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