import 'package:flutter/material.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/navigation/inner_route_delegate.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';
import 'package:nexth/screens/add_url_screen.dart';
import 'package:nexth/screens/filter_popular_screen.dart';
import 'package:nexth/utils/constants.dart' as Constants;
import 'package:nexth/utils/constants.dart';
import 'package:nexth/utils/ui_utils.dart';
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
              currentlySelected: appState.currentRoutePath is NexthHomePath,
              onPressed: () {
                appState.currentRoutePath = NexthHomePath();
              }),
          BottomNavItem(
              icon: Icons.dashboard_outlined,
              currentlySelected: appState.currentRoutePath is NexthExplorePath,
              onPressed: () {
                appState.setExplorerScreenCurrentTabAndNotify(appState.explorerScreenStartTab);
                appState.currentRoutePath = NexthExplorePath();
              }),
          BottomNavItem(
              icon: Icons.add_chart,
              currentlySelected: appState.currentRoutePath is NexthIncubatorPath,
              onPressed: () {
                appState.setIncubatorScreenCurrentTabAndNotify(0);
                appState.currentRoutePath = NexthIncubatorPath();
              }),
          BottomNavItem(
              icon: appState.isUserLoggedIn ? Icons.person : Icons.login,
              currentlySelected: false,
              onPressed: () {
                UIUtils.showSnackBar("Can not login in web version.", context);
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
    if (appState.currentRoutePath is NexthExplorePath && appState.explorerScreenCurrentTab == 2) {
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
      UIUtils.showSnackBar("Adding items is currently only supported in app.", context);
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
        heightFactor: MediaQuery.of(context).viewInsets.bottom == 0.0 ? 0.9 : 0.9,
        child: AddUrlScreen(),
      ),
    ).whenComplete(() => setState((){}));
  }

  PreferredSizeWidget? renderAppBarIfNecessary(AppState appState) {
    if (appState.currentSelectedItem != null) {
      return AppBar(title: Text(appState.currentSelectedItem!.title));
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
