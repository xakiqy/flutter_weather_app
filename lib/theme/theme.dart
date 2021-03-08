import 'package:flutter/material.dart';

import 'colors.dart';

final ThemeData weatherTheme = _buildWeatherTheme();

ThemeData _buildWeatherTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: kWeatherYellow900,
    primaryColor: kWeatherPrimaryColor,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: kWeatherPink100,
      colorScheme: base.colorScheme.copyWith(
        secondary: kWeatherYellow900,
      ),
    ),
    backgroundColor: Colors.lightBlue,
    appBarTheme: base.appBarTheme.copyWith(
      color: Colors.lightBlue,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        onPrimary: kWeatherYellow900,
        primary: kWeatherPink50,
        elevation: 8.0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: kWeatherYellow900,
      ),
    ),
    buttonBarTheme: base.buttonBarTheme.copyWith(
      buttonTextTheme: ButtonTextTheme.accent,
    ),
    scaffoldBackgroundColor: kWeatherBackgroundWhite,
    cardColor: kWeatherBackgroundWhite,
    textSelectionTheme:
        TextSelectionThemeData(selectionColor: kWeatherSurfaceWhite),
    errorColor: kWeatherErrorRed,
    textTheme: _buildWeatherTextTheme(base.textTheme),
    primaryTextTheme: _buildWeatherTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildWeatherTextTheme(base.accentTextTheme),
    primaryIconTheme: base.iconTheme.copyWith(color: kWeatherSurfaceWhite),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 0.0,
          color: kWeatherSurfaceWhite,
        ),
      ),
    ),
  );
}

TextTheme _buildWeatherTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline6: base.headline6!.copyWith(fontSize: 18.0),
        caption: base.caption!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
        bodyText1: base.bodyText1!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
        headline5: base.headline5!.copyWith(
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
        ),
        headline4: base.headline4!.copyWith(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        bodyColor: kWeatherPink100,
        displayColor: kWeatherPink100,
      );
}
