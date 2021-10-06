import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';
import 'package:nexth/screens/app_shell_screen.dart';
import 'package:nexth/screens/loading_screen.dart';
import 'package:provider/provider.dart';

class MainRouterDelegate extends RouterDelegate<NexthRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NexthRoutePath> {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final AppState _appState = AppState();


  MainRouterDelegate() {
    _appState.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _appState.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (BuildContext context) => _appState,
      child: Navigator(
        key: navigatorKey,
        pages: [
            MaterialPage(
              child: _appState.isAppInitializing ? LoadingScreen() : AppShellScreen(),
            )
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          notifyListeners();
          return true;
        },
      ),
    );
  }

  @override
  NexthRoutePath get currentConfiguration {
    return _appState.currentRoutePath;
  }

  @override
  Future<void> setNewRoutePath(NexthRoutePath path) {
    _appState.currentRoutePath = path;
    return SynchronousFuture<void>(null);
  }

}