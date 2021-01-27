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
    String data = '''
content: "$content"
postId: "$postId"
like: 0
    ''';
    if (mediaPostId != null) {
      data += '\nmediaPostId: "$mediaPostId"';
    }
    final res = await CommentSrv().add(data, fragment: '''
    id
    userId
    postId
    like
    ''');
    return res;
  }

  Future getAllCommentByPostId({String postId}) async {
    final res = await CommentSrv().getList(limit: 20, filter: "{postId: \"$postId\"}");
    return res;
  }

   Future getAllCommentByMediaPostId({String postMediaId}) async {
    final res = await CommentSrv().getList(limit: 20, filter: "{postId: \"$postMediaId\"}");
    return res;
  }

  Future increaseLikePost({String postId}) async {
    final res = await PostSrv()
        .mutate('increaseLikePost', 'postId: "$postId"', fragment: 'id');
    return res;
  }

  Future decreaseLikePost({String postId}) async {
    final res = await PostSrv()
        .mutate('decreaseLikePost', 'postId: "$postId"', fragment: 'id');
    return res;
  }
  
}
