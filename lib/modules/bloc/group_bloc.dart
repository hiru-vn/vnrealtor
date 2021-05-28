import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/model/group.dart';
import 'package:datcao/modules/repo/group_repo.dart';
import 'package:datcao/share/import.dart';

class GroupBloc extends ChangeNotifier {
  GroupBloc._privateConstructor();
  static final GroupBloc instance = GroupBloc._privateConstructor();

  ScrollController groupScrollController = ScrollController();
  List<GroupModel> myGroups;
  List<GroupModel> followingGroups;

  Future init() async {
    getListGroup(
        filter: GraphqlFilter(
            limit: 20,
            order: "{updatedAt: -1}",
            filter: "{ownerId: \"${AuthBloc.instance.userModel.id}\"}"));
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
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      notifyListeners();
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
}
