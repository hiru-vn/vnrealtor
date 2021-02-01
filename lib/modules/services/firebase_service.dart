import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vnrealtor/modules/bloc/notification_bloc.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseService _instance = FirebaseService._();

  static FirebaseService get instance => _instance;
  FirebaseMessaging fb;

  void init() {
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationBloc.instance.getListNotification();
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future<String> getDeviceToken() {
    return FirebaseMessaging.instance.getToken();
  }
}
