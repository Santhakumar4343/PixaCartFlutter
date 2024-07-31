import 'dart:convert';

import 'package:e_com/model/UserModelVerify.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/AppConstant.dart';

import 'package:dio/dio.dart';

class SignupPresenter{
  late Dio _dio = Dio();


  Future<UserModel> getRegister(BuildContext context,String name,String email,String pass,String mobileNum,firebase_token) async {

    RegExp _numeric = RegExp(r'^-?[0-9]+$');
    if(_numeric.hasMatch(mobileNum)){
      email='';
    }else{
     mobileNum='';
    }

    var formData = FormData.fromMap({
      AppConstant.uname: ''+name,
      AppConstant.uemail: ''+email,
      AppConstant.mobile: ''+mobileNum,
      AppConstant.pwd: ''+pass,
      AppConstant.firebase_token: ''+firebase_token,
    });

    Response response = await _dio.post(AppConstant.BaseUrl+AppConstant.API_SIGNUP, data: formData);


      if (response.statusCode == 200) {


        final Map parsed = json.decode(response.toString());


        Fluttertoast.showToast(
            msg: parsed['message'],
            toastLength: Toast
                .LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor:
            Color(ColorConsts.whiteColor),
            fontSize: 14.0);
        if(parsed["status"].toString().contains("1")){
          return UserModel.fromJson(parsed);
        }else {
          return UserModel(0,"",new UserData(0, "fullname", "email", 'mobile', "profile_image", '_id', "id", "createdAt", 0, "updatedAt", "verify_otp"));
        }

      } else {

        Fluttertoast.showToast(
            msg: 'Something went wrong',
            toastLength: Toast
                .LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor:
            Color(ColorConsts.whiteColor),
            fontSize: 14.0);

        final Map parsed = json.decode(response.toString());
        return UserModel.fromJson(parsed);
      }

  }
}
