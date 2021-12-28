import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final Color _lightPrimaryColor = Colors.blueGrey.shade50;
  static final Color _lightPrimaryVariantColor = Colors.blueGrey.shade800;
  static final Color _lightOnPrimaryColor = Colors.blueGrey.shade200;
  static const Color _lightTextColorPrimary = Colors.black;
  static final Color _appbarColorLight = Colors.blue;

  static final Color _darkPrimaryColor = Colors.blueGrey.shade900;
  static final Color _darkPrimaryVariantColor = Colors.blueGrey;
  static final Color _darkOnPrimaryColor = Colors.blueGrey;
  static const Color _darkTextColorPrimary = Colors.white;
  static final Color _appbarColorDark = Colors.blueGrey.shade800;

  static const Color _accentColorDark = Color.fromRGBO(74, 217, 217, 1);

  static const TextStyle _lightHeadingText =
      TextStyle(color: _lightTextColorPrimary, fontFamily: "Rubik");

  static const TextStyle _lightBodyText = TextStyle(
    color: _lightTextColorPrimary,
    fontFamily: "Rubik",
  );

  static const TextTheme _lightTextTheme = TextTheme(
    headline1: _lightHeadingText,
    bodyText1: _lightBodyText,
  );

  static final TextStyle _darkThemeHeadingTextStyle =
      _lightHeadingText.copyWith(color: _darkTextColorPrimary);

  static final TextStyle _darkThemeBodyeTextStyle =
      _lightBodyText.copyWith(color: _darkTextColorPrimary);

  static final TextTheme _darkTextTheme = TextTheme(
    headline1: _darkThemeHeadingTextStyle,
    bodyText1: _darkThemeBodyeTextStyle,
  );

  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
          floatingLabelStyle: const TextStyle(color: Colors.white),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(8)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)));

  static final ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: _lightPrimaryColor,
      appBarTheme: AppBarTheme(
        color: _appbarColorLight,
      ),
    
      inputDecorationTheme: _inputDecorationTheme,
      bottomAppBarColor: _appbarColorLight,
      colorScheme: ColorScheme.light(
          primary: _lightPrimaryColor,
          onPrimary: _lightOnPrimaryColor,
          secondary: _accentColorDark,
          primaryVariant: _lightPrimaryVariantColor),
      textTheme: _lightTextTheme);

  static final ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: _darkPrimaryColor,
      appBarTheme: AppBarTheme(
        color: _appbarColorDark,
      ),
      bottomAppBarColor: _appbarColorDark,
       inputDecorationTheme: _inputDecorationTheme,
      colorScheme: ColorScheme.dark(
        primary: _darkPrimaryColor,
        onPrimary: _darkOnPrimaryColor,
        secondary: _accentColorDark,
        primaryVariant: _darkPrimaryVariantColor,
      ),
      textTheme: _darkTextTheme);
}
