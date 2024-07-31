import 'package:e_com/model/ModelBrand.dart';
import 'package:e_com/model/ModelQues.dart';
import 'package:e_com/model/ModelReviewGraph.dart';
import 'package:e_com/utils/AppConstant.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/ModelReviews.dart';
import '../utils/color_const.dart';

class ReviewPresenter{

  late Dio _dio = Dio();
  Future<ModelReviews> getList(String token) async {

    var formData = FormData.fromMap({
      AppConstant.start: 0,
      AppConstant.limit: 1000
    });
Dio dio = Dio();
    Response<String> response = await dio.post(
        AppConstant.BaseUrl + AppConstant.API_GETPRODUCTSREVIEWS, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));

dio.close(force: true);
    if (response.statusCode == 200) {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelReviews.fromJson(parsed);
    } else {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelReviews.fromJson(parsed);;
    }

  }
  Future<ModelReviews> getListWithProId(String token,String proId,String useId) async {

    var formData = FormData.fromMap({
      AppConstant.start: 0,
      AppConstant.limit: 1000,
      AppConstant.product_id: proId,
      AppConstant.user_id: useId
    });
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_GETPRODUCTSREVIEWS, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));


    if (response.statusCode == 200) {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());

      return ModelReviews.fromJson(parsed);
    } else {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelReviews.fromJson(parsed);;
    }

  }
  Future<String> reviewHelpfulCount(String token,String review_id) async {

    var formData = FormData.fromMap({
      AppConstant.review_id: review_id,
    });
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_REVIEWHELPFULCOUNT, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));
    final Map<String,dynamic> parsed = json.decode(response.data.toString());
    Fluttertoast.showToast(
        msg: ''+parsed['message'],
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Color(ColorConsts.whiteColor),
        fontSize: 14.0);

    if (response.statusCode == 200) {



      return '1';
    } else {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return '0';;
    }

  }
  Future<String> sendQues(String token,String user_id,String prod_id,String seller_id,String text) async {

    var formData = FormData.fromMap({
      AppConstant.user_id: user_id,
      AppConstant.prod_id: prod_id,
      AppConstant.seller_id: seller_id,
      AppConstant.question: text,
    });
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.SENDCUSTOMERQUESTION, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));


    if (response.statusCode == 200) {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      if(parsed["status"] == 1 ){
      return '1';}else{
        return "0";
      }
    } else {
      return '0';
    }

  }
  Future<ModelQues> getQues(String token,String proId) async {

    var formData = FormData.fromMap({
      AppConstant.prod_id: proId,
    });
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_getCustomerQuestions, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));


    if (response.statusCode == 200) {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());

      return ModelQues.fromJson(parsed);
    } else {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelQues.fromJson(parsed);
    }

  }
  Future<ModelReviewGraph> getAverageRating(String token,String proId) async {

    var formData = FormData.fromMap({
      AppConstant.prod_id: proId,
    });
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_GETAVERAGERATING, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));


    if (response.statusCode == 200) {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());

      return ModelReviewGraph.fromJson(parsed);
    } else {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelReviewGraph.fromJson(parsed);
    }

  }

  Future<String> doReview(String token,String user_id,String pro_id,String prod_rating,String prod_review) async {

    var formData = FormData.fromMap({
      AppConstant.user_id: user_id,
      AppConstant.product_id: pro_id,
      AppConstant.prod_rating: prod_rating,
      AppConstant.prod_review: prod_review
    });
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_DORATINGS, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));


    if (response.statusCode == 200) {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());

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
      return '1';
    } else {


      return '0';
    }

  }
}