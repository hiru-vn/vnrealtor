import 'package:datcao/modules/model/notification.dart';
import 'package:datcao/modules/post/post_detail.dart';
import 'package:datcao/modules/repo/notification_repo.dart';
import 'package:datcao/share/import.dart';

enum ACTION_TYPE { OPEN_POST, OPEN_PROFILE, OPEN_CHAT }

class InitAction {
  final ACTION_TYPE type;
  final String modelId;

  InitAction(this.type, this.modelId);
}

class NotificationBloc extends ChangeNotifier {
  NotificationBloc._privateConstructor();
  static final NotificationBloc instance =
      NotificationBloc._privateConstructor();

  ScrollController notiScrollController = ScrollController();
  static List<InitAction> initActions = [];
  static Future handleInitActions() async {
    if (initActions.length > 0) {
      if (initActions[0].type == ACTION_TYPE.OPEN_POST) {
        await PostDetail.navigate(null, postId: initActions[0].modelId);
      }
      if (initActions[0].type == ACTION_TYPE.OPEN_CHAT) {
        // await InboxBloc.instance.navigateToChatWith(null, postId: initActions[0].modelId);
      }

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
