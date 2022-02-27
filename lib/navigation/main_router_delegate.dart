import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brightside_feed/bloc/item_list_model_cubit.dart';
import 'package:brightside_feed/navigation/app_state.dart';
import 'package:brightside_feed/navigation/route_paths.dart';
import 'package:brightside_feed/screens/app_shell_screen.dart';
import 'package:provider/provider.dart';

class MainRouterDelegate extends RouterDelegate<AbstractRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AbstractRoutePath> {
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
  AbstractRoutePath get currentConfiguration {
    return _appState.currentRoutePath;
  }

  @override
  Future<void> setNewRoutePath(AbstractRoutePath path) {
    _appState.currentRoutePath = path;
    return SynchronousFuture<void>(null);
  }
}
