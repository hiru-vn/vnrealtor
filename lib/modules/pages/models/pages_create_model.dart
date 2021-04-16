class PagesCreate {
  String id;
  String name;
  String ownerId;
  List<String> categoryIds;
  String avartar;
  String coverImage;
  String phone;
  String address;
  String website;
  String createdAt;
  String updatedAt;
  List<Category> category;
  Owner owner;

  PagesCreate(
      {this.id,
        this.name,
        this.ownerId,
        this.categoryIds,
        this.avartar,
        this.coverImage,
        this.phone,
        this.address,
        this.website,
        this.createdAt,
        this.updatedAt,
        this.category,
        this.owner});

  PagesCreate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    ownerId = json['ownerId'];
    categoryIds = json['categoryIds'].cast<String>();
    avartar = json['avartar'];
    coverImage = json['coverImage'];
    phone = json['phone'];
    address = json['address'];
    website = json['website'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['category'] != null) {
      category = new List<Category>();
      json['category'].forEach((v) {
        category.add(new Category.fromJson(v));
      });
    }
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['ownerId'] = this.ownerId;
    data['categoryIds'] = this.categoryIds;
    data['avartar'] = this.avartar;
    data['coverImage'] = this.coverImage;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['website'] = this.website;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.category != null) {
      data['category'] = this.category.map((v) => v.toJson()).toList();
    }
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    return data;
  }
}

class Category {
  String id;
  String name;

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

class Owner {
  String id;
  String name;
  String email;

  Owner({this.id, this.name, this.email});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }
}