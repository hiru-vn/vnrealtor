import 'package:datcao/modules/repo/filter.dart';
import 'package:datcao/modules/services/graphql_helper.dart';
import 'package:datcao/modules/services/group_srv.dart';

class GroupRepo {
  Future getListGroup({GraphqlFilter filter}) async {
    final res = await GroupSrv().getList(
        limit: filter?.limit,
        offset: filter?.offset,
        search: filter?.search,
        page: filter?.page,
        order: filter?.order,
        filter: filter?.filter);
    return res;
  }

  Future getOneGroup(String id) async {
    final res = await GroupSrv().getItem(id);
    return res;
  }

  Future getListGroupIn(List<String> ids) async {
    final res = await GroupSrv().getList(
        order: '{createdAt: 1}',
        filter:
            '{_id: {__in:${GraphqlHelper.listStringToGraphqlString(ids)}}}');
    return res;
  }

  Future suggestGroup() async {
    final res = await GroupSrv().query('suggestGroup', '',
        fragment: ' ${GroupSrv().fragmentDefault} ', removeData: true);
    return res['suggestGroup'];
  }

  Future joinGroup(String id) async {
    final res = await GroupSrv().mutate('joinGroup', 'groupId: "$id"',
        fragment: ' ${GroupSrv().fragmentDefault} ');
    return res['joinGroup'];
  }

  Future sendInviteGroup(String id, List<String> userIds) async {
    final res = await GroupSrv().mutate(
        'sendInviteGroup', 'groupId: "$id", userIds: ${GraphqlHelper.listStringToGraphqlString(userIds)}');
    return res['sendInviteGroup'];
  }

  Future sendInviteGroupAdmin(String id, List<String> userIds) async {
    final res = await GroupSrv().mutate(
        'addAdminForGroup', 'groupId: "$id", memberId: ${GraphqlHelper.listStringToGraphqlString(userIds)}');
    return res['addAdminForGroup'];
  }

  Future kickMem(String id, List<String> userIds) async {
    final res = await GroupSrv().mutate(
        'kickMem', 'groupId: "$id", memberId: ${GraphqlHelper.listStringToGraphqlString(userIds)}');
    return res['kickMem'];
  }

  Future leaveGroup(String id) async {
    final res = await GroupSrv().mutate('leaveGroup', 'groupId: "$id"',
        fragment: ' ${GroupSrv().fragmentDefault} ');
    return res['leaveGroup'];
  }

  Future createGroup(
      String name,
      bool privacy,
      String description,
      String coverImage,
      String address,
      double locationLat,
      double locationLong) async {
    String data = '''
      name: "${name ?? ''}"
    	privacy: $privacy
      description: "${description ?? ''}"
      coverImage: "${coverImage ?? ''}"
      address: "${address ?? ''}"
      locationLat: $locationLat
      locationLong: $locationLong
    ''';
    final res = await GroupSrv().add(data);
    return res;
  }

  Future updateGroup(
      String id,
      String name,
      bool privacy,
      String description,
      String coverImage,
      String address,
      double locationLat,
      double locationLong) async {
    String data = '''
      name: "${name ?? ''}"
    	privacy: "${privacy ?? ''}"
      description: "${description ?? ''}"
      coverImage: "${coverImage ?? ''}"
      address: "${address ?? ''}"
      locationLat: $locationLat
      locationLong: $locationLong
    ''';
    final res = await GroupSrv().update(id: id, data: data);
    return res;
  }

  Future browseMemberSetting(
      String id,
      bool value) async {
    String data = '''
      cencor: $value
    ''';
    final res = await GroupSrv().update(id: id, data: data);
    return res;
  }
}
