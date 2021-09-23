import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inspired/navigation/app_state.dart';
import 'package:inspired/navigation/inspired_route_paths.dart';
import 'package:inspired/screens/app_shell_screen.dart';
import 'package:inspired/screens/loading_screen.dart';
import 'package:provider/provider.dart';

class MainRouterDelegate extends RouterDelegate<InspiredRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<InspiredRoutePath> {

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
              child: _appState.isInitializing ? LoadingScreen() : AppShellScreen(),
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
  InspiredRoutePath get currentConfiguration {
    return _appState.routePath;
  }

  @override
  Future<void> setNewRoutePath(InspiredRoutePath path) {
    _appState.routePath = path;
    return SynchronousFuture<void>(null);
  }

}