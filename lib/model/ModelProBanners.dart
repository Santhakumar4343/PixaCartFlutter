class ModelProBanners {

  int status;
  String message;
  List<BannersData>  data;

  ModelProBanners(this.status, this.message, this.data);
  factory ModelProBanners.fromJson(Map<dynamic, dynamic> json) {
    return ModelProBanners(json['status'], json['message'], List<BannersData>.from(json["data"].map((x) => BannersData.fromJson(x))));
  }}

class BannersData {

  String banner_image = "";
  String banner_link = "";
  int status;
  String id ="";


  BannersData( this.banner_image, this.status, this.id,this.banner_link);

  factory BannersData.fromJson(Map<String, dynamic> json) {
    return BannersData(json['banner_image'] ?? ''
        ,json['status'] ?? 0,json['_id'] ?? '',json['banner_link'] ?? '');
  }

}



