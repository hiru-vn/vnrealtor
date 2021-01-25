import 'package:vnrealtor/modules/services/user_srv.dart';

import 'filter.dart';

class UserRepo {
  Future registerWithPhone(
      {String name,
      String email,
      String password,
      String phone,
      String idToken}) async {
    final res = await UserSrv().mutate(
        'registerWithPhone',
        '''
name: "$name"
email: "$email"
password: "$password"
phone: "$phone"
idToken: "$idToken"
    ''',
        fragment:
            'token user { id uid name email phone role reputationScore friendIds createdAt updatedAt}');
    return res['registerWithPhone'];
  }

  Future login(
      {String userName,
      String password,
      String deviceId,
      String deviceToken}) async {
    final res = await UserSrv().mutate(
        'loginUser',
        '''
    username: "$userName"
    password: "$password"
  	deviceId: "$deviceToken"
    deviceToken: "$deviceToken"
    ''',
        fragment:
            'token user { id uid name email phone role reputationScore friendIds createdAt updatedAt}');
    return res['loginUser'];
  }

  Future getOneUser({String id}) async {
    final res = await UserSrv().getItem(id);
    return res;
  }

  Future getListUser({GraphqlFilter filter}) async {
    final res = await UserSrv().getList(
        limit: filter.limit,
        offset: filter.offset,
        search: filter.search,
        page: filter.page,
        order: filter.order);
    return res;
  }
}
