import 'package:vnrealtor/modules/services/post_srv.dart';

import 'filter.dart';

class PostRepo {
  Future getListPost({GraphqlFilter filter}) async {
    final res = await PostSrv().getList(
        limit: filter.limit,
        offset: filter.offset,
        search: filter.search,
        page: filter.page,
        order: filter.order);
    return res;
  }
}
