class ModelOrderDetails
{
  int status;
  String message;
  List<orderDetailsData>  data;

  ModelOrderDetails(this.status, this.message, this.data);
  factory ModelOrderDetails.fromJson(Map<dynamic, dynamic> json) {
    return ModelOrderDetails(json['status'], json['message'], List<orderDetailsData>.from(json["data"].map((x) => orderDetailsData.fromJson(x))));
  }}

class orderDetailsData {
  String id = "";
  String order_id = "";
  int order_amount ;
  String shipping_address = "";
  String billing_address = "";
  String createdAt ="";
  String updatedAt ="";
  String order_uniqueid ="";
  int order_status ;
  int payment_status ;
  String payment_mode ;


  orderDetailsData(
      this.id,
      this.order_id,
      this.order_amount,
      this.shipping_address,
      this.billing_address,
      this.createdAt,
      this.updatedAt,
      this.order_uniqueid,
      this.order_status,
      this.payment_status,
      this.payment_mode);

  factory orderDetailsData.fromJson(Map<String, dynamic> json) {
    return orderDetailsData(
      json['_id'] ?? '',
      json['order_id'] ?? '',
      json['order_amount'] ?? 0,
      json['shipping_address'] ?? '',
      json['billing_address'] ?? '',
      json['createdAt'] ?? '',
      json['updatedAt'] ?? '',
      json['order_uniqueid'] ?? '',
      json['order_status'] ?? '',
      json['payment_status'] ?? '',
      json['payment_mode'] ?? '',);
  }

}



