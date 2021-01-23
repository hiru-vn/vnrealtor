import 'dart:io';

import 'package:device_info/device_info.dart';

class DeviceInfo {
  static final DeviceInfo instance = DeviceInfo._internal();
  DeviceInfo._internal();

  DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<String> getDeviceId() async {
    if (Platform.isIOS) {
      var iosDeviceInfo = await _deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await _deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}
