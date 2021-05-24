import 'dart:io';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/inbox/inbox_bloc.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/post/post_detail.dart';
import 'package:datcao/modules/profile/profile_other_page.dart';
import 'package:datcao/modules/services/src/toast/toast.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:datcao/modules/bloc/notification_bloc.dart';
import 'package:datcao/share/function/show_toast.dart';
import 'package:datcao/share/import.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

enum FcmType {
  message,
  like,
  comment,
  share,
  system,
  new_post,
  tag_post,
  tag_comment,
  tag_reply
}

class FcmService {
  FcmService._();

  static final FcmService _instance = FcmService._();

  static FcmService get instance => _instance;
  FirebaseMessaging fb;
  final _audioCache = AudioCache(
      prefix: "assets/sound/",
      fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));

  static FcmType getType(String type) {
    if (type.toLowerCase() == 'Like'.toLowerCase()) return FcmType.like;
    if (type.toLowerCase() == 'MESSENGER'.toLowerCase()) return FcmType.message;
    if (type.toLowerCase() == 'Comment'.toLowerCase()) return FcmType.comment;
    if (type.toLowerCase() == 'Share'.toLowerCase()) return FcmType.share;
    if (type.toLowerCase() == 'System'.toLowerCase()) return FcmType.system;
    if (type.toLowerCase() == 'NEW_POST'.toLowerCase()) return FcmType.new_post;
    if (type.toLowerCase() == 'TAG_COMMENT'.toLowerCase())
      return FcmType.tag_comment;
    if (type.toLowerCase() == 'TAG_REPLY'.toLowerCase())
      return FcmType.tag_reply;
    if (type.toLowerCase() == 'TAG_POST'.toLowerCase()) return FcmType.tag_post;
    return null;
  }

  void handleMessageLive(RemoteMessage message) {
    print('Message data: ${message.data}');
    final type = getType(message.data['type']);

    if (type == FcmType.message) {
      if (InboxBloc.inChat) return;

      _audioCache.play('facebook_message.mp3');
      toast('Tin nhắn mới', onTap: () async {
        showWaitingDialog(navigatorKey.currentState.context);
        await InboxBloc.instance.navigateToChatWith(
            message.data['name'], message.data['avatar'], DateTime.now(), '', [
          AuthBloc.instance.userModel.id,
          message.data['userId'],
        ], [
          AuthBloc.instance.userModel.avatar,
          message.data['avatar'],
        ]);
        navigatorKey.currentState.maybePop();
      });
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
  }

  void handleMessageBackground(RemoteMessage message) {
    print('Message data: ${message.data}');
    final type = getType(message.data['type']);

    if (type == FcmType.message) {}

    if ([
      FcmType.new_post,
      FcmType.like,
      FcmType.share,
      FcmType.comment,
      FcmType.tag_comment,
      FcmType.tag_post,
      FcmType.tag_reply
    ].contains(type)) {
      PostDetail.navigate(null, postId: message.data['modelId']);
    }

    if (type == FcmType.system) {}

    NotificationBloc.instance
        .getListNotification(filter: GraphqlFilter(order: '{createdAt: -1}'));

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  }

  Future init() async {
    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleMessageLive(message);
    }, onError: (e) async {
      print(e?.message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessageBackground(message);
    }, onError: (e) async {
      print(e?.message);
    });

    // when app terminated
    final RemoteMessage message =
        await FirebaseMessaging.instance.getInitialMessage();

    // when app is terminated
    if (message != null) {
      final type = getType(message.data['type']);
      if ([
        FcmType.new_post,
        FcmType.like,
        FcmType.share,
        FcmType.comment,
        FcmType.tag_comment,
        FcmType.tag_post,
        FcmType.tag_reply
      ].contains(type)) {
        NotificationBloc.initActions.insert(
            0, InitAction(ACTION_TYPE.OPEN_POST, message.data['modelId']));
      }
      if (type == FcmType.message) {
        NotificationBloc.initActions.insert(
            0, InitAction(ACTION_TYPE.OPEN_CHAT, message.data['userId'], data: UserModel(
              id: message.data['userId'],
              phone: message.data['phone'],
              name: message.data['name'],
              avatar: message.data['avatar']
            )));
      }
    }
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
          final token = await SPref.instance.get('token');
          if (token == null) {
            print('case 1');
            Future.delayed(Duration(milliseconds: 1000),
                () => PostDetail.navigate(null, postId: paths[1]));
          } else {
            if (AuthBloc.instance.userModel != null &&
                FirebaseAuth.instance.currentUser != null) {
              print('case 2');

              PostDetail.navigate(null, postId: paths[1]);
            } else {
              print('case 3');
              Future.delayed(Duration(milliseconds: 1000),
                  () => PostDetail.navigate(null, postId: paths[1]));
            }
          }
        }
        if (paths.length >= 2 && paths[0] == 'user') {
          final token = await SPref.instance.get('token');
          if (token == null) {
            print('case 1');
            Future.delayed(Duration(milliseconds: 1000),
                () => ProfileOtherPage.navigate(null, userId: paths[1]));
          } else {
            if (AuthBloc.instance.userModel != null &&
                FirebaseAuth.instance.currentUser != null) {
              print('case 2');

              ProfileOtherPage.navigate(null, userId: paths[1]);
            } else {
              print('case 3');
              Future.delayed(Duration(milliseconds: 1000),
                  () => ProfileOtherPage.navigate(null, userId: paths[1]));
            }
          }
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
      print(deepLink.path);
      List<String> paths = deepLink.path.split('/');
      paths.removeWhere((element) => element.trim() == '');
      if (paths.length >= 2 && paths[0] == 'post') {
        final token = await SPref.instance.get('token');
        if (token == null) {
          NotificationBloc.initActions
              .insert(0, InitAction(ACTION_TYPE.OPEN_POST, paths[1]));
        } else {
          NotificationBloc.initActions
              .insert(0, InitAction(ACTION_TYPE.OPEN_POST, paths[1]));
        }
      }
      if (paths.length >= 2 && paths[0] == 'user') {
        final token = await SPref.instance.get('token');
        if (token == null) {
          NotificationBloc.initActions
              .insert(0, InitAction(ACTION_TYPE.OPEN_PROFILE, paths[1]));
        } else {
          NotificationBloc.initActions
              .insert(0, InitAction(ACTION_TYPE.OPEN_PROFILE, paths[1]));
        }
      }
    }
  }
}
