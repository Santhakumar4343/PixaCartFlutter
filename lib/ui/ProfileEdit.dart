import 'dart:io';

import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/presenter/ProfilePresenter.dart';
import 'package:e_com/utils/Resource.dart';
import 'package:e_com/utils/SharedPref.dart';
import 'package:image_picker/image_picker.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Login.dart';

class ProfileEdit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}
class _State extends State<ProfileEdit> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();

  bool _passwordVisible = false;
String token='';
  bool hasData=false;
  final picker = ImagePicker();
  bool has = false,presentImage=true;
  late File _image;
  String _userPassError =
      'Should contain at least one upper case,lower case,at least one digit,at least one special character!';
  bool showError = false;

  Future<bool> logoutDialog(BuildContext context) async {

    return (await showDialog(
      context: context,
      builder: (context) =>  AlertDialog(
        elevation: 5,
        contentPadding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
        content: Container(height: 159,
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(ColorConsts.whiteColor),
                  Color(ColorConsts.whiteColor)

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

                            width: 84,
                            height:120,
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(6, 0, 0, 0),child: Image.asset(
                            'assets/icons/logouticon.png',
                            width: 84,
                            height: 120,

                          ),
                          ),
                            Align(child: Container(
                                width: 168,
                                height:178,
                                margin: EdgeInsets.fromLTRB(10, 12, 0, 0),
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child:  Column(
                                  children: [Text(Resource.of(context,tag!).strings.doYouWantToLogout,
                                    maxLines: 3,style: TextStyle(fontFamily: 'OpenSans-Bold',fontWeight: FontWeight.w500,fontSize:18
                                        ,color: Color(ColorConsts.blackColor)),),

                                    Stack(children: [
                                      Align(alignment: Alignment.centerLeft,child: InkResponse(
                                        onTap : () {
                                          sharePrefs.removeValues();
                                          Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (BuildContext context) =>
                                                      Login()),
                                                  (Route<dynamic> route) => false);
                                        }, // passing true
                                        child: Container(
                                            margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                            padding: EdgeInsets.fromLTRB(23, 8, 23, 8),
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(ColorConsts.primaryColor),
                                                    Color(ColorConsts.secondaryColor)

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
                                                  color: Color(ColorConsts.whiteColor)
                                              ),
                                            )),
                                      ),),
                                      Align(alignment: Alignment.centerRight,child:   InkResponse(
                                        onTap: () =>
                                            Navigator.pop(context, false), // passing false
                                        child: Container(
                                            margin: EdgeInsets.fromLTRB(0, 16,10, 0),
                                            padding: EdgeInsets.fromLTRB(23, 8, 23, 8),
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
                    child: Icon(Icons.clear,color: Color(ColorConsts.blackColor),size: 20),
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

  profileApiCall() async {
  await  ProfilePresenter().updateApi(context, token,  _userLoginModel.data.id, File(''),emailController.text, nameController.text, phoneController.text, passwordController.text
        , addressController.text,cityController.text,stateController.text,countryCodeController.text,postalCodeController.text);

  }
  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }
  _imgFromCamera() async {
    try {
      final pickedFile = await picker.getImage(
          source: ImageSource.camera, imageQuality: 100);

      final File file = File(pickedFile!.path);

      has = true;
      _image = file;
      setState(() {

      });
        await  ProfilePresenter().updateApi(context, _userLoginModel.data.token,  _userLoginModel.data.id, _image,emailController.text, nameController.text, phoneController.text, passwordController.text
            , addressController.text,cityController.text,stateController.text,countryCodeController.text,postalCodeController.text);

      Navigator.of(context).pop();
      getValue();
    }  catch (e) {
      Navigator.of(context).pop();

    }

  }

  _openGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 100);
    final File file = File(pickedFile!.path);

    has = true;
    _image = file;
    setState(() {

    });
   await ProfilePresenter().updateApi(context, _userLoginModel.data.token,  _userLoginModel.data.id, _image,emailController.text, nameController.text, phoneController.text, passwordController.text
            , addressController.text,cityController.text,stateController.text,countryCodeController.text,postalCodeController.text);
    Navigator.of(context).pop();
    getValue();
  }

  void slideSheet(String s) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
                color: Color(0xFF737373),
                child: Container(
                    height: 210,
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(12, 18, 10, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            Resource.of(context,tag!).strings.takeTheImage,
                            maxLines: 3,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'OpenSans-Bold',
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                                color: Color(ColorConsts.blackColor)),
                          ),Row(

                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkResponse(child: Column(children: [
                                Container(  padding: EdgeInsets.fromLTRB(0, 14, 0, 11),child: Image.asset(
                                  'assets/icons/cancelIcon.png',
                                  width: 65,
                                  height: 65,
                                  fit: BoxFit.fill,

                                ),
                                ),Text(
                                  Resource.of(context,tag!).strings.remove,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans-Bold',
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w400,
                                      color: Color(ColorConsts.lightGrayColor)),
                                )],),onTap: () {
                                  Navigator.pop(context);
                                },
                              )
                              ,  InkResponse(child:Column(children: [
                                Container(  padding: EdgeInsets.fromLTRB(0, 14, 0, 11),child: Image.asset(
                                  'assets/icons/cameraIcon.png',
                                  width: 65,
                                  height: 65,

                                ),
                                ),Text(
                                  Resource.of(context,tag!).strings.camera,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans-Bold',
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w400,
                                      color: Color(ColorConsts.lightGrayColor)),
                                )],),
                              onTap: () {
_imgFromCamera();
                              },),
                              InkResponse(child:Column(children: [
                                Container(  padding: EdgeInsets.fromLTRB(0, 14, 0, 11),child: Image.asset(
                                  'assets/icons/Gallery.png',
                                  width: 65,
                                  height: 65,

                                ),
                                ),Text(
                                  Resource.of(context,tag!).strings.gallery,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans-Bold',
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w400,
                                      color: Color(ColorConsts.lightGrayColor)),
                                )],
                              ),
                                onTap: () {
_openGallery();
                                },
                              )
                            ],)

                        ])
                )

            );
          }

          );
        }
    );
  }


  SharedPref sharePrefs = SharedPref();
  String? tag='';
  bool isLoad=true;
  late UserLoginModel _userLoginModel;


  Future<bool> getValue() async {

    _userLoginModel=await sharePrefs.getLoginUserData();
    token=_userLoginModel.data.token;
    tag= await sharePrefs.getLanguage();
   nameController.text=""+_userLoginModel.data.fullname;
   emailController.text=""+_userLoginModel.data.email;
   phoneController.text=""+_userLoginModel.data.mobile;
   addressController.text=""+_userLoginModel.data.address;

   cityController.text=_userLoginModel.data.city;
   postalCodeController.text=_userLoginModel.data.postal_code;
   countryCodeController.text=_userLoginModel.data.country;
   stateController.text=_userLoginModel.data.state;
   hasData=true;
setState(() {
  isLoad=true;

});
    return true;
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: /*FutureBuilder<bool>(
    future: getValue(),
    builder: (context,
    projectSnap) { if(projectSnap.hasData) {


    return */ListView(
            children: [
              Container(
                height: 58,
                padding: EdgeInsets.all(1),
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
                child: InkResponse(onTap: () {
Navigator.pop(context);
                },child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(9),
                    child: Image.asset(
                      'assets/icons/Arrow.png',
                      width: 23,
                      height: 23,
                      color: Color(ColorConsts.whiteColor),
                    ),
                  ),
                ),),
              ),
              Container(
                padding: EdgeInsets.all(1.0),
                margin: EdgeInsets.fromLTRB(8, 14, 12, 0),
                child: InkResponse(
                  onTap: () {},
                  child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(16, 18, 18, 12),
                    margin: EdgeInsets.fromLTRB(0, 8, 0, 9),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(ColorConsts.primaryColor),
                          Color(ColorConsts.secondaryColor)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage('assets/images/BGinprofile.png'),
                        fit: BoxFit.fill,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    child: Stack(children: [
                      if(hasData)Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(ColorConsts.primaryColorLyt),
                              Color(ColorConsts.primaryColorLyt),],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadiusDirectional.circular(6.0),
                          image: DecorationImage(
                            image: has?FileImage(_image)  as ImageProvider :(_userLoginModel.data.profile_image.isEmpty)?AssetImage('assets/images/user.png'):NetworkImage(_userLoginModel.data.profile_image)  as ImageProvider ,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                        width: 70,
                        height: 70,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
                      ),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: InkResponse(onTap: () {
                            slideSheet('');
                          },child: Container(
                            margin: EdgeInsets.fromLTRB(54, 0, 0, 0),
                            padding: EdgeInsets.all(4.6),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: Color(ColorConsts.secondaryBtnColor),
                            ),
                            child: Image.asset(
                              'assets/icons/edit.png',
                              width: 15,
                              height: 15,
                            ),
                          ))
                      ),
                      if(hasData)Container(
                        margin: EdgeInsets.fromLTRB(78, 0.5, 0, 9),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                (_userLoginModel.data.fullname.isEmpty)?'Not found':_userLoginModel.data.fullname,
                                maxLines: 1,
                                style: TextStyle(
                                    fontFamily: 'OpenSans-Bold',
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                    color: Color(ColorConsts.whiteColor)),
                              ),
                            ),
                            if(isLoad)if(!(_userLoginModel.data.email.isEmpty))Container(

                              alignment: Alignment.centerLeft,
                              child: RichText(

                                overflow: TextOverflow.ellipsis,
                                strutStyle: StrutStyle(
                                    fontSize: 11.0),
                                text: TextSpan(
                                    style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 15,
                                        color: Color(ColorConsts.whiteColor)),
                                    text: (_userLoginModel.data.email.isEmpty)?'Not found':_userLoginModel.data.email),


                                maxLines: 1,


                              ),
                            ),
                            if(isLoad)if(!(_userLoginModel.data.mobile.isEmpty))Container(

                              alignment: Alignment.centerLeft,
                              child: RichText(

                                overflow: TextOverflow.ellipsis,
                                strutStyle: StrutStyle(
                                    fontSize: 11.0),
                                text: TextSpan(
                                    style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 15,
                                        color: Color(ColorConsts.whiteColor)),
                                    text: (_userLoginModel.data.mobile.isEmpty)?'Not found':_userLoginModel.data.mobile),


                                maxLines: 1,


                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkResponse(
                          onTap: () {
                            // showDialog(context);
                            logoutDialog(context);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(ColorConsts.whiteColor),
                                    Color(ColorConsts.whiteColor)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius:
                                    BorderRadiusDirectional.circular(6.0),
                              ),
                              padding: EdgeInsets.all(2),

                              child: Icon(
                                Icons.power_settings_new,
                                color: Color(ColorConsts.primaryColor),
                              )),
                        ),
                      )
                    ]),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 22, 15, 0),
                    alignment: Alignment.centerLeft,
                    child: Text(Resource.of(context,tag!).strings.name,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'OpenSans.ttf',
                            fontSize: 17,
                            color: Color(ColorConsts.grayColor))),
                  ),
                  Container(
                    height: 37,
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),

                    child: new TextField(
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          color: Color(ColorConsts.blackColor),
                          fontSize: 17.0,
                          fontFamily: 'OpenSans'),
                      controller: nameController,
                      decoration: new InputDecoration(

                          hintText: Resource.of(context,tag!).strings.enterNameHere,
                          hintStyle: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16.0,
                              color: Color(ColorConsts.lightGrayColor)),
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    height: 0.2,
                    color: Color(ColorConsts.lightGrayColor),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 22, 15, 0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                       Resource.of(context,tag!).strings.phone
                            ,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'OpenSans.ttf',
                            fontSize: 17,
                            color: Color(ColorConsts.grayColor))),
                  ),
                  Container(
                    height: 37,
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),

                    child: new TextField(
                      keyboardType:  TextInputType.phone,

                      onChanged: (value) {
                        setState(() {});
                      },
                      style: TextStyle(
                          color: Color(ColorConsts.blackColor),
                          fontSize: 17.0,
                          fontFamily: 'OpenSans'),
                      controller: phoneController,
                      decoration: new InputDecoration(

                          suffixIconConstraints:
                          BoxConstraints(minHeight: 18, minWidth: 19),
                          hintText: true
                              ? Resource.of(context,tag!).strings.enterPhoneHere
                              : Resource.of(context,tag!)
                              .strings
                              .enterUserEmailHere,
                          hintStyle: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16.0,
                              color: Color(ColorConsts.lightGrayColor)),
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    height: 0.2,
                    color: Color(ColorConsts.lightGrayColor),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 22, 15, 0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                         Resource.of(context,tag!).strings.email,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'OpenSans.ttf',
                            fontSize: 17,
                            color: Color(ColorConsts.grayColor))),
                  ),
                  Container(
                    height: 37,
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),

                    child: new TextField(
                      keyboardType:  TextInputType.emailAddress,

                      style: TextStyle(
                          color: Color(ColorConsts.blackColor),
                          fontSize: 17.0,
                          fontFamily: 'OpenSans'),
                      controller: emailController,
                      decoration: new InputDecoration(

                          suffixIconConstraints:
                              BoxConstraints(minHeight: 18, minWidth: 19),
                          hintText:  Resource.of(context,tag!)
                                  .strings
                                  .enterUserEmailHere,
                          hintStyle: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16.0,
                              color: Color(ColorConsts.lightGrayColor)),
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    height: 0.2,
                    color: Color(ColorConsts.lightGrayColor),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(15, 22, 14, 0),
                    alignment: Alignment.centerLeft,
                    child: Text(Resource.of(context,tag!).strings.password,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'OpenSans.ttf',
                            fontSize: 17,
                            color: Color(ColorConsts.grayColor))),
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
                  Stack(
                    children: [
                      Container(
                        height: 37,
                        margin: EdgeInsets.fromLTRB(15, 0, 1, 0),
                        child: TextField(
obscureText: true,
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
                            hintText:
                                Resource.of(context,tag!).strings.enterPassHere,
                            hintStyle: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 16.0,
                                color: Color(ColorConsts.lightGrayColor)),

                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    height: 0.2,
                    color: Color(ColorConsts.lightGrayColor),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 22, 14, 0),
                    alignment: Alignment.centerLeft,
                    child: Text(Resource.of(context,tag!).strings.address+" Details",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'OpenSans.ttf',
                            fontSize: 17,
                            color: Color(ColorConsts.grayColor))),
                  ),
                  Stack(
                    children: [
                      Container(

                        margin: EdgeInsets.fromLTRB(15, 0, 1, 0),
                        child: TextField(
keyboardType: TextInputType.multiline,
                          minLines: 1,//Normal textInputField will be displayed
                          maxLines: 5,
controller: addressController,
                          style: TextStyle(
                              color: Color(ColorConsts.blackColor),
                              fontSize: 16.0,
                              fontFamily: 'OpenSans'),
                          decoration: new InputDecoration(
                            hintText:
                                Resource.of(context,tag!).strings.enterAddHere,
                            hintStyle: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 16.0,
                                color: Color(ColorConsts.lightGrayColor)),

                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    height: 0.2,
                    color: Color(ColorConsts.lightGrayColor),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 22, 14, 0),
                    alignment: Alignment.centerLeft,
                    child: Text("City",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'OpenSans.ttf',
                            fontSize: 17,
                            color: Color(ColorConsts.grayColor))),
                  ),
                  Container(

                    margin: EdgeInsets.fromLTRB(15, 0, 1, 0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,//Normal textInputField will be displayed
                      maxLines: 5,
                      controller: cityController,
                      style: TextStyle(
                          color: Color(ColorConsts.blackColor),
                          fontSize: 16.0,
                          fontFamily: 'OpenSans'),
                      decoration: new InputDecoration(
                        hintText:
                        "Enter City here",
                        hintStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 16.0,
                            color: Color(ColorConsts.lightGrayColor)),

                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    height: 0.2,
                    color: Color(ColorConsts.lightGrayColor),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 22, 14, 0),
                    alignment: Alignment.centerLeft,
                    child: Text("State",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'OpenSans.ttf',
                            fontSize: 17,
                            color: Color(ColorConsts.grayColor))),
                  ),
                  Container(

                    margin: EdgeInsets.fromLTRB(15, 0, 1, 0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,//Normal textInputField will be displayed
                      maxLines: 5,
                      controller: stateController,
                      style: TextStyle(
                          color: Color(ColorConsts.blackColor),
                          fontSize: 16.0,
                          fontFamily: 'OpenSans'),
                      decoration: new InputDecoration(
                        hintText:
                        "Enter State here",
                        hintStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 16.0,
                            color: Color(ColorConsts.lightGrayColor)),

                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    height: 0.2,
                    color: Color(ColorConsts.lightGrayColor),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 22, 14, 0),
                    alignment: Alignment.centerLeft,
                    child: Text("Country code (Like US for USA)",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'OpenSans.ttf',
                            fontSize: 17,
                            color: Color(ColorConsts.grayColor))),
                  ),
                  Container(

                    margin: EdgeInsets.fromLTRB(15, 0, 1, 0),
                    child: TextField(
                      textCapitalization: TextCapitalization.characters,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,//Normal textInputField will be displayed
                      maxLines: 5,
                      controller: countryCodeController,
                      style: TextStyle(
                          color: Color(ColorConsts.blackColor),
                          fontSize: 16.0,
                          fontFamily: 'OpenSans'),
                      decoration: new InputDecoration(
                        hintText:
                        "Enter country code here",
                        hintStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 16.0,
                            color: Color(ColorConsts.lightGrayColor)),

                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    height: 0.2,
                    color: Color(ColorConsts.lightGrayColor),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 22, 14, 0),
                    alignment: Alignment.centerLeft,
                    child: Text("Postal code or pin code or zip code",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'OpenSans.ttf',
                            fontSize: 17,
                            color: Color(ColorConsts.grayColor))),
                  ),
                  Container(

                    margin: EdgeInsets.fromLTRB(15, 0, 1, 0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,//Normal textInputField will be displayed
                      maxLines: 5,
                      controller: postalCodeController,
                      style: TextStyle(
                          color: Color(ColorConsts.blackColor),
                          fontSize: 16.0,
                          fontFamily: 'OpenSans'),
                      decoration: new InputDecoration(
                        hintText:
                        "Enter pin code or postal code or zip here",
                        hintStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 16.0,
                            color: Color(ColorConsts.lightGrayColor)),

                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    height: 0.2,
                    color: Color(ColorConsts.lightGrayColor),
                  ),




                  Container(
alignment: Alignment.center,
width: 150,
                    margin: EdgeInsets.fromLTRB(13, 30, 10, 20),
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
                          Resource.of(context,tag!)
                                  .strings
                                  .SubmitNow,

                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffffffff)),
                        ),
                        onPressed: () => {
                              if (nameController.text.isEmpty)
                                {
                                  Fluttertoast.showToast(
                                      msg: Resource.of(context,tag!)
                                          .strings
                                          .enterNameContinue,
                                      toastLength: Toast.LENGTH_SHORT,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.grey,
                                      textColor: Color(ColorConsts.whiteColor),
                                      fontSize: 14.0),
                                }
                              else
                                {
                                  if (phoneController.text.isEmpty)
                                    {
                                      Fluttertoast.showToast(
                                          msg:  Resource.of(context,tag!)
                                              .strings
                                              .enterPhoneContinue,
                                          toastLength: Toast.LENGTH_SHORT,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey,
                                          textColor:
                                          Color(ColorConsts.whiteColor),
                                          fontSize: 14.0),
                                    }else{
                                    if (emailController.text.isEmpty)
                                      {
                                        Fluttertoast.showToast(
                                            msg:  Resource.of(context,tag!)
                                                .strings
                                                .enterUserEmailContinue,
                                            toastLength: Toast.LENGTH_SHORT,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.grey,
                                            textColor:
                                            Color(ColorConsts.whiteColor),
                                            fontSize: 14.0),
                                      }
                                    else
                                      {
                                        if (RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(emailController.text))
                                          {

                                                    if (addressController.text.isEmpty)
                                                      {
                                                        Fluttertoast.showToast(
                                                            msg: Resource.of(
                                                                context,tag!)
                                                                .strings
                                                                .enterAddContinue,
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            timeInSecForIosWeb: 1,
                                                            backgroundColor:
                                                            Colors.grey,
                                                            textColor: Color(
                                                                ColorConsts
                                                                    .whiteColor),
                                                            fontSize: 14.0),
                                                      }else{
                                                      if(token.isEmpty){
                                                        Fluttertoast.showToast(
                                                            msg: 'Try Again!',
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            timeInSecForIosWeb: 1,
                                                            backgroundColor: Colors.grey,
                                                            textColor:
                                                            Color(ColorConsts.whiteColor),
                                                            fontSize: 14.0),
                                                      }else
                                                        {
                                                          if(passwordController
                                                              .text.isEmpty){
                                                            profileApiCall(),
                                                          } else
                                                            {
                                                              if (validateStructure(
                                                                  passwordController
                                                                      .text)) {
                                                                profileApiCall(),
                                                              } else
                                                                {
                                                                  setState(() {
                                                                    showError =
                                                                    true;
                                                                  }),

                                                                }
                                                            }
                                                        }



                                                    }



                                          }
                                        else
                                          {
                                            Fluttertoast.showToast(
                                                msg: Resource.of(context,tag!)
                                                    .strings
                                                    .incorrectEmail,
                                                toastLength: Toast.LENGTH_SHORT,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.grey,
                                                textColor:
                                                Color(ColorConsts.whiteColor),
                                                fontSize: 14.0),
                                          }
                                      }
                                  }

                                }
                            }),
                  ),


                ],
              )
            ],
          ),


        )

        )


    );
  }
}


