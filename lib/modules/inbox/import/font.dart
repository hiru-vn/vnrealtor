import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color.dart';

TextStyle ptHeadLine() => TextStyle(
    fontSize: 39,
    fontWeight: FontWeight.w600,
    color: HexColor('#05515e'),
    letterSpacing: 1.5);

TextStyle ptHeadLineSmall() => TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: HexColor('#05515e'),
    letterSpacing: 1.3);

TextStyle ptBigTitle() => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 17,
    letterSpacing: 0.2,
    color: HexColor('#05515e'));

TextStyle ptTitle() => TextStyle(
    fontSize: 14.3, fontWeight: FontWeight.w600, color: HexColor('#05515e'));

TextStyle ptButton() => TextStyle(
    letterSpacing: 0.1,
    fontSize: 15.5,
    fontWeight: FontWeight.w600,
    color: Colors.white);

TextStyle ptBigBody() => TextStyle(
    fontSize: 15.3, fontWeight: FontWeight.w400, color: HexColor('#05515e'));

TextStyle ptBody() => TextStyle(
    fontSize: 13.3, fontWeight: FontWeight.w400, color: HexColor('#05515e'));

TextStyle ptSmall() => TextStyle(
    fontSize: 12.3, fontWeight: FontWeight.w400, color: HexColor('#05515e'));

TextStyle ptTiny() => TextStyle(
    fontSize: 11.5, fontWeight: FontWeight.w400, color: HexColor('#05515e'));
