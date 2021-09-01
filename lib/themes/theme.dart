import 'package:flutter/material.dart';
import './color.dart';

final lightTheme = ThemeData(
  hintColor: HexColor.fromHex("#BBBBBB"),
  primaryColor: Colors.white,
  cursorColor: HexColor('#293079'),
  colorScheme: ColorScheme.dark(
    brightness: Brightness.light,
    onPrimary: Colors.red,
  ),
  primaryIconTheme: IconThemeData(
    color: HexColor('#444444'),
  ),
  backgroundColor: HexColor.fromHex("#E5E5E5"),
  accentColor: Colors.black,
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: HexColor.fromHex("#BBBBBB")),
    fillColor: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
  ),
  iconTheme: IconThemeData(
    color: HexColor.fromHex("#293079"),
  ),
  dividerColor: Colors.black12,
);

final dartTheme = ThemeData(
  cursorColor: Colors.white,
  hintColor: Colors.white,
  primaryColor: Colors.black,
  colorScheme: ColorScheme.dark(
    brightness: Brightness.dark,
    onPrimary: Colors.red,
  ),
  backgroundColor: Colors.black,
  accentColor: Colors.white,
  appBarTheme: AppBarTheme(
    brightness: Brightness.light,
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(
      color: Colors.white,
    ),
    fillColor: Colors.white,
  ),
  dividerColor: Colors.grey,
  iconTheme: IconThemeData(color: Colors.white),
  accentIconTheme: IconThemeData(
    color: Colors.red,
  ),
);
