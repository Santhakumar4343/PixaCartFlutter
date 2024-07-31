class ModelReviews {

  int status;
  String message;
  List<RevData>  data;

  ModelReviews(this.status, this.message, this.data);
  factory ModelReviews.fromJson(Map<dynamic, dynamic> json) {
    return ModelReviews(json['status'], json['message'], List<RevData>.from(json["data"].map((x) => RevData.fromJson(x))));
  }}

class RevData {
  String review_id = "";
  String prod_name = "";
  String rating_uname = "";
  String rating_user_image = "";
  String rating_pid = "";
  String rating_uid = "";
  String review = "";
  String createdAt = "";

  int rating ;
  List prod_image ;
  List thumb_image ;
  int rating_user_count;
  int status;
  String id ="";
  String rating_average ;
  int isLiked;
  int featured;

  String prod_unitprice ="";
  String prod_strikeout_price ="";
  int prod_quantity ;
  String prod_discount_type ="";
  String prod_discount ;
  String variant_id ;
  int helpful_count ;



  RevData(
      this.review_id,
      this.prod_name,
      this.rating_uname,
      this.rating_user_image,
      this.rating_pid,
      this.rating_uid, this.review, this.createdAt,
       this.rating, this.prod_image, this.thumb_image,
      this.rating_user_count, this.status, this.id,
      this.rating_average, this.isLiked, this.featured, this.prod_unitprice,
      this.prod_strikeout_price, this.prod_quantity, this.prod_discount_type, this.prod_discount,this.variant_id,this.helpful_count);

  factory RevData.fromJson(Map<String, dynamic> json) {
    return RevData(json['review_id'] ?? ''
        ,json['prod_name'] ?? ''
        ,json['rating_uname'] ?? ''
        ,json['rating_user_image'] ?? ''
        ,json['rating_pid'] ?? 0,json['rating_uid'] ?? '',json['review'] ?? '',json['createdAt'] ?? ''
        ,json['rating'] ?? '',json['prod_image'] ?? '',json['thumb_image'] ?? []
        ,json['rating_user_count'] ?? 0
        ,json['status'] ?? 0,json['_id'] ?? '',json['rating_average'] ?? 0.0,json['isLiked'] ?? 0
        ,json['featured'] ?? 0
        ,json['prod_unitprice'] ?? ''
        ,json['prod_strikeout_price'] ?? ''
        ,json['prod_quantity'] ?? 0
        ,json['prod_discount_type'] ?? ''
        ,json['prod_discount'] ?? 0
        ,json['variant_id'] ?? ''
        ,json['helpful_count'] ?? 0

    );
  }

}



