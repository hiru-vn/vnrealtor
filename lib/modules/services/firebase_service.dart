import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseService _instance = FirebaseService._();

  static FirebaseService get instance => _instance;

  void init() {
    FirebaseMessaging.instance.requestPermission();
  }

  Future<String> getDeviceToken() {
    return FirebaseMessaging.instance.getToken();
  }
}
