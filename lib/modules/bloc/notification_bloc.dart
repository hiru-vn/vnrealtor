import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/model/notification.dart';
import 'package:datcao/modules/repo/notification_repo.dart';
import 'package:datcao/share/import.dart';

class NotificationBloc extends ChangeNotifier {
  NotificationBloc._privateConstructor();
  static final NotificationBloc instance =
      NotificationBloc._privateConstructor();

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
      return BaseResponse.fail(e.toString());
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
      return BaseResponse.fail(e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> seenNoti(String id) async {
    try {
      final res = await NotificationRepo().seenNoti(id);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.toString());
    } finally {
      // notifyListeners();
    }
  }
}
