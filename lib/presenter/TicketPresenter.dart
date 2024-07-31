import 'package:e_com/model/ModelTicketCategory.dart';
import 'package:e_com/model/ModelTickets.dart';
import 'package:e_com/model/ModelTicketsReply.dart';
import 'package:e_com/utils/AppConstant.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/color_const.dart';

class TicketPresenter{
  late Dio _dio = Dio();
  Future<String> addTicket(
      String token,sub_order_id,uid,subject,categoryTicet,sellerId) async {

    var formData = FormData.fromMap({
      AppConstant.sub_order_id: sub_order_id,
      AppConstant.user_id: uid,
      AppConstant.subject: subject,
      "sp_cateid": categoryTicet,
     "seller_id": sellerId
    });
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_CREATESUPPORTTICKET, data: formData,
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


      return '0';;
    }

  }

  Future<ModelTicketCategory> getTicketCategory(
      String token) async {

    var formData = FormData.fromMap({
      "start": "0", "limit": "100"
    });
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_GETSUPPORTCATEGORLIST, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));
    if (response.statusCode == 200) {
      final Map<String, dynamic> parsed = json.decode(
          response.data.toString());

      return ModelTicketCategory.fromJson(parsed);
    } else {

      final Map<String, dynamic> parsed = json.decode(
          response.data.toString());
      return ModelTicketCategory.fromJson(parsed);;
    }

  }


  Future<ModelTickets> getTicket(
      String token,String userId) async {

    var formData = FormData.fromMap({
      "user_id": ""+userId,
    });
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_GETSUPPORTTICKET, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));

    if (response.statusCode == 200) {
      final Map<String, dynamic> parsed = json.decode(
          response.data.toString());

      return ModelTickets.fromJson(parsed);
    } else {

      final Map<String, dynamic> parsed = json.decode(
          response.data.toString());
      return ModelTickets.fromJson(parsed);;
    }

  }
  Future<ModelTicketsReply> getTicketReply(
      String token,String ticket_id) async {

    var formData = FormData.fromMap({
      "ticket_id": ""+ticket_id,
    });
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_GETSUPPORTTICKETREPLY, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));


    if (response.statusCode == 200) {
      final Map<String, dynamic> parsed = json.decode(
          response.data.toString());

      return ModelTicketsReply.fromJson(parsed);
    } else {

      final Map<String, dynamic> parsed = json.decode(
          response.data.toString());
      return ModelTicketsReply.fromJson(parsed);;
    }

  }
  Future<String> sendTicketReply(
      String token,String ticket_id,String sender_id,String receiver_id,String reply_msg) async {

    var formData = FormData.fromMap({
      "ticket_id": ""+ticket_id,
      "sender_id": ""+sender_id,
      "receiver_id": ""+receiver_id,
      "reply_msg": ""+reply_msg,
    });
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.SENDTICKETREPLY, data: formData,
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

      return '2';;
    }

  }
}