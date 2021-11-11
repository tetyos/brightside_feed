import 'package:flutter/material.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';

class AppState extends ChangeNotifier {
  bool _isDataLoading = true;
  bool _isShowIntro = true;
  NexthRoutePath _currentRoutePath = LoadingScreen1Path();
  int explorerScreenCurrentTab = 1;
  int numberOfUserDefinedTabs = 0;
  String confirmLoginMail = "";
  bool isUserLoggedIn = false;

  final GlobalKey recentScreenKey = GlobalKey();
  final GlobalKey incubatorScreenKey = GlobalKey();
  final GlobalKey explorerScreenKey = GlobalKey();

  bool get isShowIntro => _isShowIntro;

  set isShowIntro(bool isShowIntro) {
    _isShowIntro = isShowIntro;
    notifyListeners();
  }

  bool get isDataLoading => _isDataLoading;

  set isDataLoading(bool isDataLoading) {
    _isDataLoading = isDataLoading;
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