import 'package:datcao/modules/services/comment_srv.dart';
import 'package:datcao/modules/services/graphql_helper.dart';
import 'package:datcao/modules/services/reply_srv.dart';
import 'package:datcao/share/import.dart';
import 'package:graphql/client.dart';
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
distance
}
    ''');
    return res['getNewsFeed'];
  }

  Future getNewFeedGuest(
      {GraphqlFilter filter, String timestamp, String timeSort}) async {
    final res = await PostSrv().query('getNewsFeedByGuest', '', fragment: '''
    data {
${postFragment.replaceFirst('isUserLike', '').replaceFirst('isUserShare', '') + ' _id'}
}
    ''');
    return res['getNewsFeedByGuest'];
  }

  Future getStoryFollowing() async {
    final res = await PostSrv().query('getStoryFollowing', '', fragment: '''
    data {
id: _id
${postFragment.replaceFirst('id', '')}
}
    ''');
    return res['getStoryFollowing'];
  }

  Future getStoryForGuest() async {
    final res = await PostSrv().query('getStoryForGuest', '',
        fragment: '''
    data {
${postFragment.replaceFirst('isUserLike', '').replaceFirst('isUserShare', '') + ' _id'}
}
    ''',
        removeData: true);
    return res['getStoryForGuest'];
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

  Future getSavedPost() async {
    final res = await PostSrv().query('getSavedPost', '', fragment: '''
      data { $postFragment }
      ''');
    return res['getSavedPost'];
  }

  Future searchPostWithLocation(
      double long, double lat, double maxDistance) async {
    final res = await PostSrv().query('searchPostByPoint', '''
      data: {
        maxDistance: ${maxDistance * 1000}
        lng: $long
        lat: $lat
        limit: 100
        page: 1
      }
      ''', fragment: '''data { 
${postFragment.replaceFirst('isUserLike', '').replaceFirst('isUserShare', '').replaceFirst('id', '_id')}
          }''');
    return res['searchPostByPoint'];
  }

  Future getOnePost(String id) async {
    final res = await PostSrv().getItem(id);
    return res;
  }

  Future getOnePostGuest(String id) async {
    final res =
        await PostSrv().query('getOnePostByGuest', 'id: "$id"', fragment: '''
${postFragment.replaceFirst('isUserLike', '').replaceFirst('isUserShare', '').replaceAll('\n', ' ') + ' _id'}
    ''');
    return res['getOnePostByGuest'];
  }

  Future getOneMediaPost(String id) async {
    final res = await MediaPostSrv().getItem(id);
    return res;
  }

  Future getPostByUserId(String userId) async {
    final res = await PostSrv().getList(
        limit: 20, order: '{createdAt: -1}', filter: '{userId: "$userId" }');
    return res;
  }

  Future getPostByUserIdGuest(String userId) async {
    final res = await PostSrv().getList(
        limit: 20,
        order: '{createdAt: -1}',
        filter: '{userId: "$userId"}',
        fragment: '''
        ${postFragment.replaceFirst('isUserLike', '').replaceFirst('isUserShare', '')}
        ''');
    return res;
  }

  Future createComment(
      {String postId, String mediaPostId, String content, List<String> tagUserIds}) async {
    String data = '''
content: """
$content
"""
like: 0
tagUserIds: ${GraphqlHelper.listStringToGraphqlString(tagUserIds)}
    ''';
    if (mediaPostId != null) {
      data += '\nmediaPostId: "$mediaPostId"';
    } else {
      data += '\npostId: "$postId"';
    }
    final res = await CommentSrv().add(data, fragment: '''
    ${CommentSrv().fragmentDefault}
    ''');
    return res;
  }

  Future createReply({String commentId, String content}) async {
    String data = '''
commentId: "$commentId"
content: """
$content
"""
    ''';
    final res = await ReplySrv().add(data, fragment: '''
    ${ReplySrv().fragmentDefault}
    ''');
    return res;
  }

  String cr(List<LatLng> polygon) {
    String res = '';
    if (polygon == null) return null;
    res = '''polygon: {
      paths: [
        ${polygon.map((e) => '{lat: ${e.latitude}, lng: ${e.longitude}},').toList().join()}
      ]
    }''';
    return res;
  }

  Future createPost(
      String content,
      String expirationDate,
      bool publicity,
      double lat,
      double long,
      List<String> images,
      List<String> videos,
      List<LatLng> polygon) async {
    String polygonStr = '''{
      paths: [
        ${polygon.map((e) => '{lat: ${e.latitude}, lng: ${e.longitude}},').toList().join()}
      ]
    }''';
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
    if (polygon != null && polygon.length > 0) {
      data += '\npolygon: $polygonStr';
    }
    final res =
        await PostSrv().mutate('createPost', 'data: {$data}', fragment: '''
${postFragment.replaceAll('\n', ' ')}
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

  Future deleteReply(String replyId) async {
    final res = await ReplySrv().delete(replyId);
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

  Future hidePost(
    String id,
  ) async {
    String data = '''
flag: true
    ''';
    final res = await PostSrv()
        .mutate('updatePost', 'id: "$id"  data: {$data}', fragment: '''
id
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

  Future unsavePost(String postId) async {
    final res =
        await PostSrv().mutate('unsavePost', 'postId: "$postId"', fragment: '''
        id
        ''');
    return res['unsavePost'];
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

  Future getAllReplyByCommentId(
      {String commentId, GraphqlFilter filter}) async {
    final res = await ReplySrv().getList(
        limit: filter?.limit,
        offset: filter?.offset,
        search: filter?.search,
        page: filter?.page,
        order: filter?.order,
        filter: "{commentId: \"$commentId\"}");
    return res;
  }

  Future getAllCommentByPostIdGuest(
      {String postId, GraphqlFilter filter}) async {
    final res = await CommentSrv().query(
        'getCommentByGuest', ' q : { filter: {postId: \"$postId\"} } ',
        fragment: 'data { ${CommentSrv().fragmentDefault} }');
    return res['getCommentByGuest'];
  }

  Future getAllReplyByCommentIdGuest(
      {String commentId, GraphqlFilter filter}) async {
    final res = await CommentSrv().query(
        'getReplyByGuest', ' q : { filter: {commentId: \"$commentId\"} } ',
        fragment: 'data { ${ReplySrv().fragmentDefault} }');
    return res['getReplyByGuest'];
  }

  Future getAllCommentByMediaPostIdGuest(
      {String mediaPostId, GraphqlFilter filter}) async {
    final res = await CommentSrv().query('getCommentByGuest',
        ' q : { filter: {mediaPostId: \"$mediaPostId\"} } ',
        fragment: 'data { ${CommentSrv().fragmentDefault} }');
    return res['getCommentByGuest'];
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

  Future getAllHashTagTP() async {
    final res = await ReportSrv().queryEnum('getAllHashTagTP');
    return res['getAllHashTagTP'];
  }

  Future getAddress(double long, double lat) async {
    final res = await ReportSrv().query(
        'getAddress', 'locationLong: $long , locationLat: $lat',
        fragment: 'address ward district province');
    return res['getAddress'];
  }

  Stream<FetchResult> subscriptionCommentByPostId(String postId) {
    List<String> ids = [postId];
    final res = CommentSrv().subscription('newComment',
        'postIds: ${GraphqlHelper.listStringToGraphqlString(ids)}');
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
expirationDate
publicity
rawContent
dynamicLink {
  shortLink
  previewLink
}
isUserLike
isUserShare
hashTag
storyImages
polygon {
  paths {
    lat
    lng
  }
}
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
  friendIds
  avatar
  totalPost
  facebookUrl
  description
}
rawContent
mediaPosts {
id
userId
type
like
userLikeIds
commentIds
halfUrl
description
url
locationLat
locationLong
expirationDate
publicity
createdAt
updatedAt
dynamicLink {
  shortLink
  previewLink
}
}
province
district
ward
createdAt
updatedAt
   isPage
    page{
       	id
        name
        ownerId
        categoryIds
        avartar
        coverImage
        phone
        address
        website
        createdAt
        updatedAt
        followerIds
        followers{
          id
          name
        }
        category{
          id
          name
        }
        owner{
          id
          name
          email
        }
    }
  ''';
}
