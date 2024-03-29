import 'package:datcao/modules/pages/services/create_page_srv.dart';
import 'package:datcao/modules/pages/services/follow_page_srv.dart';
import 'package:datcao/modules/pages/services/pages_srv.dart';
import 'package:datcao/modules/pages/services/receive_notify_page.srv.dart';
import 'package:datcao/modules/pages/services/updatePage_srv.dart';
import 'package:datcao/modules/services/graphql_helper.dart';
import 'package:datcao/modules/services/post_srv.dart';
import 'package:datcao/share/import.dart';

class PagesRepo {
  Future getListPage({GraphqlFilter filter}) async {
    final res = await PagesSrv().getList(
        limit: filter?.limit,
        offset: filter?.offset,
        search: filter?.search,
        page: filter?.page,
        order: filter?.order);
    return res;
  }

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

  Future getPostOfPageByGuest(
      {GraphqlFilter filter, String timestamp, String timeSort}) async {
    if (filter?.filter == null) filter?.filter = "{}";
    if (filter?.search == null) filter?.search = "";
    final data = 'q:{filter: ${filter?.filter}}';
    final res = await PostSrv().query('getAllPost', data, fragment: '''
    data {
    ${pagesPostFragment.replaceFirst('isUserLike', '').replaceFirst('isUserShare', '') + ' _id'}
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

  Future receiveNotifyPage(String pageId) async {
    String data = '''
    pageId: "$pageId"
    ''';

    final res = await ReceiveNotifyPageSrv()
        .mutate('reciveNotiPage', '$data', fragment: '''
$receiveNotifyPageFragment
    ''');
    return res["reciveNotiPage"];
  }

  Future unReceiveNotifyPage(String pageId) async {
    String data = '''
    pageId: "$pageId"
    ''';

    final res = await ReceiveNotifyPageSrv()
        .mutate('unReciveNotiPage', '$data', fragment: '''
$receiveNotifyPageFragment
    ''');
    return res["unReciveNotiPage"];
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

  Future getOnePageGuess(String pageId) async {
    final data = 'id: "$pageId"';
    final res = await PagesSrv().query('getOnePage', data, fragment: '''
    ${pagesFragment.replaceFirst('isOwner', '').replaceFirst('isNoty', '')}
    ''');
    return res['getOnePage'];
  }

  Future getPostFollower({GraphqlFilter filter, String userId}) async {
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

  Future updatePage(
      String id,
      String avartar,
      String coverImage,
      String name,
      String description,
      List<String> categoryIds,
      String address,
      String phone,
      String email,
      String website) async {
    final res = await UpdatePageSrv().update(
        id: id,
        data: '''
          name: "$name"
          description: "$description"
          categoryIds: ${GraphqlHelper.listStringToGraphqlString(categoryIds)}
          address: "$address"
          phone: "$phone"
          email: "$email"
          website: "$website"
          avartar: "$avartar"
          coverImage: "$coverImage"
        ''',
        fragment: 'id');
    return res['id'];
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
  isOwner
  isNoty
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
          sharePoint
          commentPoint
          likePoint
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
  sharePoint
  commentPoint
  likePoint
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

String receiveNotifyPageFragment = '''
    id
    description
    avartar
    coverImage
''';
