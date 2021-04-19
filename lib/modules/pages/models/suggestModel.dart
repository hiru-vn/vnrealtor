class SuggestFollowModel {
  String id;
  String name;
  String avartar;
  String coverImage;
  String description;
  String address;
  String phone;
  String email;
  String website;
  List<String> followerIds;
  List<String> followers;
  Owner owner;

  SuggestFollowModel(
      {this.id,
        this.name,
        this.avartar,
        this.coverImage,
        this.description,
        this.address,
        this.phone,
        this.email,
        this.website,
        this.followerIds,
        this.followers,
        this.owner});

  SuggestFollowModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avartar = json['avartar'];
    coverImage = json['coverImage'];
    description = json['description'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    website = json['website'];
    followerIds = json['followerIds'].cast<String>();
    followers = json['followers'].cast<String>();
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avartar'] = this.avartar;
    data['coverImage'] = this.coverImage;
    data['description'] = this.description;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['website'] = this.website;
    data['followerIds'] = this.followerIds;
    data['followers'] = this.followers;
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    return data;
  }
}

class Owner {
  String id;
  String name;

  Owner({this.id, this.name});

  Owner.fromJson(Map<String, dynamic> json) {
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

