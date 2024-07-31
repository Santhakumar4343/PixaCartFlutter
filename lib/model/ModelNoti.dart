class ModelNoti {

  int status;
  String message;
  List<NotiData>  data;

  ModelNoti(this.status, this.message, this.data);
  factory ModelNoti.fromJson(Map<dynamic, dynamic> json) {
    return ModelNoti(json['status'], json['message'], List<NotiData>.from(json["data"].map((x) => NotiData.fromJson(x))));
  }}

class NotiData {
  String noti_id = "";
  String noti_msg = "";
  String noti_date = "";
  int noti_type;
  int noti_status;
  String ticket_id ="";
  String order_id ="";
  int order_status ;


  NotiData(this.noti_id, this.noti_msg, this.noti_date, this.noti_type,
      this.noti_status,
      this.ticket_id,
      this.order_id,
      this.order_status);

  factory NotiData.fromJson(Map<String, dynamic> json) {
    return NotiData(
        json['noti_id'] ?? '',
        json['noti_msg'] ?? '',
        json['noti_date'] ?? '',
        json['noti_type'] ?? 0,
        json['noti_status'] ?? 0
        ,json['ticket_id'] ?? ''
        ,json['order_id'] ?? ''
        ,json['order_status'] ?? ''
    );
  }

}



