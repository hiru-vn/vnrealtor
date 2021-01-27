import 'package:vnrealtor/modules/services/notification_srv.dart';
import 'package:vnrealtor/share/import.dart';

import 'filter.dart';

class NotificationRepo {
  Future getListNotification({GraphqlFilter filter}) async {
    final id = SPref.instance.get('id');
    final res = await NotificationSrv().getList(
        limit: filter.limit,
        offset: filter.offset,
        search: filter.search,
        page: filter.page,
        order: filter.order, filter: '{toUserId: "$id"}');
    return res;
  }

}
