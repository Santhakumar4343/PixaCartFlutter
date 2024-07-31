import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/UserModelVerify.dart';
import '../utils/AppConstant.dart';
import '../utils/SharedPref.dart';


class OTPVerifyPresenter{
  late Dio _dio = Dio();
  SharedPref sharePrefs = SharedPref();

  Future<String> getVerify(BuildContext context,String otp,String user_id) async {


    var formData = FormData.fromMap({
      AppConstant.user_id: user_id,
      AppConstant.otp: otp
    });

    Response<String> response = await _dio.post(AppConstant.BaseUrl+AppConstant.API_VERIFY_OTP, data: formData);
    try {

      if (response.statusCode == 200) {
        final Map parsed = json.decode(response.data.toString());
        if(parsed['status'].toString().contains('1')){
      sharePrefs.setLoginUserData('$response');
          return response.toString();
        }else{
          Fluttertoast.showToast(
              msg: parsed['message'],
              toastLength:
              Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              backgroundColor:
              Colors.grey,
              textColor:
              Color(ColorConsts.whiteColor),
              fontSize: 14.0);


        return '';}
      } else {


        return "";
      }
    } catch (error, stacktrace) {


      return throw UnimplementedError();

    }
  }
}

