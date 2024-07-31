import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/UserModelVerify.dart';
import '../utils/AppConstant.dart';
import '../utils/SharedPref.dart';


class LoginDataPresenter{
  late Dio _dio = Dio();
  SharedPref sharePrefs = SharedPref();

  Future<String> loginApi(BuildContext context,String email,String pass,firebase_token) async {


    var formData = FormData.fromMap({
      AppConstant.uemail: email,
      AppConstant.firebase_token : firebase_token,
      AppConstant.pwd: pass
    });
    print("AppConstant.BaseUrl--"+AppConstant.BaseUrl);
    if(AppConstant.BaseUrl.replaceAll("/api/", "").isEmpty){

      Fluttertoast.showToast(
          msg: 'URL Not found !',
          toastLength:
          Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor:
          Colors.grey,
          textColor:
          Color(ColorConsts.whiteColor),
          fontSize: 14.0);
      return '';
    }

    Response<String> response = await _dio.post(AppConstant.BaseUrl+AppConstant.API_LOGIN, data: formData);


      if (response.statusCode == 200) {
        final Map parsed = json.decode(response.data.toString());
        if(parsed['status'].toString().contains('1')){
          sharePrefs.setLoginUserData(response.data.toString());
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

    Fluttertoast.showToast(
    msg: 'Something went wrong !',
    toastLength:
    Toast.LENGTH_SHORT,
    timeInSecForIosWeb: 1,
    backgroundColor:
    Colors.grey,
    textColor:
    Color(ColorConsts.whiteColor),
    fontSize: 14.0);

        return '';
      }

  }
}

