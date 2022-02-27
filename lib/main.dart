import 'package:flutter/material.dart';
import 'package:brightside_feed/navigation/main_route_information_parser.dart';
import 'package:brightside_feed/navigation/main_router_delegate.dart';
import 'package:brightside_feed/utils/constants.dart' as Constants;

void main() {
  // // Ensure that Firebase is initialized
  // WidgetsFlutterBinding.ensureInitialized();
  // // Initialize Firebase
  // await Firebase.initializeApp();
  runApp(BrightsideApp());
}

class BrightsideApp extends StatefulWidget {
  @override
  _BrightsideAppState createState() => _BrightsideAppState();
}

class _BrightsideAppState extends State<BrightsideApp> {
  final MainRouterDelegate _mainRouterDelegate = MainRouterDelegate();
  final MainRouteInformationParser _mainRouteInformationParser = MainRouteInformationParser();

  @override
  void dispose() {
    _mainRouterDelegate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'brightside-feed',
      // darkTheme: ThemeData.dark(),
      theme: ThemeData(
        // colorScheme: ColorScheme.light(
        //   primary: Colors.red,
        //   primaryVariant: Colors.red,
        //   secondary: Constants.kColorSecondary,
        //   secondaryVariant: Colors.yellow,
        //   background: Colors.pink,
        //   surface: Colors.purple,
        //   onBackground: Colors.white,
        //   error: Colors.red,
        //   onError: Colors.red,
        //   onPrimary: Colors.green,
        //   onSecondary: Colors.greenAccent,
        //   onSurface: Colors.lightGreen,
        //   brightness: Brightness.light,
        // ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
          primaryColorDark: Constants.kColorPrimaryDark,
        ).copyWith(
          primary: Constants.kColorPrimary,
          primaryVariant: Constants.kColorPrimaryLight,
          secondary: Constants.kColorSecondary,
          secondaryVariant: Constants.kColorSecondaryLight,
          background: Colors.pink,
          surface: Colors.purple,
          onBackground: Colors.white,
          error: Colors.red,
          brightness: Brightness.light,
        ),
        primaryColor: Constants.kColorPrimary,
      ),
      routerDelegate: _mainRouterDelegate,
      routeInformationParser: _mainRouteInformationParser,
    );
  }
}
