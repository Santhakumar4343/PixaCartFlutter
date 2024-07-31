class ModelCategory {

  int status;
  String message;
  List<CategoryData>  data;

  ModelCategory(this.status, this.message, this.data);
  factory ModelCategory.fromJson(Map<dynamic, dynamic> json) {
    return ModelCategory(json['status'], json['message'], List<CategoryData>.from(json["data"].map((x) => CategoryData.fromJson(x))));
  }}

class CategoryData {
  String cate_name = "";
  String cate_image = "";
  String createdAt ="";
  String updatedAt ="";
  int status;
  String id ="";


  CategoryData(this.cate_name, this.cate_image,
      this.createdAt, this.updatedAt, this.status, this.id);

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(json['cate_name'] ?? '',json['cate_image'] ?? ''
        ,json['createdAt'] ?? '',json['updatedAt'] ?? '',json['status'] ?? 0,json['_id'] ?? '');
  }

}



