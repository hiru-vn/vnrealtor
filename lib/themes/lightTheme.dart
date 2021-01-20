import 'package:flutter/material.dart';
import './color.dart';
import './font.dart';

final lightTheme = ThemeData(
  primaryColor: HexColor('#52de73'),
  accentColor: HexColor('#f1f8fe'),
  bottomAppBarColor: HexColor('#0E2036'),
  scaffoldBackgroundColor: HexColor('#ffffff'),
  backgroundColor: HexColor('f2f9fc'),
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
    buttonColor: HexColor('#52de73'),
    textTheme: ButtonTextTheme.primary,
  ),
  primaryColorLight: Colors.white,
  iconTheme: IconThemeData(size: 21, color: HexColor('#444444')),
  dividerColor: Colors.black.withOpacity(0.2),
  textTheme: TextTheme(
    bodyText2: ptBody(),
    bodyText1: ptSmall(),
    button: ptButton(),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
