import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brightside_feed/bloc/item_list_model_cubit.dart';
import 'package:brightside_feed/navigation/app_state.dart';
import 'package:brightside_feed/navigation/nexth_route_paths.dart';
import 'package:brightside_feed/screens/app_shell_screen.dart';
import 'package:brightside_feed/screens/pre_main_screen/confirm_screen.dart';
import 'package:brightside_feed/screens/pre_main_screen/intro_screen2.dart';
import 'package:brightside_feed/screens/pre_main_screen/loading_screen1.dart';
import 'package:brightside_feed/screens/pre_main_screen/loading_screen2.dart';
import 'package:brightside_feed/screens/pre_main_screen/login_screen.dart';
import 'package:brightside_feed/screens/pre_main_screen/reset_password_screen.dart';
import 'package:brightside_feed/screens/web_view_screen.dart';
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
      if (!(_appState.currentRoutePath is PreMainScreenPath))
        MaterialPage(
          child: AppShellScreen(),
        ),
      if (_appState.currentWebViewItem != null)
        MaterialPage(
          child: WebViewScreen(),
        ),
      if (_appState.currentRoutePath is LoadingScreen2Path) MaterialPage(child: LoadingScreen2()),
      if (_appState.currentRoutePath is IntroScreenPath) MaterialPage(child: IntroScreen2()),
      if (_appState.currentRoutePath is LoginScreenPath) MaterialPage(child: LoginScreen()),
      if (_appState.currentRoutePath is LoginScreenPath && _appState.confirmLoginMail.isNotEmpty)
        MaterialPage(child: ConfirmScreen()),
      if (_appState.currentRoutePath is LoginScreenPath && _appState.resetPasswordMail.isNotEmpty)
        MaterialPage(child: ResetPasswordScreen()),
      if (_appState.currentRoutePath is LoadingScreen1Path) MaterialPage(child: LoadingScreen1()),
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
