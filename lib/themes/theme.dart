import 'package:flutter/material.dart';
import './color.dart';

final lightTheme = ThemeData(
  hintColor: HexColor.fromHex("#BBBBBB"),
  primaryColor: Colors.white,
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: HexColor('#293079').withOpacity(.5),
    cursorColor: HexColor('#293079'),
    selectionHandleColor: HexColor('#293079').withOpacity(1),
  ),
  colorScheme: ColorScheme.dark(
    brightness: Brightness.light,
    primary: HexColor.fromHex("#293079"),
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
  textSelectionTheme: TextSelectionThemeData(
    // selectionColor: Color(0xffBA379B).withOpacity(.5),
    cursorColor: Colors.white,
    // selectionHandleColor: Color(0xffBA379B).withOpacity(1),
  ),
  hintColor: Colors.white,
  primaryColor: HexColor.fromHex("#252525"),
  scaffoldBackgroundColor: Colors.black,
  colorScheme: ColorScheme.dark(
    brightness: Brightness.dark,
    primary: HexColor.fromHex("#293079"),
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
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
);
