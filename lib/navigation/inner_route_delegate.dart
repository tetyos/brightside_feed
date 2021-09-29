import 'package:flutter/material.dart';
import 'package:inspired/screens/explore_screen.dart';
import 'package:inspired/screens/incubator_screen.dart';
import 'package:inspired/screens/recent_screen.dart';
import 'package:inspired/navigation/app_state.dart';
import 'package:inspired/navigation/inspired_route_paths.dart';
import 'package:provider/provider.dart';

class InnerRouterDelegate extends RouterDelegate<InspiredRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<InspiredRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Navigator(
          key: navigatorKey,
          pages: [
            MaterialPage(
              child: RecentScreen(itemListViewModel: appState.itemListViewModel, key: appState.recentScreenKey),
            ),
            if (appState.routePath is InspiredExplorePath)
              MaterialPage(
                key: ValueKey('Explorer'),
                child: Center(
                  child: ExplorerScreen(key: appState.explorerScreenKey),
                ),
              )
            else if (appState.routePath is InspiredIncubatorPath)
              MaterialPage(
                child: Center(
                  key: ValueKey('Incubator'),
                  child: IncubatorScreen(itemListViewModel: appState.itemListViewModel, key: appState.incubatorScreenKey),
                ),
              )
          ],
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }

            appState.routePath = InspiredHomePath();
            notifyListeners();
            return true;
          },
        );
      },
    );
  }

  @override
  Future<void> setNewRoutePath(InspiredRoutePath path) async {
    // This is not required for inner router delegate because it does not
    // parse route
    throw UnimplementedError();
  }
}