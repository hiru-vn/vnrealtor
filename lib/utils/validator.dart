// Basic regular expressions for validating strings
final emailPattern =
    r'^[a-zA-Z0-9](([.]{1}|[_]{1})?[a-zA-Z0-9])*[@]([a-z0-9]+([.]{1}|-)?)*[a-zA-Z0-9]+[.]{1}[a-z]{2,253}$';
final phonePattern = r'^[+]{0,1}[0-9]{5,13}$';

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
    if (email.isEmpty || email.length < 6 || !isMatchedPattern(emailPattern, email)) {
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
