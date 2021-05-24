import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/inbox/inbox_bloc.dart';
import 'package:datcao/modules/model/notification.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/post/post_detail.dart';
import 'package:datcao/modules/profile/profile_other_page.dart';
import 'package:datcao/modules/repo/notification_repo.dart';
import 'package:datcao/share/import.dart';

enum ACTION_TYPE { OPEN_POST, OPEN_PROFILE, OPEN_CHAT }

class InitAction {
  final ACTION_TYPE type;
  final String modelId;
  final dynamic data;

  InitAction(this.type, this.modelId, {this.data});
}

class NotificationBloc extends ChangeNotifier {
  NotificationBloc._privateConstructor();
  static final NotificationBloc instance =
      NotificationBloc._privateConstructor();

  ScrollController notiScrollController = ScrollController();
  static List<InitAction> initActions = [];
  static Future handleInitActions() async {
    try {
      if (initActions.length > 0) {
        if (initActions[0].type == ACTION_TYPE.OPEN_POST) {
          await PostDetail.navigate(null, postId: initActions[0].modelId);
        }
        if (initActions[0].type == ACTION_TYPE.OPEN_CHAT) {
          final UserModel user = initActions[0].data as UserModel;
          InboxBloc.instance
              .navigateToChatWith(user.name, user.avatar, DateTime.now(), '', [
            AuthBloc.instance.userModel.id,
            user.id,
          ], [
            AuthBloc.instance.userModel.avatar,
            user.avatar,
          ]);
        }
        if (initActions[0].type == ACTION_TYPE.OPEN_PROFILE) {
          ProfileOtherPage.navigate(null, userId: initActions[0].modelId);
        }
      }
    } catch (e) {} finally {
      initActions.removeAt(0);
    }
    return;
  }

  bool isLoadNoti = true;
  List<NotificationModel> notifications = [];

  Future<BaseResponse> getListNotification({GraphqlFilter filter}) async {
    try {
      if (notifications.length == 0) {
        isLoadNoti = true;
      }
      final res = await NotificationRepo().getListNotification(filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => NotificationModel.fromJson(e)).toList();
      notifications = list;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      isLoadNoti = false;
      notifyListeners();
    }
  }

  Future<BaseResponse> sendNotiMessage(
      List<String> users, String content) async {
    try {
      final res = await NotificationRepo().sendNotiMessage(users, content);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> seenNoti(String id) async {
    try {
      final res = await NotificationRepo().seenNoti(id);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }
}
