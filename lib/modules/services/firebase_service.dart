import 'dart:io';
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
  static init() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://abc123.app.goo.gl',
      link: Uri.parse('https://example.com/'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.android',
        minimumVersion: 125,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.example.ios',
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'example-promo',
        medium: 'social',
        source: 'orkut',
      ),
      itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
        providerToken: '123456',
        campaignToken: 'example-promo',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Example of a Dynamic Link',
        description: 'This link works whether app is installed or not!',
      ),
    );

    final Uri dynamicUrl = await parameters.buildUrl();
  }

  static void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;

        if (deepLink != null) {
          // Navigator.pushNamed(context, deepLink.path);
        }
      },
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      }
    );
    
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      // Navigator.pushNamed(context, deepLink.path);
    }
  }
}
