import 'package:flutter/material.dart';
import './color.dart';

final lightTheme = ThemeData(
  hintColor: HexColor.fromHex("#BBBBBB"),
  primaryColor: Colors.white,
  cursorColor: HexColor('#293079'),
  brightness: Brightness.light,
  backgroundColor: HexColor.fromHex("#E5E5E5"),
  accentColor: Colors.black,
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
  ),
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.black12,
);

final dartTheme = ThemeData(
  cursorColor: Colors.white,
  hintColor: Colors.white,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: Colors.black,
  accentColor: Colors.white,
  appBarTheme: AppBarTheme(
    brightness: Brightness.light,
  ),
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.grey,
);
