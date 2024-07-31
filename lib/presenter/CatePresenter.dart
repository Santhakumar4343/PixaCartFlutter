import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_com/model/ModelCategory.dart';
import 'package:e_com/model/ModelSubCategory.dart';
import 'package:e_com/utils/AppConstant.dart';

class CatePresenter {


  Future<ModelCategory> getCatList(
     String token) async {

    var formData = FormData.fromMap({
      AppConstant.start: 0,
      AppConstant.limit: 1000
    });
    Dio _dio = Dio();
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_GET_CATEGORIES, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));
_dio.close(force: true);
      if (response.statusCode == 200) {

        final Map<String,dynamic> parsed = json.decode(response.data.toString());


        return ModelCategory.fromJson(parsed);
      } else {

        final Map<String,dynamic> parsed = json.decode(response.data.toString());
        return ModelCategory.fromJson(parsed);;
      }

  }

  Future<ModelSubCategory> getSubCatList(
      String token,String cateId) async {

    var formData = FormData.fromMap({
      AppConstant.start: 0,
      AppConstant.limit: 1000,
      AppConstant.cate_id: cateId
    });
    Dio _dio = Dio();
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_GETSUBCATEGORIES, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));
    _dio.close(force: true);

    if (response.statusCode == 200) {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());


      return ModelSubCategory.fromJson(parsed);
    } else {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelSubCategory.fromJson(parsed);
    }

  }


}


