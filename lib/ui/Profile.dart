import 'dart:convert';
import 'dart:io';
import 'package:e_com/localdb/AppDatabase.dart';
import 'package:e_com/localdb/ListEntity.dart';
import 'package:e_com/model/ModelOrder.dart';
import 'package:e_com/model/ModelSettings.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/presenter/PaymetDetailPresenter.dart';
import 'package:e_com/utils/ConnectionCheck.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:e_com/ui/OrderList.dart';
import 'package:e_com/ui/ProfileEdit.dart';
import 'package:e_com/ui/Review.dart';
import 'package:e_com/ui/WishList.dart';
import 'package:e_com/utils/Resource.dart';
import 'package:e_com/utils/SharedPref.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Login.dart';
import 'MyCart.dart';
import 'Notifications.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class LanguageDetails {
  const LanguageDetails({ required this.title,  required this.i});
  final String title;
  final String i;
}

class _State extends State<Profile> {

  SharedPref sharePrefs = SharedPref();
  String? tag='';
  late UserLoginModel _userLoginModel;
  late final access;
  late final database;
  String cartLength="0",wishListLength='0',myOrderLen="0";
  bool hasData=false;

  Future<bool> getValue() async {
    tag= await sharePrefs.getLanguage();
    _userLoginModel=await sharePrefs.getLoginUserData();

    bool check= await ConnectionCheck()
        .checkConnection();
    await PaymetDetailPresenter().get(_userLoginModel.data.token);
    getWishList();
    return true;
  }
Future<void> getWishList() async {
  hasData=true;
  String? sett = await sharePrefs.getSettings();
  final Map<String, dynamic> parsed = json.decode(sett!);
  ModelSettings modelSettings = ModelSettings.fromJson(parsed);
  if((modelSettings.data.wishlist_count-1)> 0) {
    wishListLength = (modelSettings.data.wishlist_count - 1).toString();
  }

  myOrderLen=modelSettings.data.myorder_count.toString();
    setState(() {

    });
}
  @override
  void initState() {
    initDb();
    getValue();

    super.initState();
  }

  Future<void> initDb() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    access = database.daoaccess;
    refreshDb();
  }
  Future<void> refreshDb() async {
    List<ListEntity> listdata = await access.getAll();
    cartLength=listdata.length.toString();

    setState(() {

    });
  }
  void _reload() {

   getValue();
  }
  Future<bool> zoom(BuildContext context, String s) async {
    return (await showDialog(
        context: context,
        builder: (context) =>  AlertDialog(
      elevation: 5,
          backgroundColor: Color(0x27ffffff),
      contentPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0.0))
      ),
      content: Container(height: 300,
        child:  Align(
            alignment: Alignment.centerLeft,
            child: Stack(
              children: [
                Align(alignment: Alignment.center,child: Text('Loading..',
                  maxLines: 3,style: TextStyle(fontFamily: 'OpenSans-Bold',fontWeight: FontWeight.w500,fontSize:18
                      ,color: Color(ColorConsts.whiteColor)),)
                )
                ,Container(height: 300,

          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffffff),
                Color(0x2ffffff)

              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,

            ),
            image: DecorationImage(
              image:NetworkImage(s)
              ,
              fit: BoxFit.fill,
              alignment: Alignment.topCenter,
            ),
          ),
                )
                ,
                Align(alignment: Alignment.topRight,child: InkResponse(child:  Container(
                  margin: EdgeInsets.all(4),
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
                    'assets/images/backInPopup.png'),
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




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
      child:  Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:Stack(children: [  Container(
    height: 58,
    padding: EdgeInsets.all(1),
    width: MediaQuery
        .of(context)
        .size
        .width,
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
        image: AssetImage(
            'assets/images/BGheader.png')
        ,
        fit: BoxFit.fill,
        alignment: Alignment.topCenter,
      ),),

    child: Stack(
      children: [

        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.fromLTRB(8, 0, 0, 0), child:
          Text(Resource
              .of(context, tag!)
              .strings
              .profile, textAlign: TextAlign.center, style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(ColorConsts.whiteColor)
          )
          ),
          ),
        ),


      ],)
),if(hasData)ListView(children: [
  Container(
    padding: EdgeInsets.all(1.0),
    margin: EdgeInsets.fromLTRB(8, 64, 8, 0),
    child:
    InkResponse(
      onTap: () {

      },
      child: Container(
        height: 100,
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.fromLTRB(16, 18, 18, 12),
        margin: EdgeInsets.fromLTRB(4, 8, 4, 9),
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
            image: AssetImage(
                'assets/images/BGinprofile.png')
            ,
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
          ),),
        child: Stack(
            children: [
              InkResponse(onTap: () {
                if(_userLoginModel.data.profile_image.toString().isNotEmpty){
                  zoom(context,""+_userLoginModel.data.profile_image);}
              },child:  Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(ColorConsts.primaryColorLyt),
                      Color(ColorConsts.primaryColorLyt),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius:
                  BorderRadiusDirectional.circular(6.0),
                ),
                width: 70,
                height: 70,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
                child:  (_userLoginModel.data.profile_image.isNotEmpty)?ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: FancyShimmerImage(
                    imageUrl:_userLoginModel.data.profile_image ,
                    boxFit: BoxFit.cover,
                  ),
                ) : Image.asset('assets/icons/user.png')
              ),
              ),


              Container(
                margin: EdgeInsets.fromLTRB(78, 0, 0, 9),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        (_userLoginModel.data.fullname.isEmpty)
                            ? 'Not found'
                            : _userLoginModel.data.fullname
                        ,
                        maxLines: 1,
                        style: TextStyle(
                            fontFamily: 'OpenSans-Bold',
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                            color: Color(ColorConsts.whiteColor)),
                      ),
                    ),
                    if(!(_userLoginModel.data.email.isEmpty))Container(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(
                            fontSize: 11.0),
                        text: TextSpan(
                            style: TextStyle(
                                fontFamily: 'OpenSans-Bold',
                                fontSize: 15,
                                color: Color(ColorConsts.whiteColor)),
                            text: (_userLoginModel.data.email.isEmpty)
                                ? 'Not found'
                                : _userLoginModel.data.email),
                        maxLines: 1,


                      ),
                    ),
                    if(!(_userLoginModel.data.mobile.isEmpty))Container(

                      alignment: Alignment.centerLeft,
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(
                            fontSize: 11.0),
                        text: TextSpan(
                            style: TextStyle(
                                fontFamily: 'OpenSans-Bold',
                                fontSize: 15,
                                color: Color(ColorConsts.whiteColor)),
                            text: (_userLoginModel.data.mobile.isEmpty)
                                ? 'Not found'
                                : _userLoginModel.data.mobile),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              )

              ,

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
                      )

                  ),


                ),
              )
            ]
        ),
      ),
    ),
  ),
  Stack(

    children: [
      InkResponse(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return MyCart();
              },));
        }, child: Container(
        margin: EdgeInsets.fromLTRB(14, 12, 0, 0),
        height: 100,
        width: 110,
        alignment: Alignment.center,

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(ColorConsts.pinkLytColor),
              Color(ColorConsts.pinkLytColor)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(8.0),),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                cartLength,
                maxLines: 1,
                style: TextStyle(
                    fontFamily: 'OpenSans-Bold',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConsts.primaryColor)),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: RichText(
                overflow: TextOverflow.ellipsis,
                strutStyle: StrutStyle(
                    fontSize: 11.0),
                text: TextSpan(
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 15.5,
                        color: Color(ColorConsts.blackColor)),
                    text: Resource
                        .of(context, tag!)
                        .strings
                        .MyCart),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
      ),
      Align(child: InkResponse(onTap: () {

        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return WishList('');
        },)).then((value) => _reload());

      }, child: Container(
        margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
        height: 100,
        width: 110,
        alignment: Alignment.center,

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(ColorConsts.pinkLytColor),
              Color(ColorConsts.pinkLytColor)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(8.0),),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,

              child: Text(
                wishListLength,
                maxLines: 1,
                style: TextStyle(
                    fontFamily: 'OpenSans-Bold',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConsts.primaryColor)),
              ),
            ),
            Container(
              alignment: Alignment.center,

              child: RichText(

                overflow: TextOverflow.ellipsis,
                strutStyle: StrutStyle(
                    fontSize: 11.0),
                text: TextSpan(
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 15.5,
                        color: Color(ColorConsts.blackColor)),
                    text: Resource
                        .of(context, tag!)
                        .strings
                        .MyWishlist),
                maxLines: 1,


              ),
            ),
          ],
        ),
      ),
      ),
        alignment: Alignment.center,),
      Align(child:
      InkResponse(onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return OrderList();
        },));
      }
        , child:
        Container(

          margin: EdgeInsets.fromLTRB(0, 12, 14, 0),
          height: 100,
          width: 110,


          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(ColorConsts.pinkLytColor),
                Color(ColorConsts.pinkLytColor)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(8.0),),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  myOrderLen,
                  maxLines: 1,
                  style: TextStyle(
                      fontFamily: 'OpenSans-Bold',
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConsts.primaryColor)),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  strutStyle: StrutStyle(
                      fontSize: 11.0),
                  text: TextSpan(
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 15.5,
                          color: Color(ColorConsts.blackColor)),
                      text: Resource
                          .of(context, tag!)
                          .strings
                          .MyOrders),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),),
        alignment: Alignment.centerRight,)
    ],),


  InkResponse(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return ProfileEdit();
      },)).then((value) {
        debugPrint(value);
        _reload();
      });
      setState(() {});
    },
    child: Container(
      height: 46,
      width: MediaQuery
          .of(context)
          .size
          .width,
      padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
      margin: EdgeInsets.fromLTRB(14, 22, 14, 7),
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
          image: AssetImage(
              'assets/images/BGinprofile.png')
          ,
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
        ),),
      child: Stack(

          children: [

            Container(


              width: 18,
              height: 18,
              child: Image.asset(
                'assets/icons/user.png',
                color: Color(ColorConsts.whiteColor),),

            ),


            Container(
              margin: EdgeInsets.fromLTRB(28, 0, 0, 0),

              child: Column(
                children: [
                  Container(

                    alignment: Alignment.centerLeft,
                    child: Text(
                      Resource
                          .of(context, tag!)
                          .strings
                          .editProfile,
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: 'OpenSans-Bold',
                          fontSize: 17.0,

                          color: Color(ColorConsts.whiteColor)),
                    ),
                  ),

                ],
              ),
            )

            ,

            Align(
              alignment: Alignment.topRight,
              child: Container(

                margin: EdgeInsets.fromLTRB(0, 2, 12, 0),

                child: Image.asset(
                  'assets/icons/DownIcon.png', width: 9,
                  color: Color(ColorConsts.whiteColor),),

              ),


            ),

          ]
      ),

    ),
  ),
  InkResponse(
    onTap: () {
      // showDialog(context);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return Notifications();
      },));
    },
    child: Container(
      height: 46,
      width: MediaQuery
          .of(context)
          .size
          .width,
      padding: EdgeInsets.fromLTRB(16, 11.5, 0, 11.5),
      margin: EdgeInsets.fromLTRB(14, 10, 14, 7),
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
          image: AssetImage(
              'assets/images/BGinprofile.png')
          ,
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
        ),),
      child: Stack(

          children: [

            Container(


              width: 18,
              height: 18,
              child: Image.asset(
                'assets/icons/bell.png',
                color: Color(ColorConsts.whiteColor),),

            ),


            Container(
              margin: EdgeInsets.fromLTRB(28, 0, 0, 0),

              child: Column(
                children: [
                  Container(

                    alignment: Alignment.centerLeft,
                    child: Text(
                      Resource
                          .of(context, tag!)
                          .strings
                          .MyNotifications

                      ,
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: 'OpenSans-Bold',
                          fontSize: 17.0,

                          color: Color(ColorConsts.whiteColor)),
                    ),
                  ),

                ],
              ),
            )

            ,

            Align(
                alignment: Alignment.topRight,
                child: Container(

                  margin: EdgeInsets.fromLTRB(0, 2, 12, 0),

                  child: Image.asset(
                    'assets/icons/DownIcon.png', width: 9,
                    color: Color(ColorConsts.whiteColor),),


                )
            )
          ]
      ),
    ),
  ),
  InkResponse(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return Review();
      },));
    },
    child: Container(
      height: 46,
      width: MediaQuery
          .of(context)
          .size
          .width,
      padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
      margin: EdgeInsets.fromLTRB(14, 10, 14, 19),
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
          image: AssetImage(
              'assets/images/BGinprofile.png')
          ,
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
        ),),
      child: Stack(

          children: [

            Container(


              width: 18,
              height: 18,
              child: Image.asset(
                'assets/icons/star.png',
                color: Color(ColorConsts.whiteColor),),

            ),


            Container(
              margin: EdgeInsets.fromLTRB(28, 0, 0, 0),

              child: Column(
                children: [
                  Container(

                    alignment: Alignment.centerLeft,
                    child: Text(
                      Resource
                          .of(context, tag!)
                          .strings
                          .reviews

                      ,
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: 'OpenSans-Bold',
                          fontSize: 17.0,

                          color: Color(ColorConsts.whiteColor)),
                    ),
                  ),

                ],
              ),
            )

            ,

            Align(
              alignment: Alignment.topRight,
              child: Container(

                margin: EdgeInsets.fromLTRB(0, 2, 12, 0),

                child: Image.asset(
                  'assets/icons/DownIcon.png', width: 9,
                  color: Color(ColorConsts.whiteColor),),

              ),


            ),
          ]
      ),
    ),
  )




]
)
  ,if(!hasData)Material(
          type: MaterialType
          .transparency,
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,

alignment: Alignment.center,
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: <
                    Widget>[
                  SizedBox(
                      child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation(
                              Color(ColorConsts
                                  .primaryColor)),
                          backgroundColor: Color(
                              ColorConsts.primaryColorLyt),
                          strokeWidth: 4.0)),
                  Container(
                      margin: EdgeInsets.all(7),
                      child: Text(
                        Resource.of(context, tag!).strings.loadingPleaseWait,
                        style: TextStyle(color: Color(ColorConsts.primaryColor), fontFamily: 'OpenSans-Bold', fontWeight: FontWeight.w500, fontSize: 18),
                      )),
                ],
              )))],)

)
  ),


    );








  }

}

