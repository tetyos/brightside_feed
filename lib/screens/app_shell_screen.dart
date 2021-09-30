import 'package:flutter/material.dart';
import 'package:nexth/components/navi_left.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/navigation/inner_route_delegate.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';
import 'package:nexth/screens/add_url_screen.dart';
import 'package:nexth/utils/constants.dart' as Constants;
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
          drawer: NaviLeft(itemListViewModel: Provider.of<AppState>(context).itemListViewModel),
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
                IconButton(icon: Icon(Icons.home, size: 24, color: Colors.white,), onPressed: () {appState.routePath = NexthHomePath();},),
                IconButton(icon: Icon(Icons.category, color: Colors.white,), onPressed: () {appState.routePath = NexthExplorePath();},),
                IconButton(icon: Icon(Icons.post_add, color: Colors.white,), onPressed: () {appState.routePath = NexthIncubatorPath();},),
                IconButton(icon: Icon(Icons.person, color: Colors.white,), onPressed: () {},),
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
