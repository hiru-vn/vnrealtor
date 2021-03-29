import 'package:google_maps_flutter/google_maps_flutter.dart';

class FbInboxUserModel {
  final String id;
  final String image;
  final String name;
  final String phone;
  final List<String> groups;

  FbInboxUserModel(this.id, this.image, this.name, this.phone, this.groups);

  factory FbInboxUserModel.fromJson(Map<String, dynamic> map) {
    return FbInboxUserModel(map['id'], map['image'], map['name'], map['phone'],
        map['groups'] == null ? [] : (map['groups'] as List).cast<String>());
  }
}

class FbInboxGroupModel {
  final String id;
  final String image;
  final String lastMessage;
  final String lastUser;
  final String time;
  final List<String> readers;
  final List<FbInboxUserModel> users;
  final List<String> userIds;
  final List<String> userAvatars;
  final List<String> blockedBy;

  FbInboxGroupModel(this.id, this.image, this.lastMessage, this.lastUser,
      this.time, this.readers, this.users, this.userIds, this.userAvatars,
      {this.blockedBy});

  factory FbInboxGroupModel.fromJson(
      Map<String, dynamic> map, String id, List<FbInboxUserModel> users) {
    return FbInboxGroupModel(
      id,
      map['image'],
      map['lastMessage'],
      map["lastUser"],
      map['time'],
      map['readers'] == null ? [] : (map['readers'] as List).cast<String>(),
      users,
      map['userIds'] == null ? [] : (map['userIds'] as List).cast<String>(),
      map['userAvatars'] == null
          ? []
          : (map['userAvatars'] as List).cast<String>(),
      blockedBy: map['blockedBy'] == null
          ? []
          : (map['blockedBy'] as List).cast<String>(),
    );
  }
}

class FbInboxMessageModel {
  final String id;
  final String avatar;
  final String date;
  final String fullName;
  final String text;
  final String uid; //userId
  final List<String> filePaths;
  final LatLng location;

  FbInboxMessageModel(this.id, this.avatar, this.date, this.fullName, this.text,
      this.uid, this.filePaths,
      {this.location});

  factory FbInboxMessageModel.fromJson(Map<String, dynamic> map, String id) {
    if (map['text'] == 'gfdgfd') {
      print(map['filePaths']);
    }
    return FbInboxMessageModel(
        id,
        map['avatar'],
        map['date'],
        map['fullName'],
        map['text'],
        map['uid'],
        map['filePaths'] == null ? [] : map['filePaths'].cast<String>(),
        location: map['lat'] == null || map['long'] == null
            ? null
            : LatLng(map['lat'], map['long']));
  }
}
