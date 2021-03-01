class NotificationModel {
  String id;
  String type;
  String title;
  String body;
  String html;
  bool seen;
  String seenAt;
  dynamic data;
  String image;
  String toUserId;
  String fromUserId;
  String createdAt;
  String updatedAt;

  NotificationModel(
      {this.id,
      this.type,
      this.title,
      this.body,
      this.html,
      this.seen,
      this.seenAt,
      this.data,
      this.image,
      this.toUserId,
      this.fromUserId,
      this.createdAt,
      this.updatedAt,});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['data']['type'].toString().toUpperCase();
    title = json['title'];
    body = json['body'];
    html = json['html'];
    seen = json['seen'];
    seenAt = json['seenAt'];
    data = json['data'];
    image = json['image'];
    toUserId = json['toUserId'];
    fromUserId = json['fromUserId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['title'] = this.title;
    data['body'] = this.body;
    data['html'] = this.html;
    data['seen'] = this.seen;
    data['seenAt'] = this.seenAt;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['image'] = this.image;
    data['toUserId'] = this.toUserId;
    data['fromUserId'] = this.fromUserId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
