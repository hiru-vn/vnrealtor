import 'package:vnrealtor/modules/model/user.dart';

enum FriendShipStatus { PENDING, DECLINE, ACCEPTED }

class FriendshipModel {
  String id;
  String user1Id;
  String user2Id;
  FriendShipStatus status;
  UserModel user1;
  UserModel user2;
  String createdAt;
  String updatedAt;

  FriendshipModel({this.id, this.user1Id, this.user2Id, this.status});

  FriendshipModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user1Id = json['user1Id'];
    user2Id = json['user2Id'];
    status = fromStatus(json['status']);
    user1 = json['user1'] !=null? UserModel.fromJson(json['user1']) : null;
    user2 = json['user2'] !=null? UserModel.fromJson(json['user2']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user1Id'] = this.user1Id;
    data['user2Id'] = this.user2Id;
    data['status'] = toStatus(this.status);
    return data;
  }

  FriendShipStatus fromStatus(String status) {
    if (status == 'PENDING') return FriendShipStatus.PENDING;
    if (status == 'ACCEPTED') return FriendShipStatus.ACCEPTED;
    if (status == 'DECLINE') return FriendShipStatus.DECLINE;
    return null;
  }

  String toStatus(FriendShipStatus status) {
    if (status == FriendShipStatus.PENDING) return 'PENDING';
    if (status == FriendShipStatus.ACCEPTED) return 'ACCEPTED';
    if (status == FriendShipStatus.DECLINE) return 'DECLINE';
    return null;
  }
}
