import 'package:datcao/modules/repo/filter.dart';
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
}
