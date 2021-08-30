import 'package:flutter/material.dart';
import './color.dart';
import './font.dart';

final lightTheme = ThemeData(
  bottomAppBarColor: HexColor('#ffffff'),
  scaffoldBackgroundColor: HexColor('#ffffff'),
  cardTheme: CardTheme(
    color: HexColor('#FEFEFE'),
    shadowColor: HexColor('#FEFEFE'),
  ),
  primaryIconTheme: IconThemeData(
    color: HexColor('#444444'),
  ),
  colorScheme: ColorScheme.light(
    primary: HexColor('#52de73'),
    onPrimary: Colors.white,
    surface: Colors.pink,
    onSurface: Colors.black87,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: HexColor('#05515e'),
    textTheme: ButtonTextTheme.primary,
  ),
  primaryColorLight: Colors.white,
  iconTheme: IconThemeData(size: 21, color: HexColor('#05515e')),
  textTheme: TextTheme(
    bodyText2: ptBody(),
    bodyText1: ptSmall(),
    button: ptButton(),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  brightness: Brightness.light,
  backgroundColor: HexColor.fromHex("#E5E5E5"),
  accentColor: Colors.white,
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.black12,
);

final dartTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: Colors.black,
  accentColor: Colors.white,
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.black12,
);
