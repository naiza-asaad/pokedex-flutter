import 'package:flutter/material.dart';

class PokedexTheme {
  static const Color primaryColorWhite = Colors.white;

  static const Color textColorWhite = Colors.white;
  static const Color textColorBlack = Colors.black;
  static const Color textColorBlueGrey = Colors.blueGrey;
  static const Color unselectedColor = Colors.grey;
  static const Color indicatorColor = Colors.transparent;

  static ThemeData themeRegular = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColorWhite,
    unselectedWidgetColor: unselectedColor,
    indicatorColor: indicatorColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: TextTheme(
      headline1: TextStyle(
        color: textColorWhite,
        fontWeight: FontWeight.bold,
        fontSize: 32.0,
      ),
      headline2: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
      ),
      headline3: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
      headline4: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
      ),
      bodyText1: TextStyle(
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        fontSize: 18.0,
        color: textColorWhite,
      ),
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0.0,
    ),
  );
}
