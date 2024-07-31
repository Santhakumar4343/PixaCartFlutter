class ModelSubCategory {

  int status;
  String message;
  List<CategorySubData>  data;

  ModelSubCategory(this.status, this.message, this.data);
  factory ModelSubCategory.fromJson(Map<dynamic, dynamic> json) {
    return ModelSubCategory(json['status'], json['message'], List<CategorySubData>.from(json["data"].map((x) => CategorySubData.fromJson(x))));
  }}

class CategorySubData {
  String cate_name = "";
  String cate_image = "";
  String createdAt ="";
  String updatedAt ="";
  int status;
  String id ="";
  String parent_id ="";

  CategorySubData(this.cate_name, this.cate_image,
      this.createdAt, this.updatedAt, this.status, this.id, this.parent_id);

  factory CategorySubData.fromJson(Map<String, dynamic> json) {
    return CategorySubData(json['cate_name'] ?? '',json['cate_image'] ?? ''
        ,json['createdAt'] ?? '',json['updatedAt'] ?? '',json['status'] ?? 0,json['_id'] ?? '',json['parent_id'] ?? '');
  }

}



