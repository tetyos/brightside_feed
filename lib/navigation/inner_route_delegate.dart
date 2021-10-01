import 'package:flutter/material.dart';
import 'package:nexth/screens/explore_screen.dart';
import 'package:nexth/screens/incubator_screen.dart';
import 'package:nexth/screens/home_screen.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';
import 'package:provider/provider.dart';

class InnerRouterDelegate extends RouterDelegate<NexthRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NexthRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Navigator(
          key: navigatorKey,
          pages: [
            MaterialPage(
              child: HomeScreen(itemListViewModel: appState.itemListViewModel, key: appState.recentScreenKey),
            ),
            if (appState.routePath is NexthExplorePath)
              MaterialPage(
                key: ValueKey('Explorer'),
                child: Center(
                  child: ExplorerScreen(key: appState.explorerScreenKey),
                ),
              )
            else if (appState.routePath is NexthIncubatorPath)
              MaterialPage(
                child: Center(
                  key: ValueKey('Incubator'),
                  child: IncubatorScreen(key: appState.incubatorScreenKey),
                ),
              )
          ],
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }

            appState.routePath = NexthHomePath();
            notifyListeners();
            return true;
          },
        );
      },
    );
  }

  @override
  Future<void> setNewRoutePath(NexthRoutePath path) async {
    // This is not required for inner router delegate because it does not
    // parse route
    throw UnimplementedError();
  }
}