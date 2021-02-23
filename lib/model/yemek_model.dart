class Yemek {
  String objectId;
  String yemek;
  String createdAt;
  String updatedAt;
  int fiyat;

  Yemek(
      {this.objectId, this.yemek, this.createdAt, this.updatedAt, this.fiyat});

  Yemek.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    yemek = json['yemek'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    fiyat = json['fiyat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['objectId'] = this.objectId;
    data['yemek'] = this.yemek;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['fiyat'] = this.fiyat;
    return data;
  }
}
