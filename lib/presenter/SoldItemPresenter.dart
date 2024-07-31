import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_com/model/ModelMostSoldProduct.dart';
import 'package:e_com/utils/AppConstant.dart';
import 'package:http/http.dart' as http;

class SoldItemPresenter {
  Future<dynamic> getMostSoldProductList(String token, int length) async {

    await Future.delayed(Duration(seconds: 4));


    Dio d = new Dio();

    Response<String> responsee;
    var formData = FormData.fromMap({
      AppConstant.start: 0,
      AppConstant.limit: length,
    });
    responsee = await d.post(
        AppConstant.BaseUrl + AppConstant.API_GETMOSTSOLDPRODUCTS,
        data: formData,
        options: Options(headers: {
          "authorization": "" + token}
        )
    );


    if (responsee.statusCode == 200) {
      final Map<String, dynamic> parsed = json.decode(
          responsee.data.toString());

      return ModelMostSoldProduct.fromJson(parsed);
    } else {
      final Map<String, dynamic> parsed = json.decode(
          responsee.data.toString());
      return ModelMostSoldProduct.fromJson(parsed);;
    }
  }
}
