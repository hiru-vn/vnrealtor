import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/model/friendship.dart';
import 'package:datcao/modules/model/setting.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/pages/blocs/pages_bloc.dart';
import 'package:datcao/modules/repo/user_repo.dart';
import 'package:datcao/share/import.dart';

enum UserRole {
  user,
  agent,
  admin,
  admin_post,
  admin_user,
  mod,
  company,
  manager,
}

class UserBloc extends ChangeNotifier {
  UserBloc._privateConstructor() {
    init();
  }
  static final UserBloc instance = UserBloc._privateConstructor();

  static UserRole getRole(UserModel user) {
    if (user == null) return null;
    if (user.isMod) return UserRole.mod;
    switch (user.role) {
      case 'USER':
        return UserRole.user;
        break;
      case 'COMPANY':
        return UserRole.company;
        break;
      case 'AGENT':
        return UserRole.agent;
        break;
      case 'ADMIN':
        return UserRole.admin;
        break;
      case 'ADMIN_POST':
        return UserRole.admin_post;
        break;
      case 'ADMIN_USER':
        return UserRole.admin_user;
        break;
      case 'MOD':
        return UserRole.mod;
        break;
      case 'MANAGER':
        return UserRole.manager;
        break;

      default:
        return UserRole.user;
    }
  }

  static bool isVerified(UserModel user) {
    if (getRole(user) == UserRole.agent) return true;
    if (getRole(user) == UserRole.company && user.isVerify) return true;
    return false;
  }

  ScrollController profileScrollController = ScrollController();
  List<FriendshipModel> friendRequestFromOtherUsers = [];
  List<UserModel> followersIn7Days = [];
  List<UserModel> suggestFollowUsers = [];

  Future init() async {
    final token = await SPref.instance.get('token');
    final id = await SPref.instance.get('id');
    if (token != null && id != null) {
      // getFriendRequestFromOtherUsers();
      getFollowerIn7d();
      setUserlocation();
      suggestFollow();
      getListFriendIds();
      PagesBloc.instance.init();
    }
  }

  void getListFriendIds() {
    List<String> users = [];
    AuthBloc.instance.userModel.followerIds.forEach((element) {
      if (AuthBloc.instance.userModel.followingIds.contains(element)) {
        users.add(element);
      }
    });
    AuthBloc.instance.userModel.friendIds = users;
  }

  Future<BaseResponse> getFriendRequestFromOtherUsers() async {
    try {
      final res = await UserRepo().friendRequestFromOtherUsers();
      final List listRaw = res;
      final list = listRaw.map((e) => FriendshipModel.fromJson(e)).toList();
      list.removeWhere((element) => element.status != FriendShipStatus.PENDING);
      friendRequestFromOtherUsers = list;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getListUser({GraphqlFilter filter}) async {
    try {
      final res = await UserRepo().getAllUserForClient(filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => UserModel.fromJson(e)).toList();
      list.removeWhere(
          (element) => element.id == AuthBloc.instance.userModel.id);
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> checkValidUser(String email, String phone) async {
    try {
      final res = await UserRepo().checkValidUser(email, phone);

      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> getListUserIn(List<String> ids) async {
    try {
      if (ids.length == 0) return BaseResponse.success(<UserModel>[]);
      final res = await UserRepo().getListUserIn(ids);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => UserModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> updateUser(UserModel user) async {
    try {
      final res = await UserRepo().updateUser(
          user.id,
          user.name,
          user.tagName,
          user.email,
          user.phone,
          user.avatar,
          user.description,
          user.facebookUrl);

      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
      AuthBloc.instance.notifyListeners();
    }
  }

  Future<BaseResponse> seenNotiMess() async {
    try {
      final res = await UserRepo().seenNotiMess(AuthBloc.instance.userModel.id);

      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      AuthBloc.instance.notifyListeners();
    }
  }

  Future<BaseResponse> updateUserStatus({@required bool isOnline}) async {
    try {
      final res = await UserRepo()
          .updateUserStatus(AuthBloc.instance.userModel.id, isOnline: isOnline);

      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {}
  }

  Future<BaseResponse> updateSetting(SettingModel setting) async {
    try {
      final res = await UserRepo().updateSetting(setting.likeNoti,
          setting.commentNoti, setting.shareNoti, setting.postNoti);

      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> seenAllNoti() async {
    try {
      if (AuthBloc.instance.userModel.notiCount == 0)
        return BaseResponse.success('');
      AuthBloc.instance.userModel.notiCount = 0;
      final res = await UserRepo().seenAllNoti();

      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> setUserlocation() async {
    try {
      final pos = await getDevicePosition();
      final id = await SPref.instance.get('id');
      final res =
          await UserRepo().setUserlocation(id, pos.latitude, pos.longitude);

      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future getFollowerIn7d() async {
    try {
      final userId = await SPref.instance.get('id');
      final res = await UserRepo().getFollowerIn7d(userId);
      final List listRaw = res['data'];
      final list =
          listRaw.map((e) => UserModel.fromJson(e['fromUser'])).toList();
      list.removeWhere(
          (element) => element.id == AuthBloc.instance.userModel.id);
      followersIn7Days = list;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getMyFriendShipWith(String userId) async {
    try {
      final res = await UserRepo().getMyFriendShipWith(userId);
      return BaseResponse.success(FriendshipModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> sendFriendInvite(String userId) async {
    try {
      final res = await UserRepo().sendFriendInvite(userId);
      final val = FriendshipModel.fromJson(res);
      return BaseResponse.success(val);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> unfollowUser(String userId) async {
    try {
      final res = await UserRepo().unfollowUser(userId);
      final val = FriendshipModel.fromJson(res);
      return BaseResponse.success(val);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> followUser(String userId) async {
    try {
      notifyListeners();
      final res = await UserRepo().followUser(userId);
      final val = FriendshipModel.fromJson(res);
      return BaseResponse.success(val);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> suggestFollow() async {
    try {
      final res = await UserRepo().suggestFollow();
      final listRaw = res;
      suggestFollowUsers =
          (listRaw.map((e) => UserModel.fromJson(e)).toList() as List)
              .cast<UserModel>();
      return BaseResponse.success(suggestFollowUsers);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> suggestFollowGuest() async {
    try {
      final res = await UserRepo().suggestFollowGuest();
      final listRaw = (res.map((e) => UserModel.fromJson(e)).toList() as List)
          .cast<UserModel>();
      return BaseResponse.success(listRaw);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> acceptFriendInvite(String friendShipId) async {
    try {
      final res = await UserRepo().acceptFriend(friendShipId);
      final val = FriendshipModel.fromJson(res);
      return BaseResponse.success(val);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> declineFriendInvite(String friendShipId) async {
    try {
      final res = await UserRepo().declineFriend(friendShipId);
      final val = FriendshipModel.fromJson(res);
      return BaseResponse.success(val);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> changePassword(
      String oldPassword, String newPassword) async {
    try {
      final res = await UserRepo().changePassword(oldPassword, newPassword);
      final val = UserModel.fromJson(res);
      return BaseResponse.success(val);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> blockUserByAdmin(String id) async {
    try {
      final res = await UserRepo().blockUserByAdmin(id);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> checkChatAble(String id) async {
    try {
      final res = await UserRepo().checkChatAble(id);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }
}
