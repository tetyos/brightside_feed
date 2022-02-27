import 'package:flutter/material.dart';
import 'package:brightside_feed/screens/about_screen.dart';
import 'package:brightside_feed/screens/explore_screen.dart';
import 'package:brightside_feed/screens/incubator_screen.dart';
import 'package:brightside_feed/screens/home_screen.dart';
import 'package:brightside_feed/navigation/app_state.dart';
import 'package:brightside_feed/navigation/route_paths.dart';
import 'package:brightside_feed/screens/item_detail_screen.dart';
import 'package:provider/provider.dart';

class InnerRouterDelegate extends RouterDelegate<AbstractRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AbstractRoutePath> {
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
            if (appState.currentRoutePath is ExplorePath)
              MaterialPage(
                key: ValueKey('Explorer'),
                child: ExplorerScreen(key: appState.explorerScreenKey),
              ),
            if (appState.currentRoutePath is IncubatorPath)
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
            } else if (appState.currentRoutePath is ExplorePath &&
                appState.explorerScreenCurrentTab != appState.explorerScreenStartTab) {
              appState.setExplorerScreenCurrentTabAndNotify(appState.explorerScreenStartTab);
            } else {
              appState.currentRoutePath = HomePath();
            }
            return true;
          },
        );
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AbstractRoutePath path) async {
    // This is not required for inner router delegate because it does not
    // parse route
    throw UnimplementedError();
  }
}