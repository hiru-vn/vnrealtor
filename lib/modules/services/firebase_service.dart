import 'dart:io';
import 'package:datcao/modules/post/post_detail.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:datcao/modules/bloc/notification_bloc.dart';
import 'package:datcao/share/function/show_toast.dart';
import 'package:datcao/share/import.dart';

enum FcmType { message, like, comment, share, system, new_post }

class FcmService {
  FcmService._();

  static final FcmService _instance = FcmService._();

  static FcmService get instance => _instance;
  FirebaseMessaging fb;

  static FcmType getType(String type) {
    if (type.toLowerCase() == 'Like'.toLowerCase()) return FcmType.like;
    if (type.toLowerCase() == 'MESSENGER'.toLowerCase()) return FcmType.message;
    if (type.toLowerCase() == 'Comment'.toLowerCase()) return FcmType.comment;
    if (type.toLowerCase() == 'Share'.toLowerCase()) return FcmType.share;
    if (type.toLowerCase() == 'System'.toLowerCase()) return FcmType.system;
    if (type.toLowerCase() == 'NEW_POST'.toLowerCase()) return FcmType.new_post;
    return null;
  }

  Future init() async {
    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      final type = getType(message.data['type']);

      if (type == FcmType.message) {
        // final type = ModalRoute.of(navigatorKey.currentState.overlay.context)
        //     .settings
        //     .runtimeType;
        // print(type);
        // if (type == InboxList) return;
        showToastNoContext('Tin nhắn mới');
      }

      if (type == FcmType.share) {
        showToastNoContext('Bạn có 1 lượt chia sẻ mới');
      }

      if (type == FcmType.like) {
        showToastNoContext('${message.notification.body}');
      }

      if (type == FcmType.comment) {
        showToastNoContext('Bạn có comment bài viết mới');
      }

      if (type == FcmType.system) {
        showToastNoContext('${message.notification.body}');
      }

      if (type == FcmType.new_post) {
        showToastNoContext('${message.notification.body}');
      }

      NotificationBloc.instance
          .getListNotification(filter: GraphqlFilter(order: '{createdAt: -1}'));

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future<String> getDeviceToken() {
    return FirebaseMessaging.instance.getToken();
  }
}

class FbdynamicLink {
  static void initDynamicLinks() async {
    // when app in background
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        // PostDetail.navigate(null, postId: deepLink.path);
        print(deepLink.path);
        List<String> paths = deepLink.path.split('/');
        paths.removeWhere((element) => element.trim() == '');
        if (paths.length >= 2 && paths[0] == 'post') {
          Future.delayed(Duration(seconds: 2),
              () => PostDetail.navigate(null, postId: paths[1]));
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    // when app not in background
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      // Navigator.pushNamed(context, deepLink.path);
    }
  }
}
