import 'package:vnrealtor/modules/model/notification.dart';
import 'package:vnrealtor/modules/repo/notification.dart';
import 'package:vnrealtor/share/import.dart';

class NotificationBloc extends ChangeNotifier {
  NotificationBloc._privateConstructor();
  static final NotificationBloc instance =
      NotificationBloc._privateConstructor();

  List<NotificationModel> notifications = [];

  Future<BaseResponse> getListNotification({GraphqlFilter filter}) async {
    try {
      final res = await NotificationRepo().getListNotification(filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => NotificationModel.fromJson(e)).toList();
      notifications = list;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e..toString());
    } finally {
      notifyListeners();
    }
  }
}
