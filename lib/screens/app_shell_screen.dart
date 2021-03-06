import 'package:flutter/material.dart';
import 'package:brightside_feed/navigation/app_state.dart';
import 'package:brightside_feed/navigation/inner_route_delegate.dart';
import 'package:brightside_feed/navigation/route_paths.dart';
import 'package:brightside_feed/screens/add_url_screen.dart';
import 'package:brightside_feed/screens/filter_popular_screen.dart';
import 'package:brightside_feed/utils/constants.dart' as Constants;
import 'package:brightside_feed/utils/constants.dart';
import 'package:brightside_feed/utils/ui_utils.dart';
import 'package:provider/provider.dart';

class AppShellScreen extends StatefulWidget {
  static const String id = 'item_view_screen';

  @override
  _AppShellScreenState createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen> {

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        ChildBackButtonDispatcher? childBackButtonDispatcher;
        if (appState.isAppShellVisible()) {
          final RootBackButtonDispatcher backButtonDispatcher =
              Router.of(context).backButtonDispatcher as RootBackButtonDispatcher;
          childBackButtonDispatcher = ChildBackButtonDispatcher(backButtonDispatcher)..takePriority();
        }

        return Scaffold(
          appBar: renderAppBarIfNecessary(appState),
          body: SafeArea(
            child: Router(
              routerDelegate: InnerRouterDelegate(),
              backButtonDispatcher: childBackButtonDispatcher,
            ),
          ),
          floatingActionButton: renderFAB(appState),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: renderBottomAppBar(appState),
        );
      },
    );
  }

  Widget renderBottomAppBar(AppState appState) {
    return BottomAppBar(
      color: Constants.kColorPrimary,
      shape: CircularNotchedRectangle(),
      notchMargin: 5,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          BottomNavItem(
              icon: Icons.home_outlined,
              currentlySelected: appState.currentRoutePath is HomePath,
              onPressed: () {
                appState.currentRoutePath = HomePath();
              }),
          BottomNavItem(
              icon: Icons.dashboard_outlined,
              currentlySelected: appState.currentRoutePath is ExplorePath,
              onPressed: () {
                appState.setExplorerScreenCurrentTabAndNotify(appState.explorerScreenStartTab);
                appState.currentRoutePath = ExplorePath();
              }),
          BottomNavItem(
              icon: Icons.add_chart,
              currentlySelected: appState.currentRoutePath is IncubatorPath,
              onPressed: () {
                appState.setIncubatorScreenCurrentTabAndNotify(0);
                appState.currentRoutePath = IncubatorPath();
              }),
          BottomNavItem(
              icon: appState.isUserLoggedIn ? Icons.person : Icons.login,
              currentlySelected: false,
              onPressed: () {
                if (appState.isUserLoggedIn) {
                  appState.currentRoutePath = ProfilePath();
                } else {
                  appState.currentRoutePath = LoginScreenPath();
                }
              }),
          IconButton(
            icon: Icon(Icons.person, color: Color.fromRGBO(0, 0, 0, 0)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  FloatingActionButton renderFAB(AppState appState) {
    if (appState.currentRoutePath is ExplorePath && appState.explorerScreenCurrentTab == 2) {
      return FloatingActionButton(
        onPressed: showFilterDialog,
        tooltip: 'Change filter',
        child: Icon(Icons.filter_alt),
      );
    }
    return FloatingActionButton(
          onPressed: showAddUrlDialog,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        );
  }

  void showFilterDialog() {
    // we need to fetch root backButtonDispatcher and give priority back to it.
    // otherwise inner-backButtonDispatcher has priority
    RootBackButtonDispatcher backButtonDispatcher =
    Router.of(context).backButtonDispatcher as RootBackButtonDispatcher;
    backButtonDispatcher.takePriority();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: MediaQuery.of(context).viewInsets.bottom == 0.0 ? 0.4 : 0.7,
        child: FilterPopularScreen(),
      ),
    ).whenComplete(() => setState((){}));
  }

  void showAddUrlDialog() {
    if (!Provider.of<AppState>(context, listen: false).isUserLoggedIn) {
      UIUtils.showSnackBar("You need to log in, in order to add items.", context);
      return;
    }

    // we need to fetch root backButtonDispatcher and give priority back to it.
    // otherwise inner-backButtonDispatcher has priority
    RootBackButtonDispatcher backButtonDispatcher =
    Router.of(context).backButtonDispatcher as RootBackButtonDispatcher;
    backButtonDispatcher.takePriority();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: MediaQuery.of(context).viewInsets.bottom == 0.0 ? 0.8 : 0.8,
        child: AddUrlScreen(),
      ),
    ).whenComplete(() => setState((){}));
  }

  PreferredSizeWidget? renderAppBarIfNecessary(AppState appState) {
    if (appState.currentSelectedItem != null) {
      return AppBar(title: Text(appState.currentSelectedItem!.title));
    }
    if (appState.currentRoutePath is ProfilePath) {
      return AppBar(title: Text("Profile"));
    }
    return null;
  }
}

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final bool currentlySelected;
  final void Function() onPressed;

  const BottomNavItem({required this.icon, required this.currentlySelected, required this.onPressed,});

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(icon, color: currentlySelected ? Colors.white : kColorWhiteTransparent,), onPressed: onPressed,);
  }
}
