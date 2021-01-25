enum FriendShipStatus { PENDING, DECLINE, ACCEPTED }

class FriendshipModel {
  String id;
  String user1Id;
  String user2Id;
  FriendShipStatus status;

  FriendshipModel({this.id, this.user1Id, this.user2Id, this.status});

  FriendshipModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user1Id = json['user1Id'];
    user2Id = json['user2Id'];
    status = fromStatus(json['status']);
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
