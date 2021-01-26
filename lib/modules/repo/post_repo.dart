import 'package:vnrealtor/modules/services/comment_srv.dart';
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

  Future createComment(
      {String postId, String mediaPostId, String content}) async {
    final res = await CommentSrv().add('''
content: "$content"
mediaPostId: "$mediaPostId"
postId: "$postId"
like: 0
    ''', fragment: '''
    id
    userId
    postId
    like
    ''');
    return res;
  }

  Future getAllComment({String postId}) async {
    final res = await CommentSrv().getList(limit: 20);
    return res;
  }
}
