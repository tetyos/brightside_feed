import 'package:flutter/material.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';

class AppState extends ChangeNotifier {
  NexthRoutePath _currentRoutePath = LoadingScreen1Path();

  bool _isDataLoading = true;
  bool isUserLoggedIn = false;
  bool _isShowIntro = true;
  String confirmLoginMail = "";

  int explorerScreenCurrentTab = 1;
  int incubatorScreenCurrentTab = 0;
  int numberOfUserDefinedTabs = 0;
  ItemData? currentSelectedItem;

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

  void setExplorerScreenCurrentTabAndNotify(int currentTabExplorerScreen) {
    explorerScreenCurrentTab = currentTabExplorerScreen;
    notifyListeners();
  }

  int get explorerScreenStartTab => numberOfUserDefinedTabs;

  void setIncubatorScreenCurrentTabAndNotify(int incubatorScreenCurrentTab) {
    this.incubatorScreenCurrentTab = incubatorScreenCurrentTab;
    notifyListeners();
  }
}