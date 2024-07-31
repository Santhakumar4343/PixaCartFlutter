class ModelQues {

  int status;
  String message;
  List<quesData>  data;

  ModelQues(this.status, this.message, this.data);
  factory ModelQues.fromJson(Map<dynamic, dynamic> json) {
    return ModelQues(json['status'], json['message'], List<quesData>.from(json["data"].map((x) => quesData.fromJson(x))));
  }}

class quesData {
  String question = "";
  String question_uname = "";
  String answer = "";
  String createdAt = "";
  int status;
  String id ="";



  quesData(this.question,this.question_uname,this.answer, this.createdAt, this.status, this.id);

  factory quesData.fromJson(Map<String, dynamic> json) {
    return quesData(json['question'] ?? '',json['question_uname'],json['answer'] ?? ''
        ,json['createdAt'] ?? '0',json['status'] ?? 0,json['_id'] ?? '');
  }

}



