import 'package:datcao/modules/services/graphql_helper.dart';
import 'package:datcao/modules/services/notification_srv.dart';
import 'package:datcao/share/import.dart';

import 'filter.dart';

class NotificationRepo {
  Future getListNotification({GraphqlFilter filter}) async {
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

  Future sendNotiMessage(List<String> users, String content) async {
    final res = await NotificationSrv().mutate('sendNotiMes', '''
userIds: ${GraphqlHelper.listStringToGraphqlString(users)}
content: "$content"
    ''');
    return res;
  }
}
