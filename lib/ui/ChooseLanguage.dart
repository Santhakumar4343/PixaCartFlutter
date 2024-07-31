import 'package:e_com/utils/Resource.dart';

import 'package:e_com/utils/SharedPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/color_const.dart';

class ChooseLanguage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return chooseLanguageState();
  }
}
SharedPref sharePrefs = SharedPref();
class chooseLanguageState extends State {
  String? tag='';

  String isSelected='en';
  Future<void> getValue() async {
 tag= await sharePrefs.getLanguage();

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
                            child: Text( Resource.of(context,tag!).strings.ChooseLanguage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Color(ColorConsts.whiteColor)
                                )
                            ),
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
                Column(children: [


                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(11, 85, 11,8),
                      decoration: BoxDecoration(
                        gradient: (isSelected.contains('en'))?LinearGradient(
                          colors: [
                            Color(ColorConsts.primaryColor),
                            Color(ColorConsts.secondaryColor)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ):null,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            color: Color(ColorConsts.lightGrayColor), width: 0.1),
                      ),
                      child: InkResponse(
                        onTap: () {
                          isSelected='en';
                          setState(() {

                          });
                          sharePrefs.setLanguage('en');

                        },
                        child: Stack(

                            children: [

                              Container(
                                width: 33,
                                height: 48,
                                padding: EdgeInsets.fromLTRB(12, 7, 0, 7),
                                child: Image.asset(
                                  'assets/icons/Language.png',color: (isSelected.contains('en'))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(48, 0, 0, 0),
                                height: 48,
                                child:
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'English',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: 'OpenSans-Bold',
                                      fontSize: 17.5,

                                      color: (isSelected.contains('en'))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),
                                  ),

                                ),
                              ),


                            ]
                        ),
                      )
                  ),
                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(11, 8, 11,8),
                      decoration: BoxDecoration(
                        gradient: (isSelected.contains('hi'))?LinearGradient(
                          colors: [
                            Color(ColorConsts.primaryColor),
                            Color(ColorConsts.secondaryColor)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ):null,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            color: Color(ColorConsts.lightGrayColor), width: 0.1),
                      ),
                      child: InkResponse(
                        onTap: () {
                          isSelected='hi';
                          setState(() {

                          });


                        },
                        child: Stack(

                            children: [

                              Container(
                                width: 33,
                                height: 48,
                                padding: EdgeInsets.fromLTRB(12, 7, 0, 7),
                                child: Image.asset(
                                  'assets/icons/Language.png',color: (isSelected.contains('hi'))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(48, 0, 0, 0),
                                height: 48,
                                child:
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Hindi',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: 'OpenSans-Bold',
                                      fontSize: 17.5,

                                      color: (isSelected.contains('hi'))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),
                                  ),

                                ),
                              ),


                            ]
                        ),
                      )
                  ),
                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(11, 8, 11,8),
                      decoration: BoxDecoration(
                        gradient: (isSelected.contains('fn'))?LinearGradient(
                          colors: [
                            Color(ColorConsts.primaryColor),
                            Color(ColorConsts.secondaryColor)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ):null,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            color: Color(ColorConsts.lightGrayColor), width: 0.1),
                      ),
                      child: InkResponse(
                        onTap: () {
                          isSelected='fn';
                          setState(() {});
                          },
                        child: Stack(

                            children: [

                              Container(
                                width: 33,
                                height: 48,
                                padding: EdgeInsets.fromLTRB(12, 7, 0, 7),
                                child: Image.asset(
                                  'assets/icons/Language.png',color: (isSelected.contains('fn'))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(48, 0, 0, 0),
                                height: 48,
                                child:
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Franch',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: 'OpenSans-Bold',
                                      fontSize: 17.5,

                                      color: (isSelected.contains('fn'))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),
                                  ),

                                ),
                              ),


                            ]
                        ),
                      )
                  ),
                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(11, 8, 11,8),
                      decoration: BoxDecoration(
                        gradient: (isSelected.contains('ar'))?LinearGradient(
                          colors: [
                            Color(ColorConsts.primaryColor),
                            Color(ColorConsts.secondaryColor)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ):null,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            color: Color(ColorConsts.lightGrayColor), width: 0.1),
                      ),
                      child: InkResponse(
                        onTap: () {
                          isSelected='ar';
                          setState(() {

                          });


                        },
                        child: Stack(

                            children: [

                              Container(
                                width: 33,
                                height: 48,
                                padding: EdgeInsets.fromLTRB(12, 7, 0, 7),
                                child: Image.asset(
                                  'assets/icons/Language.png',color: (isSelected.contains('ar'))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(48, 0, 0, 0),
                                height: 48,
                                child:
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                       'Arabic',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: 'OpenSans-Bold',
                                          fontSize: 17.5,

                                          color: (isSelected.contains('ar'))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),
                                      ),

                                ),
                              ),


                            ]
                        ),
                      )
                  ),
                ],)
              ]),
            ))));
  }
}
