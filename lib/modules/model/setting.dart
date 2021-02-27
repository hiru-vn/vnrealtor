class SettingModel {
  bool likeNoti;
  bool shareNoti;
  bool commentNoti;

  SettingModel({this.likeNoti, this.shareNoti, this.commentNoti});

  SettingModel.fromJson(Map<String, dynamic> json) {
    likeNoti = json['likeNoti'];
    shareNoti = json['shareNoti'];
    commentNoti = json['commentNoti'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['likeNoti'] = this.likeNoti?? false;
    data['shareNoti'] = this.shareNoti ?? true;
    data['commentNoti'] = this.commentNoti ?? true;
    return data;
  }
}
