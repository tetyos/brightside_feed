import 'package:flutter/material.dart';
import 'package:nexth/screens/about_screen.dart';
import 'package:nexth/screens/explore_screen.dart';
import 'package:nexth/screens/incubator_screen.dart';
import 'package:nexth/screens/home_screen.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';
import 'package:nexth/screens/item_detail_screen.dart';
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
              child: HomeScreen(key: appState.homeScreenKey),
            ),
            if (appState.currentRoutePath is NexthExplorePath)
              MaterialPage(
                key: ValueKey('Explorer'),
                child: ExplorerScreen(key: appState.explorerScreenKey),
              ),
            if (appState.currentRoutePath is NexthIncubatorPath)
              MaterialPage(
                child: IncubatorScreen(key: appState.incubatorScreenKey),
              ),
            if (appState.currentRoutePath is AboutPath)
              MaterialPage(
                child: AboutScreen(key: appState.aboutScreenKey),
              ),
            if (appState.currentSelectedItem != null)
              MaterialPage(
                key: ValueKey('ItemDetails'),
                child: ItemDetailScreen(),
              ),
          ],
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }
            if (appState.currentSelectedItem != null) {
              appState.currentSelectedItem = null;
            } else if (appState.currentRoutePath is NexthExplorePath &&
                appState.explorerScreenCurrentTab != appState.explorerScreenStartTab) {
              appState.setExplorerScreenCurrentTabAndNotify(appState.explorerScreenStartTab);
            } else {
              appState.currentRoutePath = NexthHomePath();
            }
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