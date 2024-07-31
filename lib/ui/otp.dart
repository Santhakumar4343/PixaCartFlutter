

import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/model/UserModelVerify.dart';
import 'package:e_com/presenter/OTPVerifyPresenter.dart';
import 'package:e_com/ui/BaseBottom.dart';
import 'package:e_com/utils/AppConstant.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_com/utils/Resource.dart';

import '../utils/SharedPref.dart';

String isEmailOrPhone='',user_id='';
class otp extends StatefulWidget {

  otp(String text, String userId){
    isEmailOrPhone=text;
    user_id=userId;
  }

  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<otp> {
  TextEditingController oneController = TextEditingController();
  TextEditingController twoController = TextEditingController();
  TextEditingController threeController = TextEditingController();
  TextEditingController fourController = TextEditingController();
  String otpCode ="";
  bool monVal = false;
  RegExp _numeric = RegExp(r'^-?[0-9]+$');
  String version = '';
  String buildNumber = '';
  bool isLoading= false;


  SharedPref sharePrefs = SharedPref();
  String? tag='';

  Future<void> getValue() async {
    tag= await sharePrefs.getLanguage();

String codeId=await sharePrefs.getUserData();

user_id=codeId.split(",").first;

    setState(() {

    });
  }

  @override
  void initState() {
    getValue();
    super.initState();
  }

  otpResent(){
    Fluttertoast.showToast(
        msg:"OTP is resent!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Color(ColorConsts.whiteColor),
        fontSize: 14.0);
  }

  Future<void> otpApiCall() async {
    setState(() {

    });
    String loginModel=await OTPVerifyPresenter()
        .getVerify(context,otpCode,""+user_id);

    isLoading=false;
    if(!loginModel.isEmpty){

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => Base(),
          ),
              (route) => false);
     /* Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Base();
      },));*/
    }else{
      setState(() {

      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage("assets/images/background.jpg"),
    fit: BoxFit.cover),
    ),
            padding: EdgeInsets.fromLTRB(2, 20, 2, 0),
            child: Stack(children: [ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(padding: EdgeInsets.all(9)
              ,child: Image.asset('assets/images/logo.png',width: 40,height: 45,),),
            Text(AppConstant.appName  , style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color:Color(ColorConsts.whiteColor)
            ),
            )
            ],)

          ,
                Container(
                  margin: EdgeInsets.fromLTRB(6, 12, 6, 6),
                  child: Text(
                  (_numeric.hasMatch(isEmailOrPhone))? Resource.of(context,tag!).strings.verifyYourNumber:'Verify Your Email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
letterSpacing: 1.0,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Color(ColorConsts.whiteColor)
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(6, 0, 6, 12),
                  child: Text(
                    '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 23,
                        color: Color(ColorConsts.whiteColor)
                    ),
                  ),
                ),
           Stack(

             children: [
             Container(
               padding: EdgeInsets.fromLTRB(16, 12, 16, 56),
               margin: EdgeInsets.fromLTRB(30, 22, 30, 0),
               decoration: new BoxDecoration(
                   gradient: LinearGradient(
                     colors: [
                       Color(0x32FFFFFF),
                       Color(0x32FFFFFF)
                     ],
                     begin: Alignment.centerLeft,
                     end: Alignment.centerRight,
                   ),
                   borderRadius: BorderRadius.circular(15.0)
               ),),


             Container(

                 padding: EdgeInsets.fromLTRB(16, 12, 16, 80),
                 margin: EdgeInsets.fromLTRB(15, 35, 15, 36),
                 decoration: new BoxDecoration(
                     gradient: LinearGradient(
                       colors: [
                         Color(ColorConsts.whiteColor),
                         Color(ColorConsts.whiteColor)
                       ],
                       begin: Alignment.centerLeft,
                       end: Alignment.centerRight,
                     ),
                     borderRadius: BorderRadius.circular(15.0)),
                 child: Column(

                   children: [
                 Container(
                 margin: EdgeInsets.fromLTRB(15, 22, 15, 29),
                   alignment:Alignment.center,
                   child:  Text(
                     (_numeric.hasMatch(isEmailOrPhone))?  Resource.of(context,tag!).strings.otpSent:'Enter OTP That has been sent to your '+isEmailOrPhone+".",
                       textAlign: TextAlign.center,
                       style: TextStyle(

                           fontFamily: 'OpenSans',
                           fontSize: 17,
                           color: Color(ColorConsts.grayColor)),
                     ),
                 ),

Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly
  ,children: [

    Container(
      height: 55,
      width: 55,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(ColorConsts.whiteColor),
              Color(ColorConsts.whiteColor)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(6.0),border: Border.all(color:Color(ColorConsts.lightGrayColor) )),
      child: new TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        onChanged: (value) {
          if(oneController.text.length==1){
            FocusScope.of(context).nextFocus();
          }
        },
        style: TextStyle(
            color: Color(ColorConsts.blackColor),
            fontSize: 17.0,
            fontFamily: 'OpenSans'),
        controller: oneController,
        decoration: new InputDecoration(

counterText: '',

            border: InputBorder.none
        ),
      ),
    ),
    Container(
      height: 55,
      width: 55,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(ColorConsts.whiteColor),
              Color(ColorConsts.whiteColor)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(6.0),border: Border.all(color:Color(ColorConsts.lightGrayColor) )),
      child: new TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        onChanged: (value) {
          if(oneController.text.length==1){
            FocusScope.of(context).nextFocus();
          }
        },
        style: TextStyle(
            color: Color(ColorConsts.blackColor),
            fontSize: 17.0,
            fontFamily: 'OpenSans'),
        controller: twoController,
        decoration: new InputDecoration(


            counterText: '',
            border: InputBorder.none
        ),
      ),
    ),


    Container(
      height: 55,
      width: 55,
alignment: Alignment.center,
      decoration: new BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(ColorConsts.whiteColor),
              Color(ColorConsts.whiteColor)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(6.0),border: Border.all(color:Color(ColorConsts.lightGrayColor) )),
      child: new TextField(
        keyboardType: TextInputType.number,
textAlign: TextAlign.center,
        maxLength: 1,
        onChanged: (value) {
          if(oneController.text.length==1){
            FocusScope.of(context).nextFocus();
          }
        },
        style: TextStyle(
            color: Color(ColorConsts.blackColor),
            fontSize: 17.0,
            fontFamily: 'OpenSans'),
        controller: threeController,
        decoration: new InputDecoration(

            counterText: '',

            border: InputBorder.none
        ),
      ),
    ),


    Container(
      height: 55,
      width: 55,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(ColorConsts.whiteColor),
              Color(ColorConsts.whiteColor)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(6.0),border: Border.all(color:Color(ColorConsts.lightGrayColor) )),
      child: new TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        onChanged: (value) {
          if(oneController.text.length==1){
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        style: TextStyle(
            color: Color(ColorConsts.blackColor),
            fontSize: 17.0,
            fontFamily: 'OpenSans'),
        controller: fourController,
        decoration: new InputDecoration(


            counterText: '',
            border: InputBorder.none
        ),
      ),
    ),
],),



                     Container(
                       width: MediaQuery.of(context).size.width,
                       margin: EdgeInsets.fromLTRB(10, 22, 10, 20),
                       decoration: BoxDecoration(
                           gradient: LinearGradient(
                             colors: [
                               Color(ColorConsts.primaryColor),
                               Color(ColorConsts.secondaryColor)
                             ],
                             begin: Alignment.centerLeft,
                             end: Alignment.centerRight,
                           ),
                           borderRadius: BorderRadius.circular(30.0)),
                       child: TextButton(

                           child: Text(
                            Resource.of(context,tag!).strings.confirm,
                             style: TextStyle(
                                 fontFamily: 'OpenSans',
                                 fontSize: 18,
                                 fontWeight: FontWeight.w600,
                                 color: Color(0xffffffff)),
                           ),
                           onPressed: () => {

                             if (oneController.text.isEmpty || twoController.text.isEmpty || threeController.text.isEmpty || fourController.text.isEmpty )
                               {
                                 Fluttertoast.showToast(
                                     msg:Resource.of(context,tag!)
                                         .strings
                                         .EnterOtp,
                                     toastLength: Toast.LENGTH_SHORT,
                                     timeInSecForIosWeb: 1,
                                     backgroundColor: Colors.grey,
                                     textColor: Color(ColorConsts.whiteColor),
                                     fontSize: 14.0),
                               }
                             else
                               {
                             otpCode =oneController.text.toString()+twoController.text.toString()+threeController.text.toString() + fourController.text.toString(),
                                 isLoading=true,
                                 otpApiCall(),
                         setState(() {

                         }),
                          /* showGeneralDialog(
                           barrierLabel: "Barrier",
                           barrierDismissible: true,
                           barrierColor:
                           Colors.black.withOpacity(0.5),
                           transitionDuration:
                           Duration(milliseconds: 700),
                           context: context,
                           pageBuilder: (_, __, ___) {
                             return FutureBuilder<String>(
                                 future: OTPVerifyPresenter()
                                     .getVerify(context,otpCode,""+user_id),
                                 builder: (context, projectSnap) {
                                   if (projectSnap.hasData) {

                                     if(!projectSnap.data!.isEmpty){
                                     //  sharePrefs.setUserData(json.decode(projectSnap.data.toString()));
                                       return Material(child:
                                       Base());

                                     }else{
                                       Navigator.pop(context);
                                     }
                                   }
                                 }
                             );
                           }),*/
                           }
                           }
                       ),
                     ),
                   /*  Container(

                         margin: EdgeInsets.fromLTRB(15, 11, 15, 10),
                         child:



                             Align(alignment: Alignment.center, child:  InkResponse(
                               onTap: () {
                                 otpResent();

                               },

                               child:Container(
                               height: 45,
                               alignment: Alignment.center,
                               margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.center,children: [

                                 Text(Resource.of(context,tag!)
                                     .strings
                                     .Resend,
                                       style: TextStyle(
                                           fontFamily: 'OpenSans',
                                           fontSize: 16,
                                           fontWeight: FontWeight.w500,
                                           color: Color(ColorConsts.primaryColor))),

                               ],)
                               ),
                             )
                               ,)




                         ),*/







                   ],)
             ),
           ],)




              ],
            )
              ,if(isLoading)Material(
                  type: MaterialType
                      .transparency,
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      width:  MediaQuery.of(context).size.width,
                      color: Color(ColorConsts.primaryColorLyt),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: <
                            Widget>[
                          SizedBox(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(ColorConsts.primaryColor)), backgroundColor: Color(ColorConsts.whiteColor), strokeWidth: 4.0)),
                          Container(
                              margin: EdgeInsets.all(6),
                              child: Text(
                                Resource.of(context, tag!).strings.loadingPleaseWait,
                                style: TextStyle(color: Color(ColorConsts.whiteColor), fontFamily: 'OpenSans-Bold', fontWeight: FontWeight.w500, fontSize: 18),
                              )),
                        ],
                      )))


            ])

    ));
  }
}


