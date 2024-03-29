import 'package:datcao/modules/model/group.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/share/import.dart';
import 'dart:math';

import 'media_post.dart';

class PostModel {
  String id;
  String content;
  String rawContent;
  List<String> mediaPostIds;
  List<String> commentIds;
  String userId;
  int like;
  List<String> userLikeIds;
  int share;
  List<String> userShareIds;
  double locationLat;
  double locationLong;
  String expirationDate;
  bool publicity;
  UserModel user;
  int point;
  List<MediaPost> mediaPosts;
  String createdAt;
  String updatedAt;
  bool isUserLike;
  bool isUserShare;
  String province;
  String district;
  String ward;
  List<String> hashTag;
  List<String> halfImages;
  List<String> storyImages;
  List<LatLng> polygonPoints;
  DynamicLink dynamicLink;
  bool isPage;
  PagesCreate page;
  double distance;
  List<UserModel> tagUsers;
  int numberOfComment;
  GroupModel group;
  String postShareId;
  num price;
  num area;
  String action;
  String category;
  bool isBlock;

  PostModel(
      {this.id,
      this.content,
      this.mediaPostIds,
      this.commentIds,
      this.userId,
      this.like,
      this.userLikeIds,
      this.share,
      this.userShareIds,
      this.locationLat,
      this.locationLong,
      this.expirationDate,
      this.point,
      this.publicity,
      this.storyImages,
      this.user,
      this.mediaPosts,
      this.createdAt,
      this.updatedAt,
      this.isUserLike,
      this.isUserShare,
      this.district,
      this.province,
      this.hashTag,
      this.rawContent,
      this.ward,
      this.halfImages,
      this.page,
      this.polygonPoints,
      this.dynamicLink,
      this.isPage,
      this.distance,
      this.tagUsers,
      this.numberOfComment,
      this.group,
      this.postShareId,
      this.action,
      this.area,
      this.category,
      this.price,
      this.isBlock});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['_id'];
    content = json['content'];
    rawContent = json['rawContent'];
    mediaPostIds =
        json['mediaPostIds'] != null ? json['mediaPostIds'].cast<String>() : [];
    commentIds =
        json['commentIds'] != null ? json['commentIds'].cast<String>() : [];
    userId = json['userId'];
    like = json['like'];
    userLikeIds =
        json['userLikeIds'] != null ? json['userLikeIds'].cast<String>() : [];
    share = json['share'];
    userShareIds =
        json['userShareIds'] != null ? json['userShareIds'].cast<String>() : [];
    hashTag = json['hashTag'] != null ? json['hashTag'].cast<String>() : [];
    locationLat = json['locationLat'] == null
        ? null
        : (json['locationLat'] as num).toDouble();
    locationLong = json['locationLong'] == null
        ? null
        : (json['locationLong'] as num).toDouble();
    expirationDate = json['expirationDate'];
    point = json['point'] ?? 0;
    publicity = json['publicity'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    if (json['mediaPosts'] != null) {
      mediaPosts = new List<MediaPost>();
      json['mediaPosts'].forEach((v) {
        if (v == null) return;
        mediaPosts.add(new MediaPost.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isUserLike = json['isUserLike'] ?? false;
    isUserShare = json['isUserShare'] ?? false;
    district = json['district'];
    province = json['province'];
    ward = json['ward'];
    halfImages =
        json['halfImages'] != null ? json['halfImages'].cast<String>() : [];
    storyImages =
        json['storyImages'] != null ? json['storyImages'].cast<String>() : [];
    page = json['page'] != null ? new PagesCreate.fromJson(json['page']) : null;
    if (json['polygon'] != null && json['polygon']["paths"] != null) {
      polygonPoints = (json['polygon']["paths"] as List)
          .map((e) => LatLng(double.tryParse(e['lat'].toString()),
              double.tryParse(e['lng'].toString())))
          .toList();
    }
    dynamicLink = json['dynamicLink'] == null
        ? null
        : DynamicLink.fromJson(json['dynamicLink']);
    isPage = json['isPage'];
    distance = double.tryParse(json['distance'].toString());
    tagUsers = json['tagUsers'] != null
        ? json['tagUsers'].map<UserModel>((e) => UserModel.fromJson(e)).toList()
        : [];
    numberOfComment = json['numberOfComment'] ?? 0;
    group = json['group'] != null ? GroupModel.fromJson(json['group']) : null;
    postShareId = json['postShareId'];
    category = json['category'];
    action = json['action'];
    price = json['price'];
    area = json['area'];
    isBlock = json['isBlock'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['mediaPostIds'] = this.mediaPostIds;
    data['commentIds'] = this.commentIds;
    data['userId'] = this.userId;
    data['like'] = this.like;
    data['point'] = this.point;
    data['userLikeIds'] = this.userLikeIds;
    data['share'] = this.share;
    data['userShareIds'] = this.userShareIds;
    data['locationLat'] = this.locationLat;
    data['locationLong'] = this.locationLong;
    data['expirationDate'] = this.expirationDate;
    data['publicity'] = this.publicity;
    data['user'] = this.user;
    if (this.mediaPosts != null) {
      data['mediaPosts'] = this.mediaPosts.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['isUserLike'] = this.isUserLike;
    data['isUserShare'] = this.isUserShare;
    data['halfImages'] = this.halfImages;
    if (this.page != null) {
      data['page'] = this.page.toJson();
    }
    data['isPage'] = this.isPage;
    return data;
  }
}
