import 'package:e_com/model/ModelBrand.dart';
import 'package:e_com/model/ModelOrder.dart';
import 'package:e_com/model/ModelOrderDetails.dart';
import 'package:e_com/utils/AppConstant.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



class OrderPresenter{




  Future<ModelOrder> getOrderList(
      String token,userId) async {


    var formData = FormData.fromMap({
      AppConstant.start: 0,
      AppConstant.limit: 1000
      ,AppConstant.user_id:userId
    });
    Dio dio = await Dio();
    Response<String> response = await dio.post(
        AppConstant.BaseUrl + AppConstant.API_GETMYORDERPRODUCTS, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        )
        );

    if (response.statusCode == 200) {

      Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelOrder.fromJson(parsed);
    } else {

      Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelOrder.fromJson(parsed);
    }

  }



  Future<ModelOrderDetails> getOrderDetails(String token,userId,orderId) async {

    var formData = FormData.fromMap({
      AppConstant.start: 0,
      AppConstant.limit: 1000
      ,AppConstant.user_id:userId
      ,AppConstant.order_id:orderId
    });
    Dio _dio = Dio();
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_GETMYORDERS, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));



    if (response.statusCode == 200) {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelOrderDetails.fromJson(parsed);
    } else {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelOrderDetails.fromJson(parsed);
    }

  }
  Future<String> getOrderCancel(String token,String sub_orderid,String cancel_reason,String order_status) async {

    var formData = FormData.fromMap({
      "sub_orderid": sub_orderid,
      "cancel_reason": cancel_reason,
      "order_status": order_status

    });
    Dio _dio = Dio();
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_CANCELORDER, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));


    final Map<String,dynamic> parsed = json.decode(response.data.toString());
    Fluttertoast
        .showToast(
        msg: parsed["message"],
        toastLength: Toast
            .LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors
            .grey,
        textColor:
        Color(ColorConsts.whiteColor),
        fontSize: 14.0);
    if (response.statusCode == 200) {



      if(parsed['status'].toString().contains('1')){
        return '1';
      }
      return '0';
    } else {


      return '0';
    }
  }

  Future<String> getOrderPlace(
      String token,userId,total_amount,shipping_address,billing_address,payment_mode,payment_status,products_details,payment_details) async {

    var formData = FormData.fromMap({
      AppConstant.total_amount: total_amount,
      AppConstant.shipping_address: shipping_address
      ,AppConstant.user_id:userId
      ,AppConstant.billing_address :billing_address
      ,AppConstant.payment_mode:payment_mode
      ,AppConstant.payment_status:payment_status
      ,AppConstant.products_details:products_details
      ,AppConstant.payment_details:payment_details
    });
    Dio _dio = Dio();
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_PLACEMYORDER, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));
          print('-------$response');
  _dio.close(force: true);
    if (response.statusCode == 200) {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      if(parsed['status'].toString().contains('1')){
        return '1';
      }
      return '0';
    } else {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return '0';
    }

  }
}