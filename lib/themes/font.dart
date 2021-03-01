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
    letterSpacing: 0.5,
    color: HexColor('#05515e'));

TextStyle ptTitle() => TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: HexColor('#05515e'));

TextStyle ptButton() => GoogleFonts.nunito(
    letterSpacing: 0.2, fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white);

TextStyle ptBigBody() =>
    GoogleFonts.nunito(fontSize: 15.5, fontWeight: FontWeight.w400, color: HexColor('#05515e'));

TextStyle ptBody() =>
    GoogleFonts.nunito(fontSize: 13.5, fontWeight: FontWeight.w400, color: HexColor('#05515e'));

TextStyle ptSmall() =>
    GoogleFonts.nunito(fontSize: 12.5, fontWeight: FontWeight.w400, color: HexColor('#05515e'));

TextStyle ptTiny() =>
    GoogleFonts.nunito(fontSize: 11.5, fontWeight: FontWeight.w400, color: HexColor('#05515e'));
