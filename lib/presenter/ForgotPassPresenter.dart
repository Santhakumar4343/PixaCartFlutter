import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/UserModelVerify.dart';
import '../utils/AppConstant.dart';
import '../utils/SharedPref.dart';


class ForgotPassPresenter{
  late Dio _dio = Dio();
  SharedPref sharePrefs = SharedPref();

  Future<String> getForgPass(BuildContext context,String mobileEmail,String password) async {


    var formData = FormData.fromMap({

      AppConstant.forgot_email_mobile: mobileEmail,
      "user_pwd": password
    });
    Response<String> response = await _dio.post(AppConstant.BaseUrl+AppConstant.FORGOT_PASSWORD, data: formData);

    try {

      if (response.statusCode == 200) {
        final Map parsed = json.decode(response.data.toString());
        if(!parsed['message'].toString().contains("The account Found")){
        Fluttertoast.showToast(
            msg: parsed['message'],
            toastLength:
            Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor:
            Colors.grey,
            textColor:
            Color(ColorConsts.whiteColor),
            fontSize: 14.0);}
        if(parsed['status'].toString().contains('1')){

          return response.toString();
        }else{
        return '';}
      } else {
        Fluttertoast.showToast(
            msg:'Something went wrong!',
            toastLength:
            Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor:
            Colors.grey,
            textColor:
            Color(ColorConsts.whiteColor),
            fontSize: 14.0);

        return "";
      }
    } catch (error, stacktrace) {

      Fluttertoast.showToast(
          msg:'Error',
          toastLength:
          Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor:
          Colors.grey,
          textColor:
          Color(ColorConsts.whiteColor),
          fontSize: 14.0);
      return throw UnimplementedError();

    }
  }
}

