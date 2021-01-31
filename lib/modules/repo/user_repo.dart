import 'package:vnrealtor/modules/services/friendship_srv.dart';
import 'package:vnrealtor/modules/services/user_srv.dart';
import 'package:vnrealtor/utils/spref.dart';

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

  Future getMyFriendShipWith(String userId) async {
    final res = await UserSrv()
        .query('getMyFriendShipWith', 'userId: "$userId"', fragment: '''
id
user1Id
user2Id
status
        ''');
    return res['getMyFriendShipWith'];
  }

  Future friendRequestFromOtherUsers() async {
    final uid = await SPref.instance.get('id');
    final res = await FriendshipSrv().getList(filter: '{user2Id: "$uid"}');
    return res['data'];
  }

  Future sendFriendInvite(String userId) async {
    final res = await UserSrv()
        .mutate('sendFriendInvite', 'user2Id: "$userId"', fragment: '''
id
user1Id
user2Id
status
        ''');
    return res['sendFriendInvite'];
  }

  Future acceptFriend(String friendShipId) async {
    final res = await UserSrv()
        .mutate('acceptFriend', 'friendShipId: "$friendShipId"', fragment: '''
id
user1Id
user2Id
status
        ''');
    return res['acceptFriend'];
  }

  Future declineFriend(String friendShipId) async {
    final res = await UserSrv()
        .mutate('declineFriend', 'friendShipId: "$friendShipId"', fragment: '''
id
user1Id
user2Id
status
        ''');
    return res['friendShipId'];
  }

  Future changePassword(String oldPassword, String newPassword) async {
    final res = await UserSrv().mutate('changePassword',
        'oldPassword: "$oldPassword"\nnewPassword: "$newPassword"',
        fragment: 'id');
    return res['changePassword'];
  }
}
