import 'package:datcao/modules/model/group.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';

class InviteModel {
  String id;
  UserModel fromUser;
  UserModel toUser;

  InviteModel({this.id, this.fromUser, this.toUser});

  InviteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromUser = UserModel.fromJson(json['fromUser']);
    toUser = UserModel.fromJson(json['toUser']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fromUser'] = this.fromUser.toJson();
    data['toUser'] = this.toUser.toJson();
    return data;
  }
}

class InvitePageModel {
  String id;
  UserModel fromUser;
  UserModel toUser;
  PagesCreate page;

  InvitePageModel({this.id, this.fromUser, this.toUser});

  InvitePageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromUser = UserModel.fromJson(json['fromUser']);
    toUser = UserModel.fromJson(json['toUser']);
    page = PagesCreate.fromJson(json['page']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fromUser'] = this.fromUser.toJson();
    data['toUser'] = this.toUser.toJson();
    data['page'] = this.page.toJson();
    return data;
  }
}

class InviteGroupModel {
  String id;
  UserModel fromUser;
  UserModel toUser;
  GroupModel group;

  InviteGroupModel({this.id, this.fromUser, this.toUser});

  InviteGroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromUser = UserModel.fromJson(json['fromUser']);
    toUser = UserModel.fromJson(json['toUser']);
    group = GroupModel.fromJson(json['group']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fromUser'] = this.fromUser.toJson();
    data['toUser'] = this.toUser.toJson();
    data['group'] = this.group.toJson();
    return data;
  }
}
