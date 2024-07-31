class ModelTicketsReply{
  int status;
  String message;
  List<TicRepData>  data;

  ModelTicketsReply(this.status, this.message, this.data);
  factory ModelTicketsReply.fromJson(Map<dynamic, dynamic> json) {
    return ModelTicketsReply(json['status'], json['message'], List<TicRepData>.from(json["data"].map((x) => TicRepData.fromJson(x))));
  }}


class TicRepData {
  String id ="";
  String ticket_id ="";
  String message ="";
  String createdAt ="";
  String sender_id ="";


  TicRepData(this.id, this.ticket_id,this.message,this.createdAt,this.sender_id);
  factory TicRepData.fromJson(Map<String, dynamic> json) {
    return TicRepData(json['_id'] ?? ''
        ,json['ticket_id'] ?? ''
        ,json['message'] ?? ''
        ,json['createdAt'] ?? ''

        ,json['sender_id'] ?? ''
    );
  }

}