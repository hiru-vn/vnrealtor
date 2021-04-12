class PagesCreate {
  String id;
  String name;
  String description;
  String avartar;
  String coverImage;
  List<String> categoryIds;
  String ownerId;
  Owner owner;
  List<Category> category;
  String createdAt;
  String updatedAt;

  PagesCreate(
      {this.id,
        this.name,
        this.description,
        this.avartar,
        this.coverImage,
        this.categoryIds,
        this.ownerId,
        this.owner,
        this.category,
        this.createdAt,
        this.updatedAt});

  PagesCreate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    avartar = json['avartar'];
    coverImage = json['coverImage'];
    categoryIds = json['categoryIds'].cast<String>();
    ownerId = json['ownerId'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    if (json['category'] != null) {
      category = new List<Category>();
      json['category'].forEach((v) {
        category.add(new Category.fromJson(v));
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
    data['categoryIds'] = this.categoryIds;
    data['ownerId'] = this.ownerId;
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Owner {
  String id;
  String name;
  String avatar;

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
