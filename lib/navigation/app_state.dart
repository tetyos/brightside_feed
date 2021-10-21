import 'package:flutter/material.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';

class AppState extends ChangeNotifier {
  bool _isAppInitializing = true;
  NexthRoutePath _currentRoutePath = NexthHomePath();
  int explorerScreenCurrentTab = 1;
  int numberOfUserDefinedTabs = 0;

  final GlobalKey recentScreenKey = GlobalKey();
  final GlobalKey incubatorScreenKey = GlobalKey();
  final GlobalKey explorerScreenKey = GlobalKey();

  bool get isAppInitializing => _isAppInitializing;

  set isAppInitializing(bool isInitializing) {
    _isAppInitializing = isInitializing;
    notifyListeners();
  }

  NexthRoutePath get currentRoutePath => _currentRoutePath;

  set currentRoutePath(NexthRoutePath newRoutePath) {
    _currentRoutePath = newRoutePath;
    notifyListeners();
  }

  void setExplorerScreenCurrentTabAndNotify (int currentTabExplorerScreen) {
    explorerScreenCurrentTab = currentTabExplorerScreen;
    notifyListeners();
  }

  int get explorerScreenStartTab => numberOfUserDefinedTabs;
}