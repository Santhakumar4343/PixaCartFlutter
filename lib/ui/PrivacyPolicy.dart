import 'dart:convert';

import 'package:e_com/model/ModelSettings.dart';
import 'package:e_com/utils/SharedPref.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PrivacyPolicy extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
return PrivacyPolicyState();
  }

}

class PrivacyPolicyState extends State{

  String details='';
  late ModelSettings modelSettings ;
  SharedPref sharePrefs = SharedPref();
  getVal() async {
    String? sett = await sharePrefs.getSettings();
    final Map<String, dynamic> parsed = json.decode(sett!);
    modelSettings = ModelSettings.fromJson(parsed);
    details=modelSettings.data.privacy_policy_page;
    print(details);
    setState(() {

    });
  }

  @override
  void initState() {

    super.initState();
   getVal();
  }
  @override
  Widget build(BuildContext context) {
return SafeArea(child: Scaffold(

    resizeToAvoidBottomInset: true,
    body: Material(

    child: Container(
    height: MediaQuery.of(context).size.height,
  width: MediaQuery.of(context).size.width,
  color: Color(ColorConsts.whiteColor),
  child: Stack(children: [
      Container(
      height: 58,
      padding: EdgeInsets.all(0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(ColorConsts.primaryColor),
            Color(ColorConsts.secondaryColor)
          ],
        ),
        borderRadius: BorderRadius.circular(0.0),
        image: DecorationImage(
          image: AssetImage('assets/images/BGheader.png'),
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.fromLTRB(38, 0, 0, 0),
              child: Text('Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(ColorConsts.whiteColor))),
            ),
          ),
          InkResponse(
            onTap: () {
              Navigator.pop(context);
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  'assets/icons/Arrow.png',
                  width: 21,
                  height: 21,
                  color: Color(ColorConsts.whiteColor),
                ),
              ),
            ),
          ),



        ],
      )),

    Container(
      margin: EdgeInsets.fromLTRB(16, 65, 16, 6),

      child: ListView(
        children: [

          HtmlWidget(
            details,
            textStyle: TextStyle(   fontFamily: 'OpenSans',color: Color(ColorConsts.blackColor), fontSize: 18),
          )
        ],
      ),
    )
    ]
    )
    ),
    )
    )
    );
  }




}