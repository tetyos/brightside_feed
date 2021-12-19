
import 'package:flutter/material.dart';

class UIUtils {
  static void showSnackBar(String content, BuildContext context, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}