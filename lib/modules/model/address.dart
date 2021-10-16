class Address {
  String? address;
  String? ward;
  String? district;
  String? province;

  Address({this.address, this.ward, this.district, this.province});

  Address.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    ward = json['ward'];
    district = json['district'];
    province = json['province'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['ward'] = this.ward;
    data['district'] = this.district;
    data['province'] = this.province;
    return data;
  }
}