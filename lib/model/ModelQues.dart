class ModelQues {
  int status;
  String message;
  List<quesData> data;

  ModelQues({
    this.status = 0, // Default value
    this.message = '', // Default value
    this.data = const [], // Default value
  });

  factory ModelQues.fromJson(Map<String, dynamic> json) {
    return ModelQues(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: List<quesData>.from(
          (json['data'] ?? []).map((x) => quesData.fromJson(x))
      ),
    );
  }
}

class quesData {
  String question;
  String question_uname;
  String answer;
  String createdAt;
  int status;
  String id;

  quesData({
    this.question = '', // Default value
    this.question_uname = '', // Default value
    this.answer = '', // Default value
    this.createdAt = '0', // Default value
    this.status = 0, // Default value
    this.id = '', // Default value
  });

  factory quesData.fromJson(Map<String, dynamic> json) {
    return quesData(
      question: json['question'] ?? '',
      question_uname: json['question_uname'] ?? '',
      answer: json['answer'] ?? '',
      createdAt: json['createdAt'] ?? '0',
      status: json['status'] ?? 0,
      id: json['_id'] ?? '',
    );
  }
}
