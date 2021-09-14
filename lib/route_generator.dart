import 'package:flutter/material.dart';
import 'package:inspired/components/preview_data_loader.dart';
import 'package:inspired/screens/item_view_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case ItemViewScreen.id:
      // Validation of correct data type
        if (args is List<ItemData>) {
          return MaterialPageRoute(builder: (context) {
            return ItemViewScreen(initialData: args);
          });
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Some error occurred. Restart app.'),
        ),
      );
    });
  }
}