import 'package:e_com/model/ModelBrand.dart';
import 'package:e_com/utils/AppConstant.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class BrandPresenter{

  late Dio _dio = Dio();
  Future<ModelBrand> getList(
      String token) async {

    var formData = FormData.fromMap({
      AppConstant.start: 0,
      AppConstant.limit: 1000
    });
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_GETBRANDS, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));


    if (response.statusCode == 200) {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelBrand.fromJson(parsed);
    } else {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelBrand.fromJson(parsed);;
    }

  }
}