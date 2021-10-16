import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Responsive {
  static late double _screenWidth;
  static late double _screenHeight;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static late double heightMultiplier;
  static late double widthMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  static void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight / 100;

    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;
  }
}
