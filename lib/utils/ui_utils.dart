
import 'package:flutter/material.dart';

class UIUtils {
  static void showSnackBar(String content, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        // backgroundColor: Colors.teal[800],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}