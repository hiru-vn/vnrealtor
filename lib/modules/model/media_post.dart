class MediaPost {
  String id;
  String userId;
  String type;
  int like;
  List<String> userLikeIds;
  List<String> commentIds;
  String description;
  String url;
  double locationLat;
  double locationLong;
  String expirationDate;
  bool publicity;
  String createdAt;
  String updatedAt;

  MediaPost(
      {this.id,
      this.userId,
      this.type,
      this.like,
      this.userLikeIds,
      this.commentIds,
      this.description,
      this.url,
      this.locationLat,
      this.locationLong,
      this.expirationDate,
      this.publicity,
      this.createdAt,
      this.updatedAt});

  MediaPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    type = json['type'];
    like = json['like'];
    userLikeIds = json['userLikeIds'].cast<String>();
    commentIds = json['commentIds'].cast<String>();
    description = json['description'];
    url = json['url'];
    locationLat = json['locationLat'] == null
        ? null
        : (json['locationLat'] as num).toDouble();
    locationLong = json['locationLong'] == null
        ? null
        : (json['locationLong'] as num).toDouble();
    expirationDate = json['expirationDate'];
    publicity = json['publicity'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['type'] = this.type;
    data['like'] = this.like;
    data['userLikeIds'] = this.userLikeIds;
    data['commentIds'] = this.commentIds;
    data['description'] = this.description;
    data['url'] = this.url;
    data['locationLat'] = this.locationLat;
    data['locationLong'] = this.locationLong;
    data['expirationDate'] = this.expirationDate;
    data['publicity'] = this.publicity;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
