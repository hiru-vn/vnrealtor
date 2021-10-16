class FollowPagesModel {
  String? id;
  List<String>? followerIds;
  List<Followers>? followers;

  FollowPagesModel({this.id, this.followerIds, this.followers});

  FollowPagesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    followerIds = json['followerIds'].cast<String>();
    if (json['followers'] != null) {
      followers = <Followers>[];
      json['followers'].forEach((v) {
        followers!.add(new Followers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['followerIds'] = this.followerIds;
    if (this.followers != null) {
      data['followers'] = this.followers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Followers {
  String? id;
  String? name;

  Followers({this.id, this.name});

  Followers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}