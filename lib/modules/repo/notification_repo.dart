import 'package:datcao/modules/services/graphql_helper.dart';
import 'package:datcao/modules/services/notification_srv.dart';
import 'package:datcao/share/import.dart';

import 'filter.dart';

class NotificationRepo {
  Future getMyNotification({GraphqlFilter? filter}) async {
    final id = await SPref.instance.get('id');
    final res = await NotificationSrv().getList(
        limit: filter?.limit,
        offset: filter?.offset,
        search: filter?.search,
        page: filter?.page,
        order: filter?.order,
        filter: '{toUserId: "$id"}');
    return res;
  }

  Future getListNotification({GraphqlFilter? filter}) async {
    final res = await NotificationSrv().getList(
        limit: filter?.limit,
        offset: filter?.offset,
        search: filter?.search,
        page: filter?.page,
        order: filter?.order,
        filter: filter?.filter);
    return res;
  }

  Future sendNotiMessage(List<String> users, String? content) async {
    final res = await NotificationSrv().mutate('sendNotiMes', '''
userIds: ${GraphqlHelper.listStringToGraphqlString(users)}
content: "$content"
    ''');
    return res;
  }

  Future seenNoti(String? id) async {
    final res = await NotificationSrv().mutate(
        'seenNotifification',
        '''
id: "$id"
    ''',
        fragment: 'id');
    return res['id'];
  }
}