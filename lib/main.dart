import 'package:flutter/material.dart';
import 'package:inspired/route_generator.dart';
import 'package:inspired/screens/example_screen.dart';
import 'package:inspired/screens/loading_screen.dart';

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
      theme: ThemeData(
        primaryColor: Colors.teal[800],
        primarySwatch: Colors.teal
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


