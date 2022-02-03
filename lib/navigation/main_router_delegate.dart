import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexth/bloc/item_list_model_cubit.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';
import 'package:nexth/screens/app_shell_screen.dart';
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
      child: BlocProvider(
        create: (context) => ItemListModelCubit(),
        child: Navigator(
          key: navigatorKey,
          pages: getPages(),
          onPopPage: popPage,
        ),
      ),
    );
  }

  List<Page<dynamic>> getPages() {
    return [
      MaterialPage(
        child: AppShellScreen(),
      ),
      if (_appState.currentWebViewItem != null)
        MaterialPage(
          child: WebViewScreen(),
        ),
    ];
  }

  bool popPage(route, result) {
    if (!route.didPop(result)) {
      return false;
    }
    if (_appState.confirmLoginMail.isNotEmpty) {
      _appState.confirmLoginMail = "";
    }
    if (_appState.resetPasswordMail.isNotEmpty) {
      _appState.resetPasswordMail = "";
    }
    if (_appState.currentWebViewItem != null) {
      _appState.currentWebViewItem = null;
    }
    return true;
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
