class ModelReviewGraph{
  int status;
  String message;
  revData  data;

  ModelReviewGraph(this.status, this.message, this.data);
  factory ModelReviewGraph.fromJson(Map<dynamic, dynamic> json) {
    return ModelReviewGraph(json['status'], json['message'], new revData.fromJson(json['data']));
  }
}
class revData {
  dynamic averageRating;
  int totalRatings;
  int totalReviews;
  RatingInPercantage ratingInPercantage;

  revData(this.averageRating, this.totalRatings, this.totalReviews,
      this.ratingInPercantage);
  factory revData.fromJson(Map<dynamic, dynamic> json) {
    return revData(json['averageRating'] ?? '', json['totalRatings'] ?? 0, json['totalReviews'] ?? 0, new RatingInPercantage.fromJson(json['ratingInPercantage'] ?? {}));
  }

}
class RatingInPercantage{
int one;
int two;
int three;
int four;
int five;

RatingInPercantage(this.one, this.two, this.three, this.four,
    this.five);

factory RatingInPercantage.fromJson(Map<dynamic, dynamic> json) {
  return RatingInPercantage(json['1'], json['2'], json['3'], json['4'], json['5']   );
}




}