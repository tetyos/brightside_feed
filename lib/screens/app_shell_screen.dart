import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:nexth/model/model_manager.dart';
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
    final RootBackButtonDispatcher backButtonDispatcher =
        Router.of(context).backButtonDispatcher as RootBackButtonDispatcher;

    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          appBar: appState.currentSelectedItem != null
              ? AppBar(
                  title: Text(appState.currentSelectedItem!.title),
                )
              : null,
          body: SafeArea(
            child: Router(
              routerDelegate: InnerRouterDelegate(),
              backButtonDispatcher:
                  ChildBackButtonDispatcher(backButtonDispatcher)
                    ..takePriority(),
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
                appState.setExplorerScreenCurrentTabAndNotify(
                    appState.explorerScreenStartTab);
                appState.currentRoutePath = NexthExplorePath();
              }),
          BottomNavItem(
              icon: Icons.add_chart,
              currentlySelected:
                  appState.currentRoutePath is NexthIncubatorPath,
              onPressed: () {
                appState.setIncubatorScreenCurrentTabAndNotify(0);
                appState.currentRoutePath = NexthIncubatorPath();
              }),
          BottomNavItem(
              icon: Icons.color_lens,
              currentlySelected:
                  appState.currentRoutePath is NexthIncubatorPath,
              onPressed: () {
                appState.setIncubatorScreenCurrentTabAndNotify(0);
                appState.currentRoutePath = NexthAnimationPath();
              }),
          BottomNavItem(
              icon: Icons.logout,
              currentlySelected: false,
              onPressed: () {
                logout(appState);
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
    if (appState.currentRoutePath is NexthExplorePath &&
        appState.explorerScreenCurrentTab == 3) {
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
        heightFactor:
            MediaQuery.of(context).viewInsets.bottom == 0.0 ? 0.4 : 0.7,
        child: FilterPopularScreen(),
      ),
    ).whenComplete(() => setState(() {}));
  }

  void showAddUrlDialog() {
    if (!Provider.of<AppState>(context, listen: false).isUserLoggedIn) {
      UIUtils.showSnackBar(
          "You need to log in, in order to add items.", context);
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
        heightFactor:
            MediaQuery.of(context).viewInsets.bottom == 0.0 ? 0.9 : 0.9,
        child: AddUrlScreen(),
      ),
    ).whenComplete(() => setState(() {}));
  }

  Future<void> logout(AppState appState) async {
    if (!appState.isUserLoggedIn) {
      UIUtils.showSnackBar("Already logged out.", context);
      return;
    }
    try {
      await Amplify.Auth.signOut();
      ModelManager.instance.userModel = null;
      appState.currentRoutePath = LoginScreenPath();
    } on AuthException catch (e) {
      UIUtils.showSnackBar(e.message, context);
    }
  }
}

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final bool currentlySelected;
  final void Function() onPressed;

  const BottomNavItem({
    required this.icon,
    required this.currentlySelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: currentlySelected ? Colors.white : kColorWhiteTransparent,
      ),
      onPressed: onPressed,
    );
  }
}
