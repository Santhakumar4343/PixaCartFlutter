class ModelBrand {

  int status;
  String message;
  List<BrandData>  data;

  ModelBrand(this.status, this.message, this.data);
  factory ModelBrand.fromJson(Map<dynamic, dynamic> json) {
    return ModelBrand(json['status'], json['message'], List<BrandData>.from(json["data"].map((x) => BrandData.fromJson(x))));
  }}

class BrandData {
  String brand_name = "";
  String brand_image = "";
  String thumb_image = "";
  int status;
  String id ="";


  BrandData(this.brand_name, this.brand_image, this.status, this.id);

  factory BrandData.fromJson(Map<String, dynamic> json) {
    return BrandData(json['brand_name'] ?? '',json['brand_image'] ?? ''
        ,json['status'] ?? 0,json['_id'] ?? '');
  }

}



