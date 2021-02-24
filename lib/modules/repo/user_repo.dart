import 'package:datcao/modules/services/friendship_srv.dart';
import 'package:datcao/modules/services/user_srv.dart';
import 'package:datcao/utils/spref.dart';

import 'filter.dart';

class UserRepo {
  String userFragment =
      ' id uid name email phone totalPost role reputationScore friendIds createdAt updatedAt followerIds followingIds avatar';

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
        fragment: 'token user { $userFragment }');
    return res['registerWithPhone'];
  }

  Future getListFollower({String userId, String limit, String page}) async {
    final res = await UserSrv().mutate(
        'getListFollower',
        '''
userId: "$userId"
limit: "$limit"
Page: "$page"
    ''',
        fragment: 'data { $userFragment }');
    return res['getListFollower'];
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
        fragment: 'token user { $userFragment }');
    return res['loginUser'];
  }

  Future getOneUser({String id}) async {
    final res = await UserSrv().getItem(id);
    return res;
  }

  Future getListUser({GraphqlFilter filter}) async {
    final res = await UserSrv().getList(
        limit: filter?.limit,
        offset: filter?.offset,
        search: filter?.search,
        page: filter?.page,
        order: filter?.order);
    return res;
  }

  Future resetPassWithPhone({String password, String idToken}) async {
    final res = await UserSrv().mutate(
        'resetPassword',
        '''
newPassword: "$password"
idToken: "$idToken"
    ''',
        fragment: '$userFragment');
    return res['resetPassword'];
  }

  Future updateUser(String id, String name, String email, String phone, String avatar) async {
    final res = await UserSrv().update(
        id: id,
        data: '''
name: "$name"
email: "$email"
phone: "$phone",
avatar: "$avatar",
    ''',
        fragment: 'id');
    return res['id'];
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
    return res['declineFriend'];
  }

  Future followUser(String userId) async {
    final res =
        await UserSrv().mutate('followUser', 'userId: "$userId"', fragment: '''
id
        ''');
    return res['followUser'];
  }

  Future unfollowUser(String userId) async {
    final res = await UserSrv()
        .mutate('unfollowUser', 'userId: "$userId"', fragment: '''
id
        ''');
    return res['unfollowUser'];
  }

  Future changePassword(String oldPassword, String newPassword) async {
    final res = await UserSrv().mutate('changePassword',
        'oldPassword: "$oldPassword"\nnewPassword: "$newPassword"',
        fragment: 'id');
    return res['changePassword'];
  }

  Future getFollowerIn7d(String userId) async {
    final res = await UserSrv().query('getFollowerIn7d', 'userId: "$userId"',
        fragment: 'data { $userFragment }');
    return res['getFollowerIn7d'];
  }
}
