class ModelProduct {

  int status;
  String message;
  List<ProducData>  data;

  ModelProduct(this.status, this.message, this.data);
  factory ModelProduct.fromJson(Map<dynamic, dynamic> json) {
    return new  ModelProduct(json['status'], json['message'],new List<ProducData>.from(json["data"].map((x) => ProducData.fromJson(x))));
  }}

class ProducData {
  String variant_id = "";
  String prod_sellerid = "";
  String prod_name = "";
  String prod_unit ="";
  String pro_subtitle ="";
  String prod_unitprice;
  String prod_strikeout_price;
  int prod_tax ;
  String prod_discount ;
  String prod_discount_type ="";
  int prod_quantity =0;
  List prod_image ;
  List thumb_image ;
  int status;
  int isLiked;
  String rating_average;
  int rating_user_count;
  int featured;
  String id ="";

  ProducData(
      this.variant_id, this.prod_sellerid, this.prod_name,
      this.prod_unit, this.prod_unitprice, this.prod_tax, this.prod_discount, this.prod_discount_type,
      this.prod_quantity, this.prod_image,
      this.thumb_image, this.status, this.featured, this.id,
      this.prod_strikeout_price,this.isLiked,this.rating_average,this.rating_user_count,this.pro_subtitle);

  factory ProducData.fromJson(Map<String, dynamic> json) {
    return new ProducData(
        json['variant_id'] ?? ''
        , json['prod_sellerid'] ?? ''
        , json['prod_name'] ?? ''
        ,json['prod_unit'] ?? ''
        ,json['prod_unitprice'] ?? '0.0'
        ,json['prod_tax'] ?? 0
        ,json['prod_discount'] ?? '0'
        ,json['prod_discount_type'] ?? ''
        ,json['prod_quantity'] ?? 0
        ,json['prod_image'] ?? []
        ,json['thumb_image'] ?? []
        ,json['status'] ?? 0
        ,json['featured'] ?? 0,
        json['_id'] ?? '',
        json['prod_strikeout_price']?? '0.0'
        ,json['isLiked'] ?? 0,
        json['rating_average'] ?? '0.0',
        json['rating_user_count'] ?? 0,
        json['pro_subtitle'] ?? '',
    );
  }

}



