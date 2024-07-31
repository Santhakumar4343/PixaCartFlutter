class ModelOrder
{

  int status;
  String message;
  List<orderData>  data;

  ModelOrder(this.status, this.message, this.data);
  factory ModelOrder.fromJson(Map<dynamic, dynamic> json) {
    return ModelOrder(json['status'], json['message'], List<orderData>.from(json["data"].map((x) => orderData.fromJson(x))));
  }}
class trackData {
  String orderProcess = "";
  String ready_to_ship = "";
  String local_ware_house = "";
  String order_deliver_on = "";

  trackData(this.orderProcess, this.ready_to_ship, this.local_ware_house,
      this.order_deliver_on);

  factory trackData.fromJson(Map<dynamic, dynamic> json) {
    return trackData(json['orderProcess']
        , json['ready_to_ship']
        , json['local_ware_house']
        , json['order_deliver_on']
    );}
  }


class orderData {
  String order_id = "";
  String sub_orderid = "";
  String prod_sellerid = "";
  String id = "";
  int order_qty ;
  String order_date = "";
  String prod_attributes = "";
  String pro_subtitle = "";
  String prod_name = "";
  String prod_unit ="";
  String prod_unitprice;
  String prod_strikeout_price;
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
  String createdAt ="";
  String updatedAt ="";
  String order_uniqueid ="";
  int order_status ;
  trackData tracking;


  orderData(
      this.order_id,
      this.sub_orderid,
      this.prod_sellerid,
      this.id,
      this.order_qty,
      this.order_date,
      this.prod_attributes,
      this.pro_subtitle,

      this.prod_name,
      this.prod_unit,
      this.prod_unitprice,
      this.prod_strikeout_price,

      this.prod_discount,
      this.prod_discount_type,
      this.prod_quantity,
      this.prod_image,
      this.thumb_image,
      this.status,
      this.isLiked,
      this.rating_average,
      this.rating_user_count,
      this.featured,
      this.createdAt,
      this.updatedAt,this.order_uniqueid,this.order_status,this.tracking);

  factory orderData.fromJson(Map<String, dynamic> json) {
    return orderData(
      json['order_id'] ?? '',
      json['sub_orderid'] ?? '',
      json['prod_sellerid'] ?? '',
      json['_id'] ?? '',
      json['order_qty'] ?? '',
      json['order_date'] ?? '',
      json['prod_attributes'] ?? '',
      json['pro_subtitle'] ?? '',

      json['prod_name'] ?? '',
      json['prod_unit'] ?? '',
      json['prod_unitprice'] ?? '',
      json['prod_strikeout_price'] ?? '',

      json['prod_discount'] ?? '',
      json['prod_discount_type'] ?? '',
      json['prod_quantity'] ?? '',
      json['prod_image'] ?? '',
      json['thumb_image'] ?? '',
      json['status'] ?? '',
      json['isLiked'] ?? '',
      json['rating_average'] ?? '',
      json['rating_user_count'] ?? 0,
      json['featured'] ?? '',
      json['createdAt'] ?? '',
      json['updatedAt'] ?? '',
      json['order_uniqueid'] ?? '',
      json['order_status'] ?? ''
        ,new trackData.fromJson(json['tracking'])
    );
  }

}



