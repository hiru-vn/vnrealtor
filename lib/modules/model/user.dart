class UserModel {
  String id;
  String uid;
  String name;
  String email;
  String phone;
  String role;
  int reputationScore;
  List<String> friendShipId;
  String createdAt;
  String updatedAt;
  String avatar;

  UserModel(
      {this.id,
      this.uid,
      this.name,
      this.email,
      this.phone,
      this.role,
      this.reputationScore,
      this.friendShipId,
      this.createdAt,
      this.updatedAt,
      this.avatar});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'];
    reputationScore = json['reputationScore'];
    friendShipId = json['friendShipId'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    avatar = json['avatar'];
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
    data['friendShipId'] = this.friendShipId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
