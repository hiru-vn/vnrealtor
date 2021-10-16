class PagesCreate {
  String? id;
  String? name;
  String? description;
  String? avartar;
  String? coverImage;
  List<String?>? followerIds;
  List<String>? categoryIds;
  String? ownerId;
  String? phone;
  String? address;
  String? website;
  List<Followers>? followers;
  Owner? owner;
  List<Category>? category;
  bool? isOwner;
  bool? isNoty;
  String? createdAt;
  String? updatedAt;

  PagesCreate(
      {this.id,
      this.name,
      this.description,
      this.avartar,
      this.coverImage,
      this.followerIds,
      this.categoryIds,
      this.ownerId,
      this.phone,
      this.address,
      this.website,
      this.followers,
      this.owner,
      this.category,
      this.createdAt,
      this.isOwner,
      this.isNoty,
      this.updatedAt});

  PagesCreate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    avartar = json['avartar'];
    coverImage = json['coverImage'];
    followerIds = json['followerIds'].cast<String>();
    categoryIds = json['categoryIds'].cast<String>();
    ownerId = json['ownerId'];
    phone = json['phone'];
    address = json['address'];
    website = json['website'];
    isOwner = json['isOwner'] ?? false;
    isNoty = json['isNoty'] ?? false;
    if (json['followers'] != null) {
      followers = <Followers>[];
      json['followers'].forEach((v) {
        if (v != null) followers!.add(new Followers.fromJson(v));
      });
    }
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(new Category.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['avartar'] = this.avartar;
    data['coverImage'] = this.coverImage;
    data['followerIds'] = this.followerIds;
    data['categoryIds'] = this.categoryIds;
    data['ownerId'] = this.ownerId;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['website'] = this.website;
    data['isOwner'] = this.isOwner;
    data['isNoty'] = this.isNoty;
    if (this.followers != null) {
      data['followers'] = this.followers!.map((v) => v.toJson()).toList();
    }
    if (this.owner != null) {
      data['owner'] = this.owner!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
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

class Owner {
  String? id;
  String? name;
  String? avatar;

  Owner({this.id, this.name, this.avatar});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    return data;
  }
}

class Category {
  String? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
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
