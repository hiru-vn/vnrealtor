import 'package:flutter/material.dart';

import 'color.dart';

TextStyle ptHeadLine() =>
    TextStyle(fontSize: 39, fontWeight: FontWeight.w600, letterSpacing: 1.5);

TextStyle ptHeadLineSmall() =>
    TextStyle(fontSize: 26, fontWeight: FontWeight.w600, letterSpacing: 1.3);

TextStyle ptBigTitle() => TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 17,
      letterSpacing: 0.2,
    );

TextStyle ptTitle() => TextStyle(
      fontSize: 14.3,
      fontWeight: FontWeight.w600,
    );

TextStyle ptButton() => TextStyle(
    letterSpacing: 0.1,
    fontSize: 15.5,
    fontWeight: FontWeight.w600,
    color: Colors.white);

TextStyle ptBigBody() => TextStyle(
      fontSize: 15.3,
      fontWeight: FontWeight.w400,
    );

TextStyle ptBody() => TextStyle(
      fontSize: 13.3,
      fontWeight: FontWeight.w400,
    );

TextStyle ptSmall() => TextStyle(
      fontSize: 12.3,
      fontWeight: FontWeight.w400,
    );

TextStyle ptTiny() => TextStyle(
      fontSize: 11.5,
      fontWeight: FontWeight.w400,
    );
