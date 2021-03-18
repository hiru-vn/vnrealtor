import 'package:datcao/modules/model/user.dart';

class ReplyModel {
  String id;
  String content;
  String userId;
  String commentId;
  UserModel user;
  String createdAt;
  String updatedAt;

  ReplyModel(
      {this.id,
      this.content,
      this.userId,
      this.commentId,
      this.user,
      this.createdAt,
      this.updatedAt});

  ReplyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    userId = json['userId'];
    commentId = json['commentId'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['userId'] = this.userId;
    data['commentId'] = this.commentId;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
