import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_com/model/ModelMostSoldProduct.dart';
import 'package:e_com/model/ModelSearch.dart';
import 'package:e_com/utils/AppConstant.dart';
import 'package:e_com/model/ModelProduct.dart';
class SearchPresenter{


  Future<ModelSearch> get(
      String token,length,search_keyword) async {
   Dio dio = new Dio();
   Response<String> response ;
    var formData = FormData.fromMap({
      AppConstant.start: 0,
      AppConstant.limit: length,
      AppConstant.search_keyword: search_keyword,
    });
 response = await dio.post(
        AppConstant.BaseUrl + AppConstant.API_SEARCHPRODUCTS, data: formData,
        options: Options(headers: {
          "authorization": "" + token}
        ));

    if (response.statusCode == 200) {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());

      return ModelSearch.fromJson(parsed);
    } else {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelSearch.fromJson(parsed);;
    }

  }


  Future<ModelProduct> getSearchContent(
      String token,length,search_keyword) async {
    Dio dio = new Dio();
    Response<String> response ;

    var formData = FormData.fromMap({
      AppConstant.start: 0,
      AppConstant.limit: length,
      AppConstant.search_keyword: search_keyword,
    });
    response = await dio.post(
        AppConstant.BaseUrl + AppConstant.API_GETMYSEARCHCONTENT, data: formData,
        options: Options(headers: {
          "authorization": "" + token}
        ));

    if (response.statusCode == 200) {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());

      return ModelProduct.fromJson(parsed);
    } else {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelProduct.fromJson(parsed);;
    }

  }
}