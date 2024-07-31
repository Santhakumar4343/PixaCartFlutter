import 'dart:convert';

import 'package:e_com/model/ModelSettings.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/presenter/PaymetDetailPresenter.dart';
import 'package:e_com/ui/CustomerSupport.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/SharedPref.dart';
import 'Search.dart';


class HelpCenter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateHelpCenter();
  }
}

class StateHelpCenter extends State {
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }
  String isSelected='';
  late UserLoginModel _userLoginModel;
  bool hasData = false;
  late ModelSettings modelSettings ;


  SharedPref sharePrefs = SharedPref();
  String? tag='';

  Future<void> getValue() async {
    tag= await sharePrefs.getLanguage();
    _userLoginModel = await sharePrefs.getLoginUserData();
    await PaymetDetailPresenter().get(_userLoginModel.data.token);
    String? sett = await sharePrefs.getSettings();
    final Map<String, dynamic> parsed = json.decode(sett!);
    modelSettings = ModelSettings.fromJson(parsed);
    hasData = true;
    setState(() {

    });
  }

  @override
  void initState() {
    getValue();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                                  child: Text('Help Center',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color(ColorConsts.whiteColor))),
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
                        height: 43,
                        margin: EdgeInsets.fromLTRB(12, 79, 65, 8),
                        padding: EdgeInsets.fromLTRB(5, 0, 6, 0),
                        decoration: new BoxDecoration(
                            border: Border.all(
                                color: Color(ColorConsts.lightGrayColor),
                                width: 0.5),
                            borderRadius: BorderRadius.circular(4.0)),
                        child: InkResponse(
                          onTap: () {
                            setState(() {});
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => Search()),
                            );
                          },
                          child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 4.5, 0),
                                      child: Text(
                                        " Search..",
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Color(
                                                ColorConsts.lightGrayColor)),
                                      ))),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 13, 5, 13),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/icons/SearchIcon.png'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        child: Container(
                          height: 43,
                          width: 43,
                          margin: EdgeInsets.fromLTRB(12, 79, 12, 8),
                          decoration: new BoxDecoration(
                              border: Border.all(
                                  color: Color(ColorConsts.primaryColor),
                                  width: 0.8),
                              borderRadius: BorderRadius.circular(4.0)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                              child: Image(
                                image: AssetImage('assets/icons/mic.png'),
                              ),
                            ),
                          ),
                        ),
                        alignment: Alignment.topRight,
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(12, 150, 12, 0),
                          child: CustomScrollView(slivers: [
                            SliverToBoxAdapter(
                                child: Column(children: [
                              Stack(children: [
                                InkResponse(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return CustomerSupport();
                                      },
                                    ));
                                  },
                                  child: Container(
                                      height: 55,
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          17,
                                      alignment: Alignment.center,
                                      padding:
                                          EdgeInsets.fromLTRB(17, 8, 17, 8),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(ColorConsts
                                                  .secondaryBtnColor),
                                              Color(ColorConsts
                                                  .secondaryBtnColor),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6.0)),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/icons/chat.png',
                                              width: 28,
                                              height: 21,
                                              color:
                                                  Color(ColorConsts.whiteColor),
                                            ),
                                            Text(
                                              'Chat with us',
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans-Bold',
                                                  fontSize: 18.0,
                                                  color: Color(
                                                      ColorConsts.whiteColor)),
                                            )
                                          ])),
                                ),
                              Align(
                                    alignment: Alignment.centerRight,
                                    child: InkResponse(
                                      child: Container(
                                          height: 55,
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              17,
                                          alignment: Alignment.center,
                                          padding:
                                              EdgeInsets.fromLTRB(23, 8, 23, 8),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(
                                                      ColorConsts.primaryColor),
                                                  Color(ColorConsts
                                                      .secondaryColor)
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6.0)),
                                          child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/icons/headPhone.png',
                                                  width: 25,
                                                  height: 18,
                                                  color: Color(
                                                      ColorConsts.whiteColor),
                                                ),
                                                Text(
                                                  'Talk to us',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'OpenSans-Bold',
                                                      fontSize: 18.0,
                                                      color: Color(ColorConsts
                                                          .whiteColor)),
                                                )
                                              ])),
                                      onTap: () {
                                        if(hasData)if(modelSettings.data.support_contact_number.isNotEmpty){
                                        _makePhoneCall(""+modelSettings.data.support_contact_number);}
                                      },
                                    )),

                              ]),
                 /*   Container(
                        height: 47,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
                        margin: EdgeInsets.fromLTRB(0, 38, 0, 0),
                        decoration: BoxDecoration(
                          gradient: (isSelected.contains( Resource.of(context,tag!).strings.HowCanITrackMyOrder))?LinearGradient(
                            colors: [
                              Color(ColorConsts.primaryColor),
                              Color(ColorConsts.secondaryColor)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ):null,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              color: Color(ColorConsts.lightGrayColor), width: 0.5),
                        ),
                        child:InkResponse(
                          onTap: () {
                            isSelected= Resource.of(context,tag!).strings.HowCanITrackMyOrder;
                            setState(() {

                            });

                          },
                          child: Stack(

                              children: [

                                Container(
                                  margin: EdgeInsets.fromLTRB(2, 0, 0, 0),

                                  child: Column(
                                    children: [
                                      Container(

                                        alignment: Alignment.centerLeft,
                                        child: Text( Resource.of(context,tag!).strings.HowCanITrackMyOrder
                                          ,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: 'OpenSans-Bold',
                                            fontSize: 17,

                                            color: (isSelected.contains( Resource.of(context,tag!).strings.HowCanITrackMyOrder))? Color(ColorConsts.whiteColor):Color(ColorConsts.blackColor), ),
                                        ),
                                      ),

                                    ],
                                  ),
                                )

                                ,

                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(

                                    margin: EdgeInsets.fromLTRB(0, 3, 12, 0),

                                    child:Image.asset(
                                      'assets/icons/DownIcon.png',width: 7,color:(isSelected.contains( Resource.of(context,tag!).strings.HowCanITrackMyOrder
                                    ))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

                                  ),

                                )
                              ]
                          ),
                        )
                    ),

                    Container(
                        height: 47,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
                        margin: EdgeInsets.fromLTRB(0, 14, 0,0),
                        decoration: BoxDecoration(
                          gradient: (isSelected.contains( Resource.of(context,tag!).strings.PaymentRelatedIssues))?LinearGradient(
                            colors: [
                              Color(ColorConsts.primaryColor),
                              Color(ColorConsts.secondaryColor)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ):null,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              color: Color(ColorConsts.lightGrayColor), width: 0.5),
                        ),
                        child:InkResponse(
                          onTap: () {
                            isSelected= Resource.of(context,tag!).strings.PaymentRelatedIssues;
                            setState(() {

                            });

                          },
                          child: Stack(

                              children: [

                                Container(
                                  margin: EdgeInsets.fromLTRB(2, 0, 0, 0),

                                  child: Column(
                                    children: [
                                      Container(

                                        alignment: Alignment.centerLeft,
                                        child: Text( Resource.of(context,tag!).strings.PaymentRelatedIssues,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: 'OpenSans-Bold',
                                            fontSize: 17,

                                            color: (isSelected.contains( Resource.of(context,tag!).strings
                                                .PaymentRelatedIssues))? Color(ColorConsts.whiteColor):Color(ColorConsts.blackColor), ),
                                        ),
                                      ),

                                    ],
                                  ),
                                )

                                ,

                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(

                                    margin: EdgeInsets.fromLTRB(0, 3, 12, 0),

                                    child:Image.asset(
                                      'assets/icons/DownIcon.png',width: 7,color:(isSelected.contains( Resource.of(context,tag!)
                                        .strings
                                        .PaymentRelatedIssues))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

                                  ),

                                )
                              ]
                          ),
                        )
                    ),

                    Container(
                        height: 47,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
                        margin: EdgeInsets.fromLTRB(0, 14, 0, 0),
                        decoration: BoxDecoration(
                          gradient: (isSelected.contains( Resource.of(context,tag!).strings.ReturnsRefunds))?LinearGradient(
                            colors: [
                              Color(ColorConsts.primaryColor),
                              Color(ColorConsts.secondaryColor)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ):null,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              color: Color(ColorConsts.lightGrayColor), width: 0.5),
                        ),
                        child:InkResponse(
                          onTap: () {
                            isSelected= Resource.of(context,tag!)
                                .strings.ReturnsRefunds;
                            setState(() {

                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ReturnAndRefunds();
                            },));

                          },
                          child: Stack(

                              children: [

                                Container(
                                  margin: EdgeInsets.fromLTRB(2, 0, 0, 0),

                                  child: Column(
                                    children: [
                                      Container(

                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Returns & Refunds',
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: 'OpenSans-Bold',
                                            fontSize: 17,

                                            color: (isSelected.contains( Resource.of(context,tag!)
                                                .strings
                                                .ReturnsRefunds))? Color(ColorConsts.whiteColor):Color(ColorConsts.blackColor), ),
                                        ),
                                      ),

                                    ],
                                  ),
                                )

                                ,

                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 3, 12, 0),
                                    child:Image.asset(
                                      'assets/icons/DownIcon.png',width: 7,color:(isSelected.contains( Resource.of(context,tag!)
                                        .strings
                                        .ReturnsRefunds))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

                                  ),

                                )
                              ]
                          ),
                        )
                    ),

                    Container(
                        height: 47,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
                        margin: EdgeInsets.fromLTRB(0, 14, 0, 20),
                        decoration: BoxDecoration(
                          gradient: (isSelected.contains( Resource.of(context,tag!).strings.HelpWithOtherIssues))?LinearGradient(
                            colors: [
                              Color(ColorConsts.primaryColor),
                              Color(ColorConsts.secondaryColor)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ):null,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              color: Color(ColorConsts.lightGrayColor), width: 0.5),
                        ),
                        child:InkResponse(
                          onTap: () {
                            isSelected= Resource.of(context,tag!).strings.HelpWithOtherIssues;
                            setState(() {

                            });

                          },
                          child: Stack(

                              children: [

                                Container(
                                  margin: EdgeInsets.fromLTRB(2, 0, 0, 0),

                                  child: Column(
                                    children: [
                                      Container(

                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                           Resource.of(context,tag!).strings.HelpWithOtherIssues,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: 'OpenSans-Bold',
                                            fontSize: 17,

                                            color: (isSelected.contains( Resource.of(context,tag!).strings.HelpWithOtherIssues))? Color(ColorConsts.whiteColor):Color(ColorConsts.blackColor), ),
                                        ),
                                      ),],
                                  ),
                                ), Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 3, 12, 0),
                                    child:Image.asset(
                                      'assets/icons/DownIcon.png',width: 7,color:(isSelected.contains( Resource.of(context,tag!)
                                        .strings
                                        .HelpWithOtherIssues))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

                                  ),

                                )
                              ]
                          ),
                        )
                    ),*/
                    ])


                            )
                          ]))
                    ])))));
  }
}
