import 'package:flutter/material.dart';
import 'package:nexth/navigation/main_route_information_parser.dart';
import 'package:nexth/navigation/main_router_delegate.dart';
import 'package:nexth/utils/constants.dart' as Constants;
import 'theme.dart';

void main() {
  // // Ensure that Firebase is initialized
  // WidgetsFlutterBinding.ensureInitialized();
  // // Initialize Firebase
  // await Firebase.initializeApp();
  runApp(NexthApp());
}

class NexthApp extends StatefulWidget {
  @override
  _NexthAppState createState() => _NexthAppState();
}

class _NexthAppState extends State<NexthApp> {
  final MainRouterDelegate _mainRouterDelegate = MainRouterDelegate();
  final MainRouteInformationParser _mainRouteInformationParser =
      MainRouteInformationParser();

  @override
  void dispose() {
    _mainRouterDelegate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nexth news',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      /*darkTheme: ThemeData.dark(),
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
      ),*/
      routerDelegate: _mainRouterDelegate,
      routeInformationParser: _mainRouteInformationParser,
    );
  }
}
