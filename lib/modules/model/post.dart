import 'package:datcao/modules/model/user.dart';

import 'media_post.dart';

class PostModel {
  String id;
  String content;
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
      this.user,
      this.mediaPosts,
      this.createdAt,
      this.updatedAt,
      this.isUserLike,
      this.isUserShare,
      this.district,
      this.province,
      this.ward});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
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
    locationLat = json['locationLat'] == null
        ? null
        : (json['locationLat'] as num).toDouble();
    locationLong = json['locationLong'] == null
        ? null
        : (json['locationLong'] as num).toDouble();
    expirationDate = json['expirationDate'];
    point = json['point'] ?? 0;
    publicity = json['publicity'];
    user = UserModel.fromJson(json['user']);
    if (json['mediaPosts'] != null) {
      mediaPosts = new List<MediaPost>();
      json['mediaPosts'].forEach((v) {
        mediaPosts.add(new MediaPost.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isUserLike = json['isUserLike'] ?? false;
    isUserShare = json['isUserShare'] ?? false;
    district = json['district'];
    province = json['province'];
    
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
    return data;
  }
}
