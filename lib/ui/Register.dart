import 'dart:convert';

import 'package:e_com/model/UserModelVerify.dart';
import 'package:e_com/presenter/SignupPresenter.dart';
import 'package:e_com/ui/Login.dart';
import 'package:e_com/utils/AppConstant.dart';
import 'package:e_com/utils/ConnectionCheck.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:e_com/utils/Resource.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:async';

import '../utils/SharedPref.dart';
import 'otp.dart';

class Signup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<Signup> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfController = TextEditingController();
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  String _userPassError =
      'Should contain at least one upper case,lower case,at least one digit,at least one special character!';
  bool showError = false;
  bool monVal = false;
  bool _passwordVisible = false;
  bool _passwordConfVisible = false;
  String version = '';
  String buildNumber = '';
  bool isPhone = false;
  String _message = "Not Authorized";
  bool isLoading= false;
  bool canCheckBiometrics = false;
  late String fcmToken ='';
  String err = '';

  SharedPref sharePrefs = SharedPref();
  String? tag = '';

  Future<void> getValue() async {
    tag = await sharePrefs.getLanguage();
    fcmToken =(await FirebaseMessaging.instance.getToken())!;
    print('---------------------FCM----------------------------------------------$fcmToken');
    setState(() {});
  }

  Future<void> RegisApiCall() async {
    setState(() {
    });
    UserModel loginModel=await SignupPresenter().getRegister(context,nameController.text,emailController.text,passwordController.text,emailController.text,fcmToken);

    isLoading=false;
    if(loginModel.status.toString().contains("1")){
      sharePrefs.setUserData(loginModel.data.id+","+loginModel.data.verify_otp);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return    otp(emailController.text.toString(),loginModel.data.verify_otp);
      },));
    }else{
      isLoading=false;
      setState(() {
      });
    }



  }

  void processed() {
    if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: Resource.of(context, tag!).strings.enterPassContinue,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Color(ColorConsts.whiteColor),
          fontSize: 14.0);
    } else {
      if (validateStructure(passwordController.text)) {
        if (passwordConfController.text.isEmpty) {
          Fluttertoast.showToast(
              msg: Resource.of(context, tag!).strings.enterConPassContinue,
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Color(ColorConsts.whiteColor),
              fontSize: 14.0);
        } else {
          if (passwordConfController.text.compareTo(passwordController.text) != 0) {
            Fluttertoast.showToast(
                msg: 'Password not matched',
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Color(ColorConsts.whiteColor),
                fontSize: 14.0);
          } else {
isLoading=true;
RegisApiCall();


          }
        }
      } else {
        showError = true;
        setState(() {});
      }
    }
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  void initState() {
    getValue();
    checkingForBioMetrics();
    _passwordVisible = false;
    _passwordConfVisible = false;
    ConnectionCheck().checkConnection();
    super.initState();
  }

  Future<bool> checkingForBioMetrics() async {
    canCheckBiometrics = await _localAuthentication.canCheckBiometrics;

    return canCheckBiometrics;
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
      err = e.toString().contains(',') ? e.toString().split(',')[1] : '';

      setState(() {});
    }
    if (!mounted) return;
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
                    Resource.of(context, tag!).strings.registerNow,
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
                    Resource.of(context, tag!).strings.SignUpToGetStarted,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 22.5,
                        color: Color(ColorConsts.whiteColor)),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 56),
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
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 59),
                        margin: EdgeInsets.fromLTRB(15, 35, 15, 50),
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
                                  Resource.of(context, tag!).strings.name,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans.ttf',
                                      fontSize: 17,
                                      color: Color(ColorConsts.grayColor))),
                            ),
                            Container(
                              height: 40,
                              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              decoration: new BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(ColorConsts.whiteColor),
                                      Color(ColorConsts.whiteColor)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: new TextField(
                                keyboardType: TextInputType.emailAddress,

                                style: TextStyle(
                                    color: Color(ColorConsts.blackColor),
                                    fontSize: 17.0,
                                    fontFamily: 'OpenSans'),
                                controller: nameController,
                                decoration: new InputDecoration(
                                    isDense: true,
                                    suffixIcon: Image.asset(
                                      'assets/icons/user.png',
                                      height: 5.0,
                                      width: 5.0,
                                      color: Color(ColorConsts.blackColor),
                                    ),
                                    suffixIconConstraints: BoxConstraints(
                                        minHeight: 18, minWidth: 19),
                                    hintText: Resource.of(context, tag!)
                                        .strings
                                        .enterNameHere,
                                    hintStyle: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 15.0,
                                        color:
                                            Color(ColorConsts.lightGrayColor)),
                                    border: InputBorder.none),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              height: 0.5,
                              color: Color(ColorConsts.lightGrayColor),
                            ),
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
                              decoration: new BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(ColorConsts.whiteColor),
                                      Color(ColorConsts.whiteColor)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: new TextField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(isPhone?10:50),
                                ]
                                ,
                                keyboardType: isPhone
                                    ? TextInputType.phone
                                    : TextInputType.emailAddress,

                                onChanged: (value) {
                                  setState(() {});
                                },

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
                                        minHeight: 18, minWidth: 19),
                                    hintText: isPhone
                                        ? Resource.of(context, tag!)
                                            .strings
                                            .enterPhoneHere
                                        : Resource.of(context, tag!)
                                            .strings
                                            .enterUserEmailHere,
                                    hintStyle: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 15.0,
                                        color:
                                            Color(ColorConsts.lightGrayColor)),
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
                                        ? 'Register with an email'
                                        : 'or register with phone number',
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
                              margin: EdgeInsets.fromLTRB(15, 6, 14, 0),
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
                                  margin: EdgeInsets.fromLTRB(15, 0, 1, 0),
                                  child: TextField(
                                    obscureText: !_passwordVisible,
                                    controller: passwordController,
                                    onChanged: (String value) {
                                      showError = false;
                                      setState(() {});
                                    },
                                    style: TextStyle(
                                        color: Color(ColorConsts.blackColor),
                                        fontSize: 17.0,
                                        fontFamily: 'OpenSans'),
                                    decoration: new InputDecoration(
                                      isDense: true,
                                      hintText: Resource.of(context, tag!)
                                          .strings
                                          .enterPassHere,
                                      hintStyle: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontSize: 15.0,
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
                                )
                              ],
                            ),
                            if (showError)
                              Container(
                                margin: EdgeInsets.fromLTRB(15, 1, 14, 2),
                                alignment: Alignment.centerLeft,
                                child: Text(_userPassError,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontFamily: 'OpenSans.ttf',
                                        fontSize: 11,
                                        fontStyle: FontStyle.italic,
                                        color: Color(ColorConsts.redColor))),
                              ),
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              height: 0.5,
                              color: Color(ColorConsts.lightGrayColor),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 22, 14, 0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  Resource.of(context, tag!)
                                      .strings
                                      .confirmPass,
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
                                  margin: EdgeInsets.fromLTRB(15, 0, 1, 0),
                                  child: TextField(
                                    obscureText: !_passwordConfVisible,
                                    controller: passwordConfController,
                                    style: TextStyle(
                                        color: Color(ColorConsts.blackColor),
                                        fontSize: 17.0,
                                        fontFamily: 'OpenSans'),
                                    decoration: new InputDecoration(
                                      hintText: Resource.of(context, tag!)
                                          .strings
                                          .enterConPassHere,
                                      hintStyle: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontSize: 15.0,
                                          color: Color(
                                              ColorConsts.lightGrayColor)),
                                      suffixIcon: IconButton(
                                          icon: _passwordConfVisible
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
                                            if (_passwordConfVisible) {
                                              _passwordConfVisible = false;
                                            } else {
                                              _passwordConfVisible = true;
                                            }
                                            setState(() {});
                                          }),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              height: 0.5,
                              color: Color(ColorConsts.lightGrayColor),
                            ),
                           /* InkResponse(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(1, 25, 0, 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/fingerprint.png',
                                      width: 19,
                                      height: 20.5,
                                    ),
                                    Text('  Authanticate to continue',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: 'OpenSans.ttf',
                                            fontSize: 15,
                                            fontStyle: FontStyle.normal,
                                            color:
                                                Color(ColorConsts.blackColor)))
                                  ],
                                ),
                              ),
                              onTap: () {
                                if (canCheckBiometrics) {
                                  if (canCheckBiometrics) {
                                    _authenticateMe();
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Not supported by device!',
                                      toastLength: Toast.LENGTH_SHORT,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.grey,
                                      textColor: Color(ColorConsts.whiteColor),
                                      fontSize: 14.0);
                                }
                              },
                            ),*/
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 2, 14, 0),
                              alignment: Alignment.center,
                              child: Text(canCheckBiometrics ? err : '',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans.ttf',
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                      color: Color(ColorConsts.redColor))),
                            ),
                            if (isPhone)
                              Container(
                                margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                                child: Text(
                                  'We will send you an OTP to register your phone number',
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 14,
                                      color: Color(ColorConsts.grayColor)),
                                ),
                              ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
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
                                    isPhone
                                        ? Resource.of(context, tag!)
                                            .strings
                                            .Registerwithphonenumber
                                        : Resource.of(context, tag!)
                                            .strings
                                            .register,
                                    style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xffffffff)),
                                  ),
                                  onPressed: () async => {
                                        if (await ConnectionCheck()
                                            .checkConnection())
                                          {
                                            if (nameController.text.isEmpty)
                                              {
                                                Fluttertoast.showToast(
                                                    msg: Resource.of(
                                                            context, tag!)
                                                        .strings
                                                        .enterNameContinue,
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
                                                if (emailController
                                                    .text.isEmpty)
                                                  {
                                                    Fluttertoast.showToast(
                                                        msg: isPhone
                                                            ? Resource.of(
                                                                    context,
                                                                    tag!)
                                                                .strings
                                                                .enterPhoneContinue
                                                            : Resource.of(
                                                                    context,
                                                                    tag!)
                                                                .strings
                                                                .enterUserEmailContinue,
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
                                                else
                                                  {
                                                    if (isPhone)
                                                      {

                                                        if (RegExp(r'^-?[0-9]+$').hasMatch(emailController.text) && emailController.text.length > 6)
                                                          {
                                                            processed(),
                                                          }
                                                        else
                                                          {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Enter Valid Mobile Number !',
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    Colors.grey,
                                                                textColor: Color(
                                                                    ColorConsts
                                                                        .whiteColor),
                                                                fontSize: 14.0),
                                                          }
                                                      }
                                                    else
                                                      {
                                                        if (RegExp(
                                                                r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                                            .hasMatch(
                                                                emailController
                                                                    .text))
                                                          {
                                                            processed(),
                                                          }
                                                        else
                                                          {
                                                            Fluttertoast.showToast(
                                                                msg: Resource.of(
                                                                        context,
                                                                        tag!)
                                                                    .strings
                                                                    .incorrectEmail,
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    Colors.grey,
                                                                textColor: Color(
                                                                    ColorConsts
                                                                        .whiteColor),
                                                                fontSize: 14.0),
                                                          }
                                                      }
                                                  }
                                              }
                                          } // if connection close
                                      }),
                            ),
                            Text(
                              Resource.of(context, tag!)
                                  .strings
                                  .alreadyhaveanaccount,
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
                                  Resource.of(context, tag!).strings.login,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xffffffff)),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Login()));
                                },
                              ),
                            ),
                          ],
                        )),
                  ],
                )
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

            ],)
        ));
  }
}
