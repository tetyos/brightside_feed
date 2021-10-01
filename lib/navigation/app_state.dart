import 'package:flutter/material.dart';
import 'package:nexth/model/item_list_view_model.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';

class AppState extends ChangeNotifier {
  final GlobalKey recentScreenKey = GlobalKey();
  final GlobalKey incubatorScreenKey = GlobalKey();
  final GlobalKey explorerScreenKey = GlobalKey();
  bool _isInitializing = true;
  NexthRoutePath _routePath = NexthHomePath();
  ItemListViewModel _itemListViewModel = ItemListViewModel();

  bool get isInitializing => _isInitializing;

  set isInitializing(bool isInitializing) {
    _isInitializing = isInitializing;
    notifyListeners();
  }

  NexthRoutePath get routePath => _routePath;

  set routePath(NexthRoutePath newRoutePath) {
    _routePath = newRoutePath;
    notifyListeners();
  }

  ItemListViewModel get itemListViewModel => _itemListViewModel;

  set itemListViewModel (ItemListViewModel itemListViewModel) {
    _itemListViewModel = itemListViewModel;
    notifyListeners();
  }
}