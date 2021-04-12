import 'package:flutter/material.dart';

class AppColors {
  static var mainColor = HexColor('#05515e');
  static var backgroundColor = HexColor('#E5E5E5');
  static var backgroundLightColor = HexColor('#E4F4F7');
  static var notifyColor = HexColor('#19CBEF');
  static var buttonApprove = HexColor('#EDF8FA');
  static var buttonCancel = HexColor('#EDF1F2');
  static var greyHint = HexColor('#ABB4B6');
  static var buttonPrimaryColor = HexColor('#006E83');
  static var borderGrayColor = HexColor('#000000');
}

// Parse hex to color.
class HexColor extends Color {
  static int _getColorFromHex(hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(value) : super(_getColorFromHex(value));
}
