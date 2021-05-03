class ReceiveNotifyPageModel {
  String id;
  String description;
  String avartar;
  String coverImage;

  ReceiveNotifyPageModel(
      {this.id, this.description, this.avartar, this.coverImage});

  ReceiveNotifyPageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    avartar = json['avartar'];
    coverImage = json['coverImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['avartar'] = this.avartar;
    data['coverImage'] = this.coverImage;
    return data;
  }
}