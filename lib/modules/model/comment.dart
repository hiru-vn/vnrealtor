import 'package:datcao/modules/model/user.dart';

class CommentModel {
  String id;
  String content;
  String userId;
  String mediaPostId;
  String postId;
  int like;
  UserModel user;
  String createdAt;
  String updatedAt;
  bool isLike = false;
  List<String> userLikeIds = [];
  List<String> replyIds = [];
  Map userTags;

  CommentModel(
      {this.id,
      this.content,
      this.userId,
      this.mediaPostId,
      this.postId,
      this.like,
      this.user,
      this.createdAt,
      this.updatedAt,
      this.userLikeIds,
      this.replyIds,
      this.userTags});

  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    userId = json['userId'];
    postId = json['postId'];
    mediaPostId = json['mediaPostId'];
    like = json['like'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userLikeIds =
        json['userLikeIds'] != null ? json['userLikeIds'].cast<String>() : [];
    replyIds = json['replyIds'] != null ? json['replyIds'].cast<String>() : [];
    if (json['userTags'] != null) {
      userTags = json['userTags'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['userId'] = this.userId;
    data['postId'] = this.postId;
    data['mediaPostId'] = this.mediaPostId;
    data['like'] = this.like;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['userLikeIds'] = this.userLikeIds;
    return data;
  }
}
