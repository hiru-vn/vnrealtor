import 'package:datcao/modules/services/comment_srv.dart';
import 'package:datcao/modules/services/graphql_helper.dart';
import 'package:datcao/modules/services/post_srv.dart';
import 'package:datcao/modules/services/report_srv.dart';

import 'filter.dart';

class PostRepo {
  Future getNewFeed(
      {GraphqlFilter filter, String timestamp, String timeSort}) async {
    if (filter?.filter == null) filter?.filter = "{}";
    if (filter?.search == null) filter?.search = "";
    final data =
        'q:{limit: ${filter?.limit}, page: ${filter?.page ?? 1}, offset: ${filter?.offset}, filter: ${filter?.filter}, search: "${filter?.search}" , order: ${filter?.order} , timeSort: $timeSort, timestamp: "$timestamp" }';
    final res = await PostSrv().query('getNewsFeed', data, fragment: '''
    data {
$postFragment
}
    ''');
    return res['getNewsFeed'];
  }

  Future getNewFeedGuest(
      {GraphqlFilter filter, String timestamp, String timeSort}) async {
    final res = await PostSrv().query('getNewsFeedByGuest', '', fragment: '''
    data {
${postFragment.replaceFirst('isUserLike', '').replaceFirst('isUserShare', '')}
}
    ''');
    return res['getNewsFeedByGuest'];
  }

  Future getStoryFollowing({int page}) async {
    final res = await PostSrv().query('getStoryFollowing', '', fragment: '''
    data {
id: _id
${postFragment.replaceFirst('id', '')}
}
    ''');
    return res['getStoryFollowing'];
  }

  Future searchPostByHashTag(String hashTags) async {
    final res = await PostSrv()
        .query('searchPostByHashTag', 'hashTags: "$hashTags"', fragment: '''
    data {
$postFragment
}
    ''');
    return res['searchPostByHashTag'];
  }

  Future getPostList(List<String> ids) async {
    final res = await PostSrv().getList(
        // limit: 20,
        order: '{createdAt: 1}',
        filter:
            '{_id: {__in:${GraphqlHelper.listStringToGraphqlString(ids)}}}');
    return res;
  }

  Future getOnePost(String id) async {
    final res = await PostSrv().getItem(id);
    return res;
  }

  Future getPostByUserId(String userId) async {
    final res = await PostSrv().getList(
        limit: 20, order: '{createdAt: -1}', filter: '{userId: "$userId"}');
    return res;
  }

  Future createComment(
      {String postId, String mediaPostId, String content}) async {
    String data = '''
content: """
$content
"""
like: 0
    ''';
    if (mediaPostId != null) {
      data += '\nmediaPostId: "$mediaPostId"';
    } else {
      data += '\npostId: "$postId"';
    }
    final res = await CommentSrv().add(data, fragment: '''
    id
    userId
    postId
    mediaPostId
    like
    content
    ''');
    return res;
  }

  Future createPost(String content, String expirationDate, bool publicity,
      double lat, double long, List<String> images, List<String> videos) async {
    String data = '''
content: """
${content.toString()}
"""
publicity: $publicity
videos: ${GraphqlHelper.listStringToGraphqlString(videos)}
images: ${GraphqlHelper.listStringToGraphqlString(images)}
    ''';

    if (expirationDate != null) {
      data += '\nexpirationDate: "$expirationDate"';
    }
    if (lat != null && long != null) {
      data += '\nlocationLat: $lat\nlocationLong: $long';
    }
    final res =
        await PostSrv().mutate('createPost', 'data: {$data}', fragment: '''
$postFragment
    ''');
    return res["createPost"];
  }

  Future deletePost(String postId) async {
    final res = await PostSrv().delete(postId);
    return res;
  }

  Future deleteComment(String commentId) async {
    final res = await CommentSrv().delete(commentId);
    return res;
  }

  Future updatePost(
      String id,
      String content,
      String expirationDate,
      bool publicity,
      double lat,
      double long,
      List<String> images,
      List<String> videos) async {
    String data = '''
content: """
${content.toString()}
"""
publicity: $publicity
videos: ${GraphqlHelper.listStringToGraphqlString(videos)}
images: ${GraphqlHelper.listStringToGraphqlString(images)}
    ''';

    if (expirationDate != null) {
      data += '\nexpirationDate: "$expirationDate"';
    }
    if (lat != null && long != null) {
      data += '\nlocationLat: $lat\nlocationLong: $long';
    }
    final res = await PostSrv()
        .mutate('updatePost', 'id: "$id"  data: {$data}', fragment: '''
$postFragment
    ''');
    return res["updatePost"];
  }

  Future savePost(String postId) async {
    final res =
        await PostSrv().mutate('savePost', 'postId: "$postId"', fragment: '''
        id
        ''');
    return res['savePost'];
  }

  Future getAllCommentByPostId({String postId, GraphqlFilter filter}) async {
    final res = await CommentSrv().getList(
        limit: filter?.limit,
        offset: filter?.offset,
        search: filter?.search,
        page: filter?.page,
        order: filter?.order,
        filter: "{postId: \"$postId\"}");
    return res;
  }

  Future getAllCommentByPostIdGuest(
      {String postId, GraphqlFilter filter}) async {
    final res = await CommentSrv().getList(
        limit: filter?.limit,
        offset: filter?.offset,
        search: filter?.search,
        page: filter?.page,
        order: filter?.order,
        filter: "{postId: \"$postId\"}");
    return res;
  }

  Future getAllCommentByMediaPostId(
      {String postMediaId, GraphqlFilter filter}) async {
    final res = await CommentSrv().getList(
        limit: filter?.limit,
        offset: filter?.offset,
        search: filter?.search,
        page: filter?.page,
        order: filter?.order,
        filter: "{mediaPostId: \"$postMediaId\"}");
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

  Future increaseLikeMediaPost({String postMediaId}) async {
    final res = await PostSrv().mutate(
        'increaseMediaLikePost', 'mediaPostId: "$postMediaId"',
        fragment: 'id');
    return res;
  }

  Future decreaseLikeMediaPost({String postMediaId}) async {
    final res = await PostSrv().mutate(
        'decreaseMediLikePost', 'mediaPostId: "$postMediaId"',
        fragment: 'id');
    return res;
  }

  Future increaseLikeCmt({String cmtId}) async {
    final res = await PostSrv()
        .mutate('increaseLikeCmt', 'cmtId: "$cmtId"', fragment: 'id');
    return res;
  }

  Future decreaseLikeCmt({String cmtId}) async {
    final res = await PostSrv()
        .mutate('decreaseLikeCmt', 'cmtId: "$cmtId"', fragment: 'id');
    return res;
  }

  Future createReport({String type, String content, String postId}) async {
    final res = await ReportSrv().add(
        'postId: "$postId"  type: "$type"  content: "$content"',
        fragment: 'id');
    return res;
  }

  String postFragment = '''
id
content
mediaPostIds
commentIds
userId
like
userLikeIds
share
userShareIds
locationLat
locationLong
province
district
ward
hashTag
expirationDate
publicity
rawContent
user {
  id 
  uid 
  name 
  email 
  phone 
  role 
  reputationScore 
  createdAt 
  updatedAt 
  avatar
  totalPost
  friendIds
  facebookUrl
  description
  isVerify
}
mediaPosts {
id
userId
type
like
userLikeIds
commentIds
description
url
locationLat
locationLong
expirationDate
publicity
createdAt
updatedAt
}
isUserLike
isUserShare
createdAt
updatedAt
  ''';
}
