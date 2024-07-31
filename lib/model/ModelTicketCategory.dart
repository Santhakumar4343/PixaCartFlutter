class ModelTicketCategory{
  int status;
  String message;
  List<CategoryData>  data;

  ModelTicketCategory(this.status, this.message, this.data);
  factory ModelTicketCategory.fromJson(Map<dynamic, dynamic> json) {
    return ModelTicketCategory(json['status'], json['message'], List<CategoryData>.from(json["data"].map((x) => CategoryData.fromJson(x))));
  }}


class CategoryData {
  String id ="";
  String sp_catename ="";

  CategoryData(this.id, this.sp_catename);
  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(json['_id'] ?? '',json['sp_catename'] ?? '');
  }

}