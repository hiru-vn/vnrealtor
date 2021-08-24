import 'package:datcao/modules/model/setting.dart';
import './media_post.dart';

class UserModel {
  String id;
  String uid;
  String name;
  String tagName;
  String email;
  String phone;
  String role;
  int reputationScore;
  List<String> friendIds;
  String createdAt;
  String updatedAt;
  String avatar;
  List<String> followerIds;
  List<String> followingIds;
  List<String> fastFollowIds;
  List<String> savedPostIds;
  List<String> groupIds;
  int totalPost;
  int notiCount;
  int likePoint;
  int sharePoint;
  int commentPoint;
  int totalPoint;
  String description;
  String facebookUrl;
  SettingModel setting;
  bool isVerify;
  bool isPendingVerify;
  int messNotiCount;
  bool isMod;
  DynamicLink dynamicLink;

  UserModel(
      {this.id,
      this.uid,
      this.name,
      this.tagName,
      this.email,
      this.phone,
      this.role,
      this.reputationScore,
      this.friendIds,
      this.createdAt,
      this.updatedAt,
      this.avatar,
      this.totalPost,
      this.followerIds,
      this.notiCount,
      this.likePoint,
      this.sharePoint,
      this.commentPoint,
      this.totalPoint,
      this.followingIds,
      this.savedPostIds,
      this.groupIds,
      this.description,
      this.facebookUrl,
      this.setting,
      this.messNotiCount,
      this.isVerify,
      this.isPendingVerify,
      this.isMod,
      this.dynamicLink});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    name = json['name'];
    tagName = json['tagName'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'];
    messNotiCount = json['messNotiCount'];
    reputationScore = json['reputationScore'];
    friendIds =
        json['friendIds'] != null ? json['friendIds'].cast<String>() : [];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    totalPost = json['totalPost'] ?? 0;
    avatar = json['avatar'];
    groupIds = json['groupIds'] != null ? json['groupIds'].cast<String>() : [];
    followerIds =
        json['followerIds'] != null ? json['followerIds'].cast<String>() : [];
    followingIds =
        json['followingIds'] != null ? json['followingIds'].cast<String>() : [];
    savedPostIds =
        json['savedPostIds'] != null ? json['savedPostIds'].cast<String>() : [];
    notiCount = json['notiCount'];
    likePoint = json['likePoint'];
    sharePoint = json['sharePoint'];
    commentPoint = json['commentPoint'];
    totalPoint = json['likePoint'] + json['sharePoint'] + json['commentPoint'];
    description = json['description'];
    facebookUrl = json['facebookUrl'];
    isMod = json['isMod'] ?? false;
    isVerify = json['isVerify'] ?? false;
    isPendingVerify = json['isPendingVerify'] ?? false;
    if (json['settings'] != null)
      setting = SettingModel.fromJson(json['settings']);

    if (json['followerIds'] != null && json['followingIds'] != null)
      fastFollowIds = (json['followerIds'].cast<String>() as List)
          .where((element) =>
              !(json['followingIds'].cast<String>() as List).contains(element))
          .toList();
    dynamicLink = json['dynamicLink'] == null
        ? null
        : DynamicLink.fromJson(json['dynamicLink']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['role'] = this.role;
    data['reputationScore'] = this.reputationScore;
    data['friendIds'] = this.friendIds;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['followingIds'] = this.followingIds;
    data['followerIds'] = this.followerIds;
    data['savedPostIds'] = this.savedPostIds;
    data['notiCount'] = this.notiCount;
    data['description'] = this.description;
    data['facebookUrl'] = this.facebookUrl;
    data['isVerify'] = this.isVerify;
    data['tagName'] = this.tagName;

    return data;
  }
}
