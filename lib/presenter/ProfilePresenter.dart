import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/AppConstant.dart';
import '../utils/SharedPref.dart';


class ProfilePresenter{
  late Dio _dio = Dio();
  SharedPref sharePrefs = SharedPref();

  Future<UserLoginModel> updateApi(BuildContext context,String token,String user_id,File file,String email,String uname,
      String mobile,String pwd
      ,String address
      ,String city
      ,String state
      ,String country
      ,String code
      ) async {


    var formData ;
    if(file.path.isNotEmpty) {

      formData = FormData.fromMap({
        AppConstant.users_image: await MultipartFile.fromFile(
            file.path, filename: 'saloni'),
        AppConstant.user_id: user_id,
        AppConstant.uemail: email,
        AppConstant.uname: uname,
        AppConstant.mobile: mobile,
        AppConstant.pwd: pwd,
        AppConstant.address: address,
        "city": city,
        "state": state,
        "country": country,
        "postal_code": code
      });
    }else{

      formData = FormData.fromMap({
        AppConstant.user_id: user_id,
        AppConstant.uemail: email,
        AppConstant.uname: uname,
        AppConstant.mobile: mobile,
        AppConstant.pwd: pwd,
        AppConstant.address: address,
        "city": city,
        "state": state,
        "country": country,
        "postal_code": code
      });
    }

    Response<String> response = await _dio.post(AppConstant.BaseUrl+AppConstant.API_UPDATEPROFILE, data: formData, options: Options(headers: {

      "authorization": "" + token
    }
    ));

    try {

      if (response.statusCode == 200) {
        final Map parsed = json.decode(response.data.toString());
        if(parsed['status'].toString().contains('1')) {
          sharePrefs.setLoginUserData('$response');
        }
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


        return UserLoginModel.fromJson(parsed);
      } else {
        final Map parsed = json.decode(response.data.toString());
        return UserLoginModel.fromJson(parsed);
      }
    } catch (error, stacktrace) {

      return throw UnimplementedError();

    }
  }
}

