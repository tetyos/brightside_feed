import 'package:flutter/material.dart';
import 'package:nexth/components/navi_left.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/navigation/inner_route_delegate.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';
import 'package:nexth/screens/add_url_screen.dart';
import 'package:nexth/utils/constants.dart' as Constants;
import 'package:nexth/utils/constants.dart';
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
          drawer: NaviLeft(itemListViewModel: appState.itemListViewModel),
          body: SafeArea(
            child: Router(
              routerDelegate: InnerRouterDelegate(),
              backButtonDispatcher: ChildBackButtonDispatcher(backButtonDispatcher)
                ..takePriority(),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: showAddUrlDialog,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: BottomAppBar(
            color: Constants.kColorPrimary,
            shape: CircularNotchedRectangle(),
            notchMargin: 5,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                BottomNavItem(icon: Icons.home_outlined, currentlySelected: appState.currentRoutePath is NexthHomePath, onPressed: () {appState.currentRoutePath = NexthHomePath();}),
                BottomNavItem(
                    icon: Icons.dashboard_outlined,
                    currentlySelected: appState.currentRoutePath is NexthExplorePath,
                    onPressed: () {
                      appState
                          .setExplorerScreenCurrentTabAndNotify(appState.explorerScreenStartTab);
                      appState.currentRoutePath = NexthExplorePath();
                    }),
                BottomNavItem(icon: Icons.rule_outlined, currentlySelected: appState.currentRoutePath is NexthIncubatorPath, onPressed: () {appState.currentRoutePath = NexthIncubatorPath();}),
                BottomNavItem(icon: Icons.person_outline, currentlySelected: false, onPressed: () {}),
                IconButton(icon: Icon(Icons.person, color: Color.fromRGBO(0, 0, 0, 0)), onPressed: () {},),
              ],
            ),
          ),
        );
      },
    );
  }

  void showAddUrlDialog() {
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
    );
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
