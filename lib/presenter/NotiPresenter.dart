import 'package:e_com/model/ModelBrand.dart';
import 'package:e_com/model/ModelNoti.dart';
import 'package:e_com/utils/AppConstant.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class NotiPresenter{

  late Dio _dio = Dio();
  Future<ModelNoti> getList(String token,userId) async {

    var formData = FormData.fromMap({
      AppConstant.start: 0,
      AppConstant.limit: 1000,
      AppConstant.user_id: userId
    });
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_GETNOTIFICATIONS, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));


    if (response.statusCode == 200) {
      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelNoti.fromJson(parsed);
    } else {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelNoti.fromJson(parsed);;
    }

  }
}