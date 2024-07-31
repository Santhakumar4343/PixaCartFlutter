class ModelTickets{
  int status;
  String message;
  List<TicData>  data;

  ModelTickets(this.status, this.message, this.data);
  factory ModelTickets.fromJson(Map<dynamic, dynamic> json) {
    return ModelTickets(json['status'], json['message'], List<TicData>.from(json["data"].map((x) => TicData.fromJson(x))));
  }}


class TicData {
  String id ="";
  String ticket_uniqueid ="";
  String subject ="";
  String createdAt ="";
  String ticket_sellerid ="";
  int status ;

  TicData(this.id, this.ticket_uniqueid,this.subject,this.createdAt,this.status,this.ticket_sellerid);
  factory TicData.fromJson(Map<String, dynamic> json) {
    return TicData(json['_id'] ?? ''
        ,json['ticket_uniqueid'] ?? ''
        ,json['subject'] ?? ''
        ,json['createdAt'] ?? ''
        ,json['status'] ?? 0
        ,json['ticket_sellerid'] ?? ''
    );
  }

}