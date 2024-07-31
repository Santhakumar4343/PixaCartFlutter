class ModelMostSoldProduct {

  int status;
  String message;
  List<MostSoldData>  data;

  ModelMostSoldProduct(this.status, this.message, this.data);
  factory ModelMostSoldProduct.fromJson(Map<dynamic, dynamic> json) {
    return new  ModelMostSoldProduct(json['status'], json['message'],new List<MostSoldData>.from(json["data"].map((x) => MostSoldData.fromJson(x))));
  }}

class MostSoldData {
  String variant_id = "";
  String prod_sellerid = "";
  String prod_name = "";
  String prod_unit ="";
  String prod_unitprice;
  String prod_strikeout_price;
  String prod_discount ;
  String prod_discount_type ="";
  int prod_quantity =0;
  int status;
  int isLiked;
  String rating_average;
  int rating_user_count;
  int featured;
  String id ="";
  List prod_image =[];
  List thumb_image=[] ;
  String pro_subtitle ="";


  MostSoldData(
      this.variant_id, this.prod_sellerid, this.prod_name,
      this.prod_unit, this.prod_unitprice, this.prod_discount, this.prod_discount_type,
      this.prod_quantity, this.status, this.featured, this.id,
      this.prod_strikeout_price,this.isLiked,this.rating_average,this.rating_user_count, this.prod_image,
  this.thumb_image,this.pro_subtitle);

  factory MostSoldData.fromJson(Map<String, dynamic> json) {
    return new MostSoldData(
        json['variant_id'] ?? ''
        , json['prod_sellerid'] ?? ''
        , json['prod_name'] ?? ''
        ,json['prod_unit'] ?? ''
        ,json['prod_unitprice'] ?? '0.0'
        ,json['prod_discount'] ?? '0'
        ,json['prod_discount_type'] ?? ''
        ,json['prod_quantity'] ?? 0
        ,json['status'] ?? 0
        ,json['featured'] ?? 0,
        json['_id'] ?? '',
        json['prod_strikeout_price']?? '0.0'
        ,json['isLiked'] ?? 0,
        json['rating_average'] ?? '0.0',
        json['rating_user_count'] ?? 0
        ,json['prod_image'] ?? []
        ,json['thumb_image'] ?? []
        ,json['pro_subtitle'] ?? '',
    );
  }

}



