import 'package:flutter/material.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/model_manager.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';

class AppState extends ChangeNotifier {
  NexthRoutePath _currentRoutePath = LoadingScreen1Path();

  bool _isDataLoading = true;
  bool isShowIntro = false;
  String _resetPasswordMail = "";
  String _confirmLoginMail = "";

  int explorerScreenCurrentTab = 1;
  int incubatorScreenCurrentTab = 0;
  int numberOfUserDefinedTabs = 0;

  ItemData? _currentSelectedItem;
  ItemData? _currentWebViewItem;

  bool isShowCategoryUpdater = false;

  final GlobalKey homeScreenKey = GlobalKey();
  final GlobalKey incubatorScreenKey = GlobalKey();
  final GlobalKey explorerScreenKey = GlobalKey();
  final GlobalKey profileScreenKey = GlobalKey();

  NexthRoutePath get currentRoutePath => _currentRoutePath;

  set currentRoutePath(NexthRoutePath newRoutePath) {
    if (currentSelectedItem != null) {
      currentSelectedItem = null;
    }
    _currentRoutePath = newRoutePath;
    notifyListeners();
  }

  bool get isDataLoading => _isDataLoading;

  set isDataLoading(bool isDataLoading) {
    _isDataLoading = isDataLoading;
    notifyListeners();
  }

  // todo put 'isUserLoggedIn' also into ModelManager?
  bool get isUserLoggedIn {
    return ModelManager.instance.userModel != null;
  }

  String get confirmLoginMail => _confirmLoginMail;

  set confirmLoginMail(String confirmLoginMail) {
    _confirmLoginMail = confirmLoginMail;
    notifyListeners();
  }

  String get resetPasswordMail => _resetPasswordMail;

  set resetPasswordMail(String resetPasswordMail) {
    _resetPasswordMail = resetPasswordMail;
    notifyListeners();
  }

  ///
  /// main-screen stuff
  ///

  void setExplorerScreenCurrentTabAndNotify(int currentTabExplorerScreen) {
    if (explorerScreenCurrentTab != currentTabExplorerScreen) {
      explorerScreenCurrentTab = currentTabExplorerScreen;
      notifyListeners();
    }
  }

  int get explorerScreenStartTab => 1;

  void setIncubatorScreenCurrentTabAndNotify(int incubatorScreenCurrentTab) {
    if (this.incubatorScreenCurrentTab != incubatorScreenCurrentTab) {
      this.incubatorScreenCurrentTab = incubatorScreenCurrentTab;
      notifyListeners();
    }
  }

  ItemData? get currentSelectedItem => _currentSelectedItem;

  set currentSelectedItem(ItemData? selectedItem) {
    _currentSelectedItem = selectedItem;
    notifyListeners();
  }

  ItemData? get currentWebViewItem => _currentWebViewItem;

  set currentWebViewItem(ItemData? webViewItem) {
    _currentWebViewItem = webViewItem;
    notifyListeners();
  }
}