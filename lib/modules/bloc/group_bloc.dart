import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/model/group.dart';
import 'package:datcao/modules/model/notification.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/repo/group_repo.dart';
import 'package:datcao/modules/repo/notification_repo.dart';
import 'package:datcao/modules/repo/post_repo.dart';
import 'package:datcao/share/import.dart';

class GroupBloc extends ChangeNotifier {
  GroupBloc._privateConstructor();
  static final GroupBloc instance = GroupBloc._privateConstructor();

  ScrollController groupScrollController = ScrollController();
  List<GroupModel> myGroups;
  List<GroupModel> followingGroups;

  bool isReloadFeed = true;
  bool isLoadMoreFeed = true;
  bool isLoadStory = true;
  bool isEndFeed = false;
  DateTime lastFetchFeedPage1;
  int feedPage = 1;
  List<PostModel> feed = [];
  List<GroupModel> suggestGroup;
  List<NotificationModel> invites;

  Future init() async {
    getNewFeedGroup(filter: GraphqlFilter(limit: 10, order: "{updatedAt: -1}"));
    getSuggestGroup();
    getMyGroup();
  }

  Future getMyGroup() async {
    await Future.wait([
      getListGroup(
              filter: GraphqlFilter(
                  limit: 20,
                  order: "{updatedAt: -1}",
                  filter: "{ownerId: \"${AuthBloc.instance.userModel.id}\"}"))
          .then((res) {
        if (res.isSuccess) {
          myGroups = res.data;
        }
      }),
      getListGroupIn(AuthBloc.instance.userModel.groupIds).then((res) {
        if (res.isSuccess) {
          followingGroups = (res.data as List<GroupModel>)
              .where((element) => !element.isOwner)
              .toList();
        }
      })
    ]);
    notifyListeners();
  }

  Future<BaseResponse> getListGroup({GraphqlFilter filter}) async {
    try {
      final res = await GroupRepo().getListGroup(filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => GroupModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getSuggestGroup() async {
    try {
      final res = await GroupRepo().suggestGroup();
      final List listRaw = res;
      suggestGroup = listRaw.map((e) => GroupModel.fromJson(e)).toList();
      return BaseResponse.success(suggestGroup);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getListGroupIn(List<String> ids) async {
    try {
      final res = await GroupRepo().getListGroupIn(ids);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => GroupModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getOneGroup(String id) async {
    try {
      final res = await GroupRepo().getOneGroup(id);
      final group = GroupModel.fromJson(res);
      return BaseResponse.success(group);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getNewFeedGroup({GraphqlFilter filter}) async {
    try {
      isEndFeed = false;
      isReloadFeed = true;
      notifyListeners();
      final res = await PostRepo().getNewsFeedGroup(filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      if (list.length < filter.limit) isEndFeed = true;
      feed = list;
      lastFetchFeedPage1 = DateTime.now();
      feedPage = 1;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      isReloadFeed = false;
      notifyListeners();
    }
  }

  Future<BaseResponse> loadMoreNewFeedGroup() async {
    try {
      if (isEndFeed) return BaseResponse.success(<PostModel>[]);
      isLoadMoreFeed = true;
      notifyListeners();
      final res = await PostRepo().getNewsFeedGroup(
          filter: GraphqlFilter(
              limit: 10, order: "{updatedAt: -1}", page: ++feedPage),
          timeSort: '-1',
          timestamp: lastFetchFeedPage1.toString());
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      if (list.length < 15) isEndFeed = true;
      feed.addAll(list);
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e?.message ?? e.toString());
    } finally {
      isLoadMoreFeed = false;
      notifyListeners();
    }
  }

  Future<BaseResponse> getPostGroup(String groupId) async {
    try {
      final res = await PostRepo().getPostByGroupId(groupId);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e?.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> joinGroup(String groupId) async {
    try {
      final res = await GroupRepo().joinGroup(groupId);
      final group = GroupModel.fromJson(res);
      if (!followingGroups.any((element) => element.id == groupId)) {
        followingGroups.add(group);
        AuthBloc.instance.userModel.groupIds.add(group.id);
        getSuggestGroup();
      }
      return BaseResponse.success(group);
    } catch (e) {
      return BaseResponse.fail(e?.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> leaveGroup(String groupId) async {
    try {
      final res = await GroupRepo().leaveGroup(groupId);
      final group = GroupModel.fromJson(res);
      if (followingGroups.any((element) => element.id == groupId)) {
        followingGroups.remove(group);
        AuthBloc.instance.userModel.groupIds.remove(group.id);
        getSuggestGroup();
      }
      return BaseResponse.success(group);
    } catch (e) {
      return BaseResponse.fail(e?.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> sendInviteGroup(String id, List<String> userIds) async {
    try {
      final res = await GroupRepo().sendInviteGroup(id, userIds);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e?.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> sendInviteGroupAdmin(
      String id, List<String> userIds) async {
    try {
      final res = await GroupRepo().sendInviteGroupAdmin(id, userIds);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e?.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> kickMem(String id, List<String> userIds) async {
    try {
      final res = await GroupRepo().kickMem(id, userIds);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e?.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> adminAcceptMem(String id, List<String> userIds) async {
    try {
      final res = await GroupRepo().adminAcceptMem(id, userIds);
      return BaseResponse.success(GroupModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e?.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> createGroup(
      String name,
      bool privacy,
      String description,
      String coverImage,
      String address,
      double locationLat,
      double locationLong) async {
    try {
      final res = await GroupRepo().createGroup(name, privacy, description,
          coverImage, address, locationLat, locationLong);
      myGroups.add(GroupModel.fromJson(res));
      return BaseResponse.success(GroupModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> createPost(
      String groupId,
      String content,
      String expirationDate,
      bool publicity,
      double lat,
      double long,
      List<String> images,
      List<String> videos,
      List<LatLng> polygon,
      List<String> tagUserIds,
      String type,
      String need,
      double area,
      bool onlyMe,
      double price) async {
    try {
      final res = await PostRepo().createPost(
          content,
          expirationDate,
          publicity,
          lat,
          long,
          images,
          videos,
          polygon,
          tagUserIds,
          type,
          need,
          area,
          price,
          onlyMe,
          groupId: groupId);
      feed.insert(0, PostModel.fromJson(res));
      return BaseResponse.success(PostModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      // wait to reload post
      Future.delayed(Duration(seconds: 1), () => notifyListeners());
    }
  }

  Future<BaseResponse> updateGroup(
      String id,
      String name,
      bool privacy,
      String description,
      String coverImage,
      String address,
      double locationLat,
      double locationLong) async {
    try {
      final res = await GroupRepo().updateGroup(id, name, privacy, description,
          coverImage, address, locationLat, locationLong);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> browseMemberSetting(String id, bool enable) async {
    try {
      final res = await GroupRepo().browseMemberSetting(id, enable);
      return BaseResponse.success(GroupModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getListInviteGroupNotification() async {
    try {
      final res = await NotificationRepo().getListNotification(
          filter: GraphqlFilter(
              limit: 10,
              filter:
                  '{tag: "INVITE_GROUP", toUserId: "${AuthBloc.instance.userModel.id}"}'));
      final List listRaw = res['data'];
      invites = listRaw.map((e) => NotificationModel.fromJson(e)).toList();
      return BaseResponse.success(invites);
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      notifyListeners();
    }
  }
}
