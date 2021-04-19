import 'package:datcao/modules/pages/services/create_page_srv.dart';
import 'package:datcao/modules/pages/services/follow_page_srv.dart';
import 'package:datcao/modules/pages/services/page_create_post_srv.dart';
import 'package:datcao/modules/pages/services/pages_srv.dart';
import 'package:datcao/modules/pages/services/suggest_follow_srv.dart';
import 'package:datcao/modules/services/graphql_helper.dart';
import 'package:datcao/modules/services/post_srv.dart';
import 'package:datcao/share/import.dart';

class PagesRepo {
  Future getPageCreate({GraphqlFilter filter}) async {
    if (filter?.filter == null) filter?.filter = "{}";
    if (filter?.search == null) filter?.search = "";
    final data = 'q:{ ${filter?.filter} }';
    final res = await PagesSrv().query('getAllPage', data, fragment: '''
    data {
$pagesFragment
}
    ''');
    return res['getAllPage'];
  }

  Future createPagePost(
      String pageId,
      String content,
      String expirationDate,
      bool publicity,
      double lat,
      double long,
      List<String> images,
      List<String> videos) async {
    String data = '''
    pageId: "$pageId"
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
$pagesPostFragment
    ''');
    return res["createPost"];
  }

  Future getPostOfPage(
      {GraphqlFilter filter, String timestamp, String timeSort}) async {
    if (filter?.filter == null) filter?.filter = "{}";
    if (filter?.search == null) filter?.search = "";
    final data = 'q:{filter: ${filter?.filter}}';
    final res = await PostSrv().query('getAllPost', data, fragment: '''
    data {
$pagesPostFragment
}
    ''');
    return res['getAllPost'];
  }

  Future followPage(String pageId) async {
    String data = '''
    pageId: "$pageId"
    ''';

    final res =
        await FollowPageSrv().mutate('followPage', '$data', fragment: '''
$followPageFragment
    ''');
    return res["followPage"];
  }

  Future unFollowPage(String pageId) async {
    String data = '''
    pageId: "$pageId"
    ''';

    final res =
        await FollowPageSrv().mutate('unfollowPage', '$data', fragment: '''
$followPageFragment
    ''');
    return res["unfollowPage"];
  }

  Future getCategories(
      {GraphqlFilter filter, String timestamp, String timeSort}) async {
    if (filter?.filter == null) filter?.filter = "{}";
    if (filter?.search == null) filter?.search = "";
    final data = 'q:{search: "${filter?.search}"}';
    final res = await CategoriesPageSrv()
        .query('getAllCategoryPage', data, fragment: '''
    data {
$categoriesPageFragment
}
    ''');
    return res['getAllCategoryPage'];
  }

  Future createPage(
      String name,
      String description,
      String avatar,
      String coverImage,
      List<String> categoryIds,
      String address,
      String website,
      String phone) async {
    String data = '''
name: "$name"
description: "$description"
avartar: "$avatar"
coverImage: "$coverImage"
website: "$website"
address: "$address"
phone: "$phone"
categoryIds: ${GraphqlHelper.listStringToGraphqlString(categoryIds)}
    ''';

    final res = await CreatePageSrv()
        .mutate('createPage', 'data: {$data}', fragment: '''
$pageFragment
    ''');
    return res["createPage"];
  }

  Future getOnePage(String pageId) async {
    final data = 'id: "$pageId"';
    final res = await PagesSrv().query('getOnePage', data, fragment: '''
    $pagesFragment
    ''');
    return res['getOnePage'];
  }

  Future getPostFollower(
      {GraphqlFilter filter, String userId}) async {
    if (filter?.filter == null) filter?.filter = "{}";
    if (filter?.search == null) filter?.search = "";
    final data =
        'limit: ${filter?.limit}, Page: ${filter?.page ?? 1}, userId: "$userId"';
    final res = await PagesSrv().query('getListFollowPage', data, fragment: '''
    data {
$pagesFragment
}
    ''');
    return res['getListFollowPage'];
  }


  Future suggestFollowPage() async {
    final res = await PagesSrv().query('suggestFollowPage', '',
        fragment: ' $pagesFragment ', removeData: true);
    return res['suggestFollowPage'];
  }

}

String pagesFragment = '''
  id
  name
  description
  avartar
  coverImage
  followerIds
  categoryIds
  ownerId
  phone
  address
  website
  followers{ 
    id
    name
  }
   owner{
    id
    name
    avatar
  }
   category{
    id
    name
  }
  createdAt
  updatedAt
  ''';

String pageCreatePostFragment = '''
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
        isUserLike
        isUserShare
        hashTag
        storyImages
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
        }
        province
        district
        ward
        createdAt
        updatedAt

    page{
      id
      name
      avartar
      phone
      address
      }
  ''';

String pagesPostFragment = '''
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

String followPageFragment = '''
   id
    followerIds

    followers{
      id
      name
    }
  ''';

String pageFragment = '''
 id
  name
  description
  avartar
  coverImage
  followerIds
  categoryIds
  ownerId
  phone
  address
  website
  followers{ 
    id
    name
  }
   owner{
    id
    name
    avatar
  }
   category{
    id
    name
  }
  createdAt
  updatedAt
  ''';

String categoriesPageFragment = '''
id
name
  ''';

String suggestFollowFragment = '''
 id
    name
    avartar
    coverImage
    description
    address
    phone
    email
    website
    followerIds
    followers{
      id
      name
    }
    owner{
      id
      name
    }
  ''';
