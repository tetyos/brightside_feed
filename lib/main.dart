import 'package:flutter/material.dart';
import 'package:inspired/route_generator.dart';
import 'package:inspired/screens/example_screen.dart';
import 'package:inspired/screens/loading_screen.dart';
import 'package:inspired/utils/constants.dart' as Constants;

void main() {
  // // Ensure that Firebase is initialized
  // WidgetsFlutterBinding.ensureInitialized();
  // // Initialize Firebase
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inspired',
      darkTheme: ThemeData.dark(),
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
      initialRoute: LoadingScreen.id,
      onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
      routes: {
        LoadingScreen.id : (context) => LoadingScreen(),
        ExampleScreen.id: (context) => ExampleScreen(title: 'Flutter Demo Home Page', key: UniqueKey(),),
      },
    );
  }
}


