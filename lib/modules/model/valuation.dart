class ValuationHcmStreet {
  String? id;
  String? wardId;
  String? wardName;
  String? streetName;
  num? prevAvgPrice;
  num? avgPrice;
  num? priceChangedPercentage;
  int? totalAssets;

  ValuationHcmStreet(
      {this.id,
      this.wardId,
      this.wardName,
      this.streetName,
      this.prevAvgPrice,
      this.avgPrice,
      this.priceChangedPercentage,
      this.totalAssets});

  ValuationHcmStreet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wardId = json['wardId'];
    wardName = json['wardName'];
    streetName = json['streetName'];
    prevAvgPrice = json['prevAvgPrice'];
    avgPrice = json['avgPrice'];
    priceChangedPercentage = json['priceChangedPercentage'];
    totalAssets = json['totalAssets'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['wardId'] = this.wardId;
    data['wardName'] = this.wardName;
    data['streetName'] = this.streetName;
    data['prevAvgPrice'] = this.prevAvgPrice;
    data['avgPrice'] = this.avgPrice;
    data['priceChangedPercentage'] = this.priceChangedPercentage;
    data['totalAssets'] = this.totalAssets;
    return data;
  }
}
