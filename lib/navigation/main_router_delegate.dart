import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nexth/model/model_manager.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';
import 'package:nexth/screens/app_shell_screen.dart';
import 'package:nexth/screens/confirm_screen.dart';
import 'package:nexth/screens/intro_screen2.dart';
import 'package:nexth/screens/loading_screen1.dart';
import 'package:nexth/screens/loading_screen2.dart';
import 'package:nexth/screens/login_screen.dart';
import 'package:nexth/screens/web_view_screen.dart';
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
          if (!(_appState.currentRoutePath is PreMainScreenPath))
            MaterialPage(
              child: AppShellScreen(),
            ),
          if (_appState.currentWebViewItem != null)
            MaterialPage(
              child: WebViewScreen(),
            ),
          if (_appState.currentRoutePath is LoadingScreen2Path)
            MaterialPage(
              child: LoadingScreen2(),
            ),
          if (_appState.currentRoutePath is IntroScreenPath)
            MaterialPage(
              child: IntroScreen2(),
            ),
          if (_appState.currentRoutePath is LoginScreenPath)
            MaterialPage(
              child: LoginScreen(),
            ),
          if (_appState.currentRoutePath is ConfirmScreenPath)
            MaterialPage(
              child: ConfirmScreen(),
            ),
          if (_appState.currentRoutePath is LoadingScreen1Path)
            MaterialPage(
              child: LoadingScreen1(
                onDataLoaded: () async {
                  if (_appState.isUserLoggedIn && !ModelManager.instance.isUserVotesRetrieved) {
                    print("Retrieving user votes");
                    await ModelManager.instance.retrieveUserVotes();
                  }
                  _appState.isDataLoading = false;
                  if (_appState.currentRoutePath is LoadingScreen2Path) {
                    _appState.currentRoutePath = NexthHomePath();
                  }
                },
              ),
            ),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          if (_appState.currentRoutePath is ConfirmScreenPath) {
            _appState.currentRoutePath = LoginScreenPath();
          }
          if (_appState.currentWebViewItem != null) {
            _appState.currentWebViewItem = null;
          }
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