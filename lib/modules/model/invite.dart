import 'package:datcao/modules/model/user.dart';

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
