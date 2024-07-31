class ModelSearch {

  int status;
  String message;
  List<SearchData>  data;

  ModelSearch(this.status, this.message, this.data);
  factory ModelSearch.fromJson(Map<dynamic, dynamic> json) {
    return ModelSearch(json['status'], json['message'], List<SearchData>.from(json["data"].map((x) => SearchData.fromJson(x))));
  }}

class SearchData {
  String name = "";
  String type = "";



  SearchData(this.name, this.type);

  factory SearchData.fromJson(Map<String, dynamic> json) {
    return SearchData(json['name'] ?? '',json['type'] ?? '');
  }

}



