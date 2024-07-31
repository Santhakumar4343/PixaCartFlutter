import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/ui/ChooseLanguage.dart';
import 'package:e_com/ui/CustomerSupport.dart';
import 'package:e_com/ui/HelpCenter.dart';
import 'package:e_com/ui/MyCart.dart';
import 'package:e_com/ui/OrderList.dart';
import 'package:e_com/ui/PrivacyPolicy.dart';
import 'package:e_com/ui/WishList.dart';
import 'package:e_com/utils/Resource.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/SharedPref.dart';
import 'Login.dart';
import 'Notifications.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'Search.dart';

class Menu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}


class _State extends State<Menu> {

String isSelected="profile";
Future<void> _makePhoneCall(String phoneNumber) async {

  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launch(launchUri.toString());
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
      content: Container(height: 250,

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
        child:  Align(
            alignment: Alignment.centerLeft,
            child: Stack(
              children: [
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

                          width: 82,
                          height:120,
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(6, 0, 0, 0),child: Image.asset(
                          'assets/icons/logouticon.png',
                          width: 82,
                          height: 120,

                        ),
                        ),
                          Align(child: Container(
                              width: 168,
                              height:178,
                              margin: EdgeInsets.fromLTRB(10, 12, 0, 0),
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child:  Column(
                                children: [Text('Are you sure you want to logout ?',
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

SharedPref sharePrefs = SharedPref();
String? tag='';
late UserLoginModel _userLoginModel;
Future<bool> getValue() async {
  tag= await sharePrefs.getLanguage();
  _userLoginModel=await sharePrefs.getLoginUserData();
  print('--------------------------------------->>>'+_userLoginModel.data.fullname);

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
      child: Material(
      child:  Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
child: ListView(children: [
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
    image: AssetImage(
    'assets/images/BGheader.png')
  ,
  fit: BoxFit.fill,
  alignment: Alignment.topCenter,
),),

    child: Stack(
      children: [


        InkResponse(
          onTap: () {

            Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => Search()),
        );

          },
          child:  Container(
          height: 43,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.fromLTRB(8, 6, 50, 0),
          padding: EdgeInsets.fromLTRB(5, 0, 6, 0),
          decoration: new BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(ColorConsts.whiteColor),
                  Color(ColorConsts.whiteColor)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              border: Border.all(
                  color: Color(ColorConsts.lightGrayColor), width: 0.5),
              borderRadius: BorderRadius.circular(4.0)),
          child: Stack(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin: EdgeInsets.fromLTRB(8, 0,2, 0),
                        child: Text(
                          Resource.of(context,tag!).strings.search,
                          maxLines: 1,
                          style: TextStyle(

                              fontFamily: 'OpenSans',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(ColorConsts.lightGrayColor)),
                        ))),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 13, 5, 13),
                    child: Image(
                      image: AssetImage('assets/icons/SearchIcon.png'),
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
            margin: EdgeInsets.fromLTRB(1, 6, 4, 5),
            decoration: new BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(ColorConsts.whiteColor),
                    Color(ColorConsts.whiteColor)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                border: Border.all(
                    color: Color(ColorConsts.grayColor), width: 0.8),
                borderRadius: BorderRadius.circular(4.0)
            ),
            child:
                  InkResponse(onTap: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => Search()),
                    );
                  },child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Image(
                        image: AssetImage('assets/icons/mic.png'), color: Color(ColorConsts.grayColor)
                      ),
                    ),
                  )


            ),
          ),
          alignment: Alignment.topRight,
        ),

    ],)
  ),


        FutureBuilder<bool>(
    future: getValue(),
    builder: (context,
    projectSnap) { if(projectSnap.hasData) {
      return Container(

        padding: EdgeInsets.all(1.0),
        margin: EdgeInsets.fromLTRB(8, 14, 8, 0),

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
            padding: EdgeInsets.fromLTRB(16, 18, 0, 12),
            margin: EdgeInsets.fromLTRB(0, 6, 0, 9),
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
                  },child: Container(
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

                   child:  ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: FancyShimmerImage(
                        imageUrl:_userLoginModel.data.profile_image ,
                        boxFit: BoxFit.cover,
                      ),
                    ) ,
                  ),
                  ),


                  Container(
                    margin: EdgeInsets.fromLTRB(78, 1, 0, 9),

                    child: Column(
                      children: [
                        Container(

                          alignment: Alignment.centerLeft,
                          child: Text(
                            (_userLoginModel.data.fullname.isEmpty)
                                ? 'Not found'
                                : _userLoginModel.data.fullname,
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
                                    fontFamily: 'OpenSans',
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
                                    fontFamily: 'OpenSans',
                                    fontSize: 14,
                                    color: Color(ColorConsts.whiteColor)),
                                text: (_userLoginModel.data.mobile.isEmpty)
                                    ? 'Not found'
                                    : _userLoginModel.data.mobile),


                            maxLines: 1,


                          ),
                        ),
                      ],
                    ),
                  ),

                ]
            ),
          ),
        ),
      );
    }
    return Container();
    }),


  Container(
    height: 46,
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
    margin: EdgeInsets.fromLTRB(10, 10, 10, 7),
    decoration: BoxDecoration(
      gradient: (isSelected.contains(Resource.of(context,tag!)
          .strings
          .MyOrders))?LinearGradient(
        colors: [
          Color(ColorConsts.primaryColor),
          Color(ColorConsts.secondaryColor)
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ):null,
      borderRadius: BorderRadius.circular(8.0),

    )
      ,
    child: InkResponse(
      onTap: () {
        isSelected=Resource.of(context,tag!)
            .strings
            .MyOrders;
        setState(() {

        });
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return OrderList();
        },));
      },
      child:  Stack(

        children: [

          Container(
            width: 18,
            height: 18,
            child: Image.asset(
                'assets/icons/Order.png',color:(isSelected.contains(Resource.of(context,tag!)
                .strings
                .MyOrders))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

          ),



          Container(
            margin: EdgeInsets.fromLTRB(28, 0, 0, 0),

            child: Column(
              children: [
                Container(

                  alignment: Alignment.centerLeft,
                  child: Text(
                    Resource.of(context,tag!)
                        .strings
                        .MyOrders,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 16.0,

                        color: (isSelected.contains(Resource.of(context,tag!)
                            .strings
                            .MyOrders))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor), ),
                  ),
                ),

              ],
            ),
          )

          ,

          Align(
            alignment: Alignment.topRight,
            child:Container(

                 margin: EdgeInsets.fromLTRB(0, 3, 12, 0),

                  child:Image.asset(
                    'assets/icons/DownIcon.png',width: 7,color: (isSelected.contains(Resource.of(context,tag!)
                      .strings
                      .MyOrders))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

              ),


            ),

        ]
    ),
    )
  ),
  Container(
    height: 46,
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
    margin: EdgeInsets.fromLTRB(10, 10, 10, 7),

    decoration: BoxDecoration(
      gradient: (isSelected.contains(Resource.of(context,tag!)
          .strings
          .MyCart))?LinearGradient(
        colors: [
          Color(ColorConsts.primaryColor),
          Color(ColorConsts.secondaryColor)
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ):null,
      borderRadius: BorderRadius.circular(8.0),
     ),
    child: InkResponse(
      onTap: () {
        isSelected=Resource.of(context,tag!)
            .strings
            .MyCart;
        setState(() {

        });
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return MyCart();
        },));
      },
      child: Stack(

        children: [

          Container(


            width: 18,
            height: 18,
            child: Image.asset(
              'assets/icons/cart.png',color: (isSelected.contains(Resource.of(context,tag!)
                .strings
                .MyCart))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

          ),



          Container(
            margin: EdgeInsets.fromLTRB(28, 0, 0, 0),

            child: Column(
              children: [
                Container(

                  alignment: Alignment.centerLeft,
                  child: Text(
                    Resource.of(context,tag!)
                        .strings
                        .MyCart

                    ,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 16.0,

                        color:(isSelected.contains(Resource.of(context,tag!)
                            .strings
                            .MyCart))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor), ),
                  ),
                ),

              ],
            ),
          )

          ,

          Align(
            alignment: Alignment.topRight,
            child:  Container(

                margin: EdgeInsets.fromLTRB(0, 3, 12, 0),

                child:Image.asset(
                  'assets/icons/DownIcon.png',width: 7,color:(isSelected.contains(Resource.of(context,tag!)
                    .strings
                    .MyCart))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),




            ),
          )
        ]
    ),
  )
  ),
  Container(
    height: 46,
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
    margin: EdgeInsets.fromLTRB(10, 10, 10, 7),
    decoration: BoxDecoration(
      gradient: (isSelected.contains(Resource.of(context,tag!)
          .strings
          .MyWishlist))?LinearGradient(
        colors: [
          Color(ColorConsts.primaryColor),
          Color(ColorConsts.secondaryColor)
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ):null,
      borderRadius: BorderRadius.circular(8.0),
     ),
    child:InkResponse(
      onTap: () {
        isSelected=Resource.of(context,tag!)
            .strings
            .MyWishlist;
        setState(() {

        });
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => WishList('')),
        );

      },
      child: Stack(

        children: [

          Container(


            width: 18,
            height: 18,
            child: Image.asset(
              'assets/icons/dislike.png',color: (isSelected.contains(Resource.of(context,tag!)
                .strings
                .MyWishlist))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

          ),



          Container(
            margin: EdgeInsets.fromLTRB(28, 0, 0, 0),

            child: Column(
              children: [
                Container(

                  alignment: Alignment.centerLeft,
                  child: Text(
                    Resource.of(context,tag!)
                        .strings
                        .MyWishlist

                    ,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 16,

                        color: (isSelected.contains(Resource.of(context,tag!)
                            .strings
                            .MyWishlist))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor), ),
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
                  'assets/icons/DownIcon.png',width: 7,color: (isSelected.contains(Resource.of(context,tag!)
                    .strings
                    .MyWishlist))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

              ),



          )
        ]
    ),
    )
  ),
  Container(
    height: 46,
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
    margin: EdgeInsets.fromLTRB(10, 10, 10, 7),
    decoration: BoxDecoration(
      gradient: (isSelected.contains(Resource.of(context,tag!).strings
          .MyNotifications))?LinearGradient(
        colors: [
          Color(ColorConsts.primaryColor),
          Color(ColorConsts.secondaryColor)
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ):null,
      borderRadius: BorderRadius.circular(8.0),
     ),
    child:InkResponse(
      onTap: () {
      isSelected=Resource.of(context,tag!).strings.MyNotifications;
      setState(() {

      });
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return Notifications();
      },));

      },
        child:  Stack(

        children: [

          Container(
            width: 18,
            height: 18,
            child: Image.asset(
              'assets/icons/bell.png',color: (isSelected.contains(Resource.of(context,tag!)
                .strings
                .MyNotifications))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

          ),
          Container(
            margin: EdgeInsets.fromLTRB(28, 0, 0, 0),
            child: Column(
              children: [
                Container(

                  alignment: Alignment.centerLeft,
                  child: Text(
                    Resource.of(context,tag!)
                        .strings
                        .MyNotifications

                    ,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 16,

                        color: (isSelected.contains(Resource.of(context,tag!)
                            .strings.MyNotifications))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),
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
                  'assets/icons/DownIcon.png',width: 7,color: (isSelected.contains(Resource.of(context,tag!)
                    .strings
                    .MyNotifications))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

              ),



          )
        ]
    ),
  ),
  ),
  Container(
    height: 46,
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
    margin: EdgeInsets.fromLTRB(10, 10, 10, 7),
    decoration: BoxDecoration(
      gradient: (isSelected.contains(Resource.of(context,tag!)
          .strings
          .MySupportTickets))?LinearGradient(
        colors: [
          Color(ColorConsts.primaryColor),
          Color(ColorConsts.secondaryColor)
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ):null,
      borderRadius: BorderRadius.circular(8.0),
     ),
    child: InkResponse(
      onTap: () {
      isSelected=Resource.of(context,tag!)
          .strings
          .MySupportTickets;
      setState(() {

      });
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CustomerSupport();
      },));

      },
        child: Stack(

        children: [

          Container(
            width: 18,
            height: 18,
            child: Image.asset(
              'assets/icons/Chats.png',color: (isSelected.contains(Resource.of(context,tag!)
                .strings
                .MySupportTickets))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

          ),



          Container(
            margin: EdgeInsets.fromLTRB(28, 0, 0, 0),

            child: Column(
              children: [
                Container(

                  alignment: Alignment.centerLeft,
                  child: Text(
                   Resource.of(context,tag!)
                        .strings
                        .MySupportTickets,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 16,

                        color: (isSelected.contains(Resource.of(context,tag!)
                            .strings
                            .MySupportTickets))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),
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
                  'assets/icons/DownIcon.png',width: 7,color:(isSelected.contains(Resource.of(context,tag!)
                    .strings.MySupportTickets))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

              ),



          )
        ]
    ),
    )
  ),
 /* Container(
    height: 46,
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
    margin: EdgeInsets.fromLTRB(10, 10, 10,7),
    decoration: BoxDecoration(
      gradient: (isSelected.contains(Resource.of(context,tag!)
          .strings
          .ChooseLanguage))?LinearGradient(
        colors: [
          Color(ColorConsts.primaryColor),
          Color(ColorConsts.secondaryColor)
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ):null,
      borderRadius: BorderRadius.circular(8.0),
     ),
    child: InkResponse(
      onTap: () {
      isSelected=Resource.of(context,tag!)
          .strings
          .ChooseLanguage;
      setState(() {

      });
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ChooseLanguage();
      },));

      },
        child: Stack(

        children: [

          Container(


            width: 18,
            height: 18,
            child: Image.asset(
              'assets/icons/Language.png',color: (isSelected.contains(Resource.of(context,tag!)
                .strings
                .ChooseLanguage))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

          ),



          Container(
            margin: EdgeInsets.fromLTRB(28, 0, 0, 0),

            child: Column(
              children: [
                Container(

                  alignment: Alignment.centerLeft,
                  child: Text(
                   Resource.of(context,tag!)
                        .strings
                        .ChooseLanguage

                    ,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 16,

                        color: (isSelected.contains(Resource.of(context,tag!).strings.ChooseLanguage))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),
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
                  'assets/icons/DownIcon.png',width: 7,color:(isSelected.contains(Resource.of(context,tag!)
                    .strings
                    .ChooseLanguage))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

              ),



          )
        ]
    ),
    )
  ),*/
  Container(
    height: 46,
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
    margin: EdgeInsets.fromLTRB(10, 10, 10, 7),
    decoration: BoxDecoration(
      gradient: (isSelected.contains(Resource.of(context,tag!).strings.HelpCenter))?LinearGradient(
        colors: [
          Color(ColorConsts.primaryColor),
          Color(ColorConsts.secondaryColor)
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ):null,
      borderRadius: BorderRadius.circular(8.0),
     ),
    child:InkResponse(
      onTap: () {
      isSelected=Resource.of(context,tag!)
          .strings.HelpCenter;
      setState(() {

      });

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HelpCenter();
      },));
    //  _makePhoneCall('9999906914');

      },
        child: Stack(

        children: [

          Container(


            width: 18,
            height: 18,
            child: Image.asset(
              'assets/icons/Helpcenter.png',color: (isSelected.contains(Resource.of(context,tag!)
                .strings
                .HelpCenter))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

          ),



          Container(
            margin: EdgeInsets.fromLTRB(28, 0, 0, 0),

            child: Column(
              children: [
                Container(

                  alignment: Alignment.centerLeft,
                  child: Text(
                   Resource.of(context,tag!)
                        .strings
                        .HelpCenter

                    ,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 16,

                        color: (isSelected.contains(Resource.of(context,tag!)
                            .strings
                            .HelpCenter))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor), ),
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
                  'assets/icons/DownIcon.png',width: 7,color:(isSelected.contains(Resource.of(context,tag!)
                    .strings
                    .HelpCenter))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

              ),

          )
        ]
    ),
    )
  ),
  Container(
    height: 46,
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
    margin: EdgeInsets.fromLTRB(10, 10, 10, 7),
    decoration: BoxDecoration(
      gradient: (isSelected.contains(Resource.of(context,tag!)
          .strings.PrivacyPolicy))?LinearGradient(
        colors: [
          Color(ColorConsts.primaryColor),
          Color(ColorConsts.secondaryColor)
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ):null,
      borderRadius: BorderRadius.circular(8.0),
     ),
    child: InkResponse(
      onTap: () {
      isSelected=Resource.of(context,tag!)
          .strings
          .PrivacyPolicy;
      setState(() {

      });
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PrivacyPolicy();
      },));

      },
        child: Stack(

        children: [

          Container(


            width: 18,
            height: 18,
            child: Image.asset(
              'assets/icons/Privacy.png',color: (isSelected.contains(Resource.of(context,tag!)
                .strings
                .PrivacyPolicy))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

          ),



          Container(
            margin: EdgeInsets.fromLTRB(28, 0, 0, 0),

            child: Column(
              children: [
                Container(

                  alignment: Alignment.centerLeft,
                  child: Text(
                   Resource.of(context,tag!)
                        .strings
                        .PrivacyPolicy

                    ,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 16,

                        color: (isSelected.contains(Resource.of(context,tag!)
                            .strings
                            .PrivacyPolicy))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),
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
                  'assets/icons/DownIcon.png',width: 7,color: (isSelected.contains(Resource.of(context,tag!)
                    .strings.PrivacyPolicy))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

              ),
          )
        ]
    ),
    )
  ),
  Container(
    height: 46,
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
    margin: EdgeInsets.fromLTRB(10, 10, 10, 40),
    decoration: BoxDecoration(
      gradient:(isSelected.contains(Resource.of(context,tag!)
          .strings
          .Logout))?LinearGradient(
        colors: [
          Color(ColorConsts.primaryColor),
          Color(ColorConsts.secondaryColor)
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ):null,
      borderRadius: BorderRadius.circular(8.0),
     ),
    child:InkResponse(
      onTap: () {
      isSelected=Resource.of(context,tag!)
          .strings
          .Logout;
      setState(() {

      });
      logoutDialog(context);
      },
        child:  Stack(

        children: [

          Container(


            width: 18,
            height: 18,
            child: Image.asset(
              'assets/icons/logout.png',color:(isSelected.contains(Resource.of(context,tag!)
                .strings
                .Logout))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

          ),



          Container(
            margin: EdgeInsets.fromLTRB(28, 0, 0, 0),

            child: Column(
              children: [
                Container(

                  alignment: Alignment.centerLeft,
                  child: Text(
                   Resource.of(context,tag!)
                        .strings
                        .Logout

                    ,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 16,

                        color: (isSelected.contains(Resource.of(context,tag!)
                            .strings
                            .Logout))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),
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
                  'assets/icons/DownIcon.png',width: 7,color: (isSelected.contains(Resource.of(context,tag!)
                    .strings
                    .Logout))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

              ),
          )
        ]
    ),
    )
  ),
],
  ),




)
        ,


    )
      ,);
  }

}


