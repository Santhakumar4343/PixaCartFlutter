import 'package:e_com/model/ModelBrand.dart';
import 'package:e_com/model/ModelSettings.dart';
import 'package:e_com/utils/AppConstant.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_com/utils/SharedPref.dart';

class PaymetDetailPresenter{

  late Dio _dio = Dio();
  SharedPref sharePrefs = SharedPref();

  Future<ModelSettings> get(
      String token) async {

    Response<String> response = await _dio.get(
        AppConstant.BaseUrl + AppConstant.API_GETPAYMENTGATEWAYSDETAILS,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));
print('  -------->> '+response.toString());

    if (response.statusCode == 200) {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());

      if(parsed['status'].toString().contains('1')){
        sharePrefs.setSettingsData(response.data.toString());
      }
      return ModelSettings.fromJson(parsed);
    } else {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelSettings.fromJson(parsed);
    }

  }
}