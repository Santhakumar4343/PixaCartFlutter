import 'dart:convert';
import 'dart:io';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/presenter/LoginPresenter.dart';
import 'package:e_com/ui/ForgotPassword.dart';
import 'package:e_com/utils/ConnectionCheck.dart';
import 'package:e_com/utils/Resource.dart';
import 'package:e_com/utils/AppConstant.dart';
import 'package:e_com/utils/SharedPref.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'BaseBottom.dart';
import 'Register.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  String _message = "Not Authorized";
  bool remMeVal = false;
  bool _passwordVisible = false;
  String version = '';
  String buildNumber = '';
  bool canCheckBiometrics = false;
 bool isLoading= false;
  String err = '';
  SharedPref sharePrefs = SharedPref();
  late String fcmToken ='';
  bool isPhone = false;

  @override
  void initState() {
    getValue();
    ConnectionCheck().checkConnection();

    checkingForBioMetrics();
    _passwordVisible = false;
    super.initState();


  }

  String? tag = '';

  Future<void> getValue() async {

 fcmToken =(await FirebaseMessaging.instance.getToken())!;

 if (Platform.isIOS) {
   fcmToken = (await FirebaseMessaging.instance.getAPNSToken())!;
 }
    print('---------------------FCM----------------------------------------------$fcmToken');
    await sharePrefs.setLanguage('en');
    tag = await sharePrefs.getLanguage();
    String dataUserRememberMe='';
    dataUserRememberMe = await sharePrefs.getRememberMe();
if(dataUserRememberMe.isNotEmpty){
    emailController.text=dataUserRememberMe.split(",").first;
    passwordController.text=dataUserRememberMe.split(",")[1];}

    setState(() {});
  }

 Future<void> loginApi() async {

 
   String response =await  LoginDataPresenter().loginApi(context, emailController.text, passwordController.text,fcmToken);



   if (remMeVal) {
     sharePrefs.setRememberMe(emailController
         .text +
         "," +
         passwordController
             .text);
   }else{
     sharePrefs.setRememberMe(''
         "," +
         '');
   }

   if(response.toString().isNotEmpty){




     Navigator.of(context).pushAndRemoveUntil(
         MaterialPageRoute(
           builder: (context) => Base(),
         ),
             (route) => false);
/*Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
  return Base();
},));*/
   }else{

     isLoading=false;

     setState(() {

     });
   }



  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Future<bool> checkingForBioMetrics() async {
    canCheckBiometrics = await _localAuthentication.canCheckBiometrics;

    return canCheckBiometrics;
  }
  Future<bool> isBack(BuildContext context) async {

    return (await showDialog(
      context: context,
      builder: (context) =>  AlertDialog(
        elevation: 5,
        contentPadding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
        content: Container(
          height: 145,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(ColorConsts.primaryColor),
                  Color(ColorConsts.secondaryColor)

                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,

              ),
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/backInPopup.png')
                ,
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
              ),
              borderRadius: BorderRadius.circular(12.0)),
          child:  Align(
              alignment: Alignment.centerLeft,
              child: Stack(
                children: [

                  Align(alignment: Alignment.center,
                    child: Container(

                        margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Container(
                            padding: EdgeInsets.all(2),
                            width: 65,
                            height:100,
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(12, 0, 0, 0),child: Image.asset(
                            'assets/images/logo.png',
                            width: 78,
                            height: 78,

                          ),
                          ),
                            Align(child: Container(
                                width: 160,
                                height:187,
                                margin: EdgeInsets.fromLTRB(18, 12, 8, 0),
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child:  Column(
                                  children: [Text(Resource.of(context,tag!).strings.ExitTheApp,
                                    maxLines: 3,style: TextStyle(fontFamily: 'OpenSans-Bold',fontWeight: FontWeight.w500,fontSize:17
                                        ,color: Color(ColorConsts.whiteColor)),),

                                    Stack(children: [
                                      Align(alignment: Alignment.centerLeft,child: InkResponse(
                                        onTap : () {

                                          if (Platform.isAndroid) {
                                            SystemNavigator.pop();
                                          } else {
                                            exit(0);
                                          }
                                        }, // passing true
                                        child: Container(
                                            margin: EdgeInsets.fromLTRB(12, 16, 6, 0),
                                            padding: EdgeInsets.fromLTRB(22, 7, 22, 7),
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(ColorConsts.whiteColor),
                                                    Color(ColorConsts.whiteColor)

                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ),
                                                borderRadius: BorderRadius.circular(20.0)),
                                            child: Text(
                                              Resource.of(context,tag!).strings.yes,
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans-Bold',
                                                  fontSize: 14.0,
                                                  color: Color(ColorConsts.primaryColor)
                                              ),
                                            )),
                                      ),),
                                      Align(alignment: Alignment.centerRight,child:   InkResponse(
                                        onTap: () =>
                                            Navigator.pop(context, false), // passing false
                                        child: Container(
                                            margin: EdgeInsets.fromLTRB(0, 16,7, 0),
                                            padding: EdgeInsets.fromLTRB(22, 7, 22, 7),
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [

                                                    Color(ColorConsts.secondaryBtnColor),
                                                    Color(ColorConsts.secondaryBtnColor),

                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ),
                                                borderRadius: BorderRadius.circular(20.0)),
                                            child: Text(
                                              Resource.of(context,tag!).strings.no
                                              ,
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans-Bold',
                                                  fontSize: 14.0,
                                                  color: Color(ColorConsts.whiteColor)),
                                            )),
                                      ) ,)
                                    ],)



                                  ],)
                            ),) ,
                          ],)
                    ),
                  ),

                  Align(alignment: Alignment.topRight,child: InkResponse(child:  Container(
                    width: 24,
                    alignment: Alignment.topRight,
                    child: Icon(Icons.clear,color: Color(ColorConsts.whiteColor),size: 20),
                  ),onTap:(){
                    Navigator.pop(context, false);
                  } ,)
                  )

                ],)
          ),),




      ),
    )) ??
        false;

  }
  Future<void> _authenticateMe() async {
// 8. this method opens a dialog for fingerprint authentication.
//    we do not need to create a dialog nut it popsup from device natively.
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Authenticate for Testing", // message for dialog
        useErrorDialogs: true, // show error in dialog
        stickyAuth: true, // native process
      );

      setState(() {
        _message = authenticated ? "Authorized" : "Not Authorized";
      });
      if (authenticated) {
        Fluttertoast.showToast(
            msg: 'Sucessfully authenticate! ',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Color(ColorConsts.whiteColor),
            fontSize: 14.0);
      }
    } catch (e) {
      err = e.toString().contains(',')
          ? e.toString().split(',')[0].replaceAll('PlatformException(', '') +
              ":" +
              e.toString().split(',')[1]
          : '';

      setState(() {});
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {

      return isBack(context);
    }, child:Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover),
            ),
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Stack(children: [ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(9),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 40,
                        height: 45,
                      ),
                    ),
                    Text(
                      AppConstant.appName,
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConsts.whiteColor)),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(6, 12, 6, 6),
                  child: Text(
                    Resource.of(context, tag!).strings.welcome,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        letterSpacing: 1.0,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Color(ColorConsts.whiteColor)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(6, 0, 6, 12),
                  child: Text(
                    Resource.of(context, tag!).strings.appDesciption,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 23,
                        color: Color(ColorConsts.whiteColor)),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(14, 12, 14, 56),
                      margin: EdgeInsets.fromLTRB(30, 22, 30, 0),
                      decoration: new BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0x32FFFFFF), Color(0x32FFFFFF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 65),
                        margin: EdgeInsets.fromLTRB(15, 35, 15, 46),
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
                              margin: EdgeInsets.fromLTRB(15, 22, 15, 0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  isPhone
                                      ? Resource.of(context, tag!).strings.phone
                                      : Resource.of(context, tag!)
                                      .strings
                                      .email,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans.ttf',
                                      fontSize: 17,
                                      color: Color(ColorConsts.grayColor))),
                            ),
                            Container(
                              height: 40,
                              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: new TextField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(isPhone?10:50),
                                ],
                                keyboardType: isPhone
                                    ? TextInputType.phone
                                    : TextInputType.emailAddress,
                                style: TextStyle(
                                    color: Color(ColorConsts.blackColor),
                                    fontSize: 17.0,

                                    fontFamily: 'OpenSans'),
                                controller: emailController,
                                decoration: new InputDecoration(
                                    isDense: true,
                                    suffixIcon: Image.asset(
                                      isPhone
                                          ? 'assets/icons/phone.png'
                                          : 'assets/icons/mail.png',
                                      height: 5.0,
                                      width: 5.0,
                                    ),
                                    suffixIconConstraints: BoxConstraints(
                                        minHeight: 18, minWidth: 18),
                                    hintText: isPhone
                                        ? Resource.of(context, tag!)
                                        .strings
                                        .enterPhoneHere
                                        : Resource.of(context, tag!)
                                        .strings
                                        .enterUserEmailHere,
                                    hintStyle: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 15.5,
                                        color: Color(ColorConsts.lightGrayColor)),
                                    border: InputBorder.none),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              height: 0.5,
                              color: Color(ColorConsts.lightGrayColor),
                            ),
                            InkResponse(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(15, 2, 14, 0),
                                alignment: Alignment.centerRight,
                                child: Text(
                                    isPhone
                                        ? 'Login with email'
                                        : 'Login with phone number',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontFamily: 'OpenSans.ttf',
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        color:
                                        Color(ColorConsts.primaryColor))),
                              ),
                              onTap: () {
                                emailController.text="";
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (isPhone) {
                                  isPhone = false;
                                } else {
                                  isPhone = true;
                                }
                                setState(() {});
                              },
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 22, 14, 0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  Resource.of(context, tag!).strings.password,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans.ttf',
                                      fontSize: 17,
                                      color: Color(ColorConsts.grayColor))),
                            ),
                            Stack(
                              children: [
                                Container(
                                  height: 40,
                                  margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  child: TextField(
                                    obscureText: !_passwordVisible,
                                    controller: passwordController,
                                    style: TextStyle(
                                        color: Color(ColorConsts.blackColor),
                                        fontSize: 17.0,
                                        fontFamily: 'OpenSans'),
                                    decoration: new InputDecoration(
                                      hintText: Resource.of(context, tag!)
                                          .strings
                                          .enterPassHere,
                                      hintStyle: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontSize: 15.5,
                                          color: Color(
                                              ColorConsts.lightGrayColor)),
                                      suffixIcon: IconButton(
                                          icon: _passwordVisible
                                              ? Image.asset(
                                                  'assets/icons/eyeicon.png',
                                                  width: 19,
                                                  height: 19,
                                                )
                                              : Image.asset(
                                                  'assets/icons/eyeshow.png',
                                                  width: 19,
                                                  height: 19,
                                                ),
                                          onPressed: () {
                                            // Update the state i.e. toogle the state of passwordVisible variable
                                            if (_passwordVisible) {
                                              _passwordVisible = false;
                                            } else {
                                              _passwordVisible = true;
                                            }
                                            setState(() {});
                                          }),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                             /*   Align(
                                    alignment: Alignment.centerRight,
                                    child: InkResponse(
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 12, 0),
                                        height: 45,
                                        width: 35,
                                        child: Image.asset(
                                          'assets/icons/fingerprint.png',
                                          width: 19,
                                          height: 20.5,
                                        ),
                                      ),
                                      onTap: () {
                                        if (canCheckBiometrics) {
                                          _authenticateMe();
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'Not supported by device!',
                                              toastLength: Toast.LENGTH_SHORT,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.grey,
                                              textColor:
                                                  Color(ColorConsts.whiteColor),
                                              fontSize: 14.0);
                                        }
                                      },
                                    ))*/
                              ],
                            ),

                                Container(
                                  width:
                                      MediaQuery.of(context).size.width-35 ,
                                  margin: EdgeInsets.fromLTRB(15, 0, 12, 0),
                                  height: 0.5,
                                  color: Color(ColorConsts.lightGrayColor),
                                ),


                            Container(
                                margin: EdgeInsets.fromLTRB(0, 9, 12, 10),
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          Checkbox(
                                            value: remMeVal,
                                            activeColor:
                                                Color(ColorConsts.primaryColor),

                                            onChanged: (value) {
                                              setState(() {
                                                remMeVal = value!;
                                              });
                                            },
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                37, 0, 0, 0),
                                            child: InkResponse(
                                              onTap: () {},
                                              child: Text(
                                                  Resource.of(context, tag!)
                                                      .strings
                                                      .rememberMe,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'OpenSans.ttf',
                                                      fontSize: 16,
                                                      color: Color(ColorConsts
                                                          .grayColor))),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        height: 45,
                                        alignment: Alignment.centerRight,
                                        margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                                        child: InkResponse(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ForgotPassword()));
                                          },
                                          child: Text(
                                              Resource.of(context, tag!)
                                                  .strings
                                                  .forgotPassword,
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 15.4,
                                                  color: Color(ColorConsts
                                                      .primaryColor))),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
  /*    Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.fromLTRB(10, 19, 10, 10),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(ColorConsts.orange),
                  Color(ColorConsts.orange)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: TextButton(

            onPressed: () {
              emailController.text="demouser@pixacart.com";
              passwordController.text="Pixacart@123";
            },
            child: Text(
              "Demo user",
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffffffff)),
            ),)
      ),*/
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(10, 19, 10, 20),
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
                                    Resource.of(context, tag!).strings.login,
                                    style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xffffffff)),
                                  ),
                                  onPressed: () => {
                                        if (emailController.text.isEmpty)
                                          {
                                            Fluttertoast.showToast(
                                                msg: Resource.of(context, tag!)
                                                    .strings
                                                    .enterUserEmailContinue,
                                                toastLength: Toast.LENGTH_SHORT,
                                                timeInSecForIosWeb: 1,

                                                backgroundColor: Colors.grey,
                                                textColor: Color(
                                                    ColorConsts.whiteColor),
                                                fontSize: 14.0),
                                          }
                                        else
                                          {
                                            if (passwordController.text.isEmpty)
                                              {
                                                Fluttertoast.showToast(
                                                    msg: Resource.of(
                                                            context, tag!)
                                                        .strings
                                                        .enterPassContinue,
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    textColor: Color(
                                                        ColorConsts.whiteColor),
                                                    fontSize: 14.0),
                                              }
                                            else
                                              {
                                                if (validateStructure(
                                                    passwordController.text))
                                                  {


                                                    setState(() {

                                                  isLoading=true;
                                                  }),
                                                    loginApi(),

                                                  }
                                                else
                                                  {
                                                    Fluttertoast.showToast(
                                                        msg: 'Invalid Password',
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.grey,
                                                        textColor: Color(
                                                            ColorConsts
                                                                .whiteColor),
                                                        fontSize: 14.0),
                                                  }
                                              }
                                          }
                                      }),
                            ),
                            Text(
                              Resource.of(context, tag!)
                                  .strings
                                  .dontHaveAnAccount,
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 15,
                                  color: Color(ColorConsts.grayColor)),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(ColorConsts.secondaryBtnColor),
                                      Color(ColorConsts.secondaryBtnColor)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: TextButton(
                                child: Text(
                                  Resource.of(context, tag!).strings.signin,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xffffffff)),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Signup()));
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 36, 14, 0),
                              alignment: Alignment.centerRight,
                              child: Text(canCheckBiometrics ? err : '',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans.ttf',
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: Color(ColorConsts.redColor))),
                            ),
                          ],
                        )),
                  ],
                )
              ],
            ),if(isLoading)Material(
                type: MaterialType
                    .transparency,

                child: Container(
                    alignment: Alignment.center,   
                    child: Container(
                  alignment: Alignment.center,
                    height: 89,
                    margin: EdgeInsets.all(21),
                    width:  MediaQuery.of(context).size.width-45,
                    color: Color(ColorConsts.whiteColorTrans),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <
                          Widget>[
                        SizedBox(height: 20,width: 20,child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(ColorConsts.pinkLytColor)), backgroundColor: Color(ColorConsts.primaryColor), strokeWidth: 4.0)),
                        Container(
                            margin: EdgeInsets.all(5),
                            child: Text(
                              Resource.of(context, tag!).strings.loadingPleaseWait,
                              style: TextStyle(color: Color(ColorConsts.primaryColor), fontFamily: 'OpenSans-Bold', fontWeight: FontWeight.w500, fontSize: 18),
                            )),
                      ],
                    ))

                ))
            ],))

    )

    );
  }
}
