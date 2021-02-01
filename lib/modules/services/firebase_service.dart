import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vnrealtor/modules/bloc/notification_bloc.dart';
import 'package:vnrealtor/share/function/show_toast.dart';
import 'package:vnrealtor/share/import.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseService _instance = FirebaseService._();

  static FirebaseService get instance => _instance;
  FirebaseMessaging fb;

  void init() async {
    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      showToastNoContext('Bạn có thông báo mới');
      NotificationBloc.instance
          .getListNotification(filter: GraphqlFilter(order: 'createdAt: -1'));

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future<String> getDeviceToken() {
    return FirebaseMessaging.instance.getToken();
  }
}
