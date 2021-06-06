import 'package:datcao/modules/model/user.dart';

class GroupModel {
  String id;
  String name;
  bool privacy;
  String description;
  String coverImage;
  String address;
  double locationLat;
  double locationLong;
  String addressByLatLon;
  String ownerId;
  List<String> memberIds;
  List<String> adminIds;
  bool isMember;
  bool isAdmin;
  bool isOwner;
  UserModel owner;
  int countMember;
  String createdAt;
  String updatedAt;
  int totalPost;
  int postIn24h;
  int memberIn24h;
  bool censor;

  GroupModel(
      {this.id,
      this.name,
      this.privacy,
      this.description,
      this.coverImage,
      this.address,
      this.locationLat,
      this.locationLong,
      this.addressByLatLon,
      this.ownerId,
      this.memberIds,
      this.adminIds,
      this.isMember,
      this.isOwner,
      this.isAdmin,
      this.owner,
      this.countMember,
      this.createdAt,
      this.updatedAt,
      this.memberIn24h,
      this.postIn24h,
      this.totalPost,
      this.censor});

  GroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    privacy = json['privacy'];
    description = json['description'];
    coverImage = json['coverImage'];
    address = json['address'];
    locationLat = json['locationLat'];
    locationLong = json['locationLong'];
    addressByLatLon = json['addressByLatLon'];
    ownerId = json['ownerId'];
    if (json['memberIds'] != null) {
      memberIds = new List<String>();
      json['memberIds'].forEach((v) {
        memberIds.add(v);
      });
    }
    if (json['adminIds'] != null) {
      adminIds = new List<String>();
      json['adminIds'].forEach((v) {
        adminIds.add(v);
      });
    }
    isMember = json['isMember'];
    isOwner = json['isOwner'];
    isAdmin = json['isAdmin'];
    owner =
        json['owner'] != null ? new UserModel.fromJson(json['owner']) : null;
    countMember = json['countMember'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    memberIn24h = json['memberIn24h'];
    postIn24h = json['postIn24h'];
    totalPost = json['totalPost'];
    censor = json['censor']??false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['privacy'] = this.privacy;
    data['description'] = this.description;
    data['coverImage'] = this.coverImage;
    data['address'] = this.address;
    data['locationLat'] = this.locationLat;
    data['locationLong'] = this.locationLong;
    data['addressByLatLon'] = this.addressByLatLon;
    data['ownerId'] = this.ownerId;
    if (this.memberIds != null) {
      data['memberIds'] = this.memberIds.map((v) => v).toList();
    }
    data['isMember'] = this.isMember;
    data['isOwner'] = this.isOwner;
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    data['countMember'] = this.countMember;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
