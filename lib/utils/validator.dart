// Basic regular expressions for validating strings
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final emailPattern =
    r'^[a-zA-Z0-9](([.]{1}|[_]{1})?[a-zA-Z0-9])*[@]([a-z0-9]+([.]{1}|-)?)*[a-zA-Z0-9]+[.]{1}[a-z]{2,253}$';
final phonePattern = r'^[+]{0,1}[0-9]{5,13}$';

final urlPattern =
    r'/(http|https|ftp|ftps)\:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?/';

final formalPattern = r'^[A-Za-z0-9_.]+$';

bool isMatchedPattern(String pattern, dynamic input) {
  if (!RegExp(pattern).hasMatch(input)) {
    return false;
  }

  return true;
}

class Validator {
  static bool isEmpty(String input) {
    if (input == null || input.trim().isEmpty) {
      return true;
    }

    return false;
  }

  static bool isEmail(String email) {
    if (email.isEmpty ||
        email.length < 6 ||
        !isMatchedPattern(emailPattern, email)) {
      return false;
    }

    return true;
  }

  static bool isUrl(String url) {
    if (!isMatchedPattern(urlPattern, url)) {
      return false;
    }

    return true;
  }

  static bool isPassword(String password) {
    if (password.isEmpty || password.length < 6) {
      return false;
    }

    return true;
  }

  static bool isPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty || !isMatchedPattern(phonePattern, phoneNumber)) {
      return false;
    }

    return true;
  }

  static bool isIdNo(String idNo) {
    if (idNo.isEmpty || idNo.length < 12) {
      return false;
    }

    return true;
  }

  static bool isPhone(String phone) {
    final regexPhone = RegExp(r'^[0-9]{10}$');
    return regexPhone.hasMatch(phone);
  }

  static bool isPin(String pin) {
    final regexPin = RegExp(r'^[0-9]{6}$');
    return regexPin.hasMatch(pin);
  }
}

class TextFieldValidator {
  static String notEmptyValidator(String string) {
    if (string?.trim()?.isEmpty ?? false) return 'Vui lòng điền thông tin';
    return null;
  }

  static String numberValidator(String string) {
    if (double.tryParse(string.replaceAll(',', '')) == null)
      return 'Số không hợp lệ';
    return null;
  }

  static String emailValidator(String string) {
    if (!Validator.isEmail(string)) return 'Email không hợp lệ';
    return null;
  }

  static String formalValidator(String string) {
    if (string.trim() == '') return null;
    if (!RegExp(formalPattern).hasMatch(string)) return """dấu _ , a-z , 0-9""";
    return null;
  }

  static String phoneValidator(String string) {
    if (!Validator.isPhone(string)) return 'Số điện thoại không hợp lệ';
    return null;
  }

  static String passValidator(String string) {
    if (string.length < 6) return 'Cần bằng hoặc nhiều hơn 6 kí tự';
    return null;
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = ','; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1)
          newString = separator + newString;
        newString = chars[i] + newString;
      }

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}
