class FollowPagesModel {
  FollowPage followPage;

  FollowPagesModel({this.followPage});

  FollowPagesModel.fromJson(Map<String, dynamic> json) {
    followPage = json['followPage'] != null
        ? new FollowPage.fromJson(json['followPage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.followPage != null) {
      data['followPage'] = this.followPage.toJson();
    }
    return data;
  }
}

class FollowPage {
  String id;
  List<String> followerIds;
  List<Followers> followers;

  FollowPage({this.id, this.followerIds, this.followers});

  FollowPage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    followerIds = json['followerIds'].cast<String>();
    if (json['followers'] != null) {
      followers = new List<Followers>();
      json['followers'].forEach((v) {
        followers.add(new Followers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['followerIds'] = this.followerIds;
    if (this.followers != null) {
      data['followers'] = this.followers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Followers {
  String id;
  String name;

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