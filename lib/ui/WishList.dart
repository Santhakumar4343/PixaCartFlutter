import 'dart:convert';
import 'dart:io';
import 'package:e_com/localdb/AppDatabase.dart';
import 'package:e_com/localdb/ListEntity.dart';
import 'package:e_com/model/ModelProduct.dart';
import 'package:e_com/model/ModelSettings.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/presenter/CateSubProductPresenter.dart';
import 'package:e_com/ui/Search.dart';
import 'package:e_com/utils/Resource.dart';
import 'package:e_com/model/ModelHomePage.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/SharedPref.dart';
import 'MyCart.dart';
import 'Notifications.dart';
import 'SingleItemScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

String nameItem = '';

class WishList extends StatefulWidget {
  int? shouldChange;

  WishList(String s) {
    nameItem = s;
  }

  @override
  State<StatefulWidget> createState() => new _State();
}










class _State extends State<WishList> {


  String currSym = '\$';
  SharedPref sharePrefs = SharedPref();
  String? tag='';
  bool hasData = false;
  late UserLoginModel _userLoginModel;
  late final access;
  late final database;
  String cartLength="0";
  late ModelSettings  modelSettings ;

  Future<void> getValue() async {
    tag= await sharePrefs.getLanguage();
    _userLoginModel = await sharePrefs.getLoginUserData();
    String? sett = await sharePrefs.getSettings() ;
    final Map<String, dynamic> parsed = json.decode(sett!);
  modelSettings = ModelSettings.fromJson(parsed);
    currSym=modelSettings.data.currency_symbol.toString();

    initDb();
  }

  @override
  void initState() {
    getValue();
    super.initState();
  }

  Future<void> initDb() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    access = database.daoaccess;
    List<ListEntity> listdata = await access.getAll();
    cartLength=listdata.length.toString();
    hasData = true;
    setState(() {
    });
  }

  Future<bool> isDeleteDialog(BuildContext context,String pro_id) async {

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
                            padding: EdgeInsets.all(1),
                            width: 85,
                            height:120,
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),child: Image.asset(
                            'assets/icons/LogoDelete.png',
                            width: 85,
                            height: 120,

                          ),
                          ),
                            Align(child: Container(
                                width: 165,
                                height:178,
                                margin: EdgeInsets.fromLTRB(8, 12, 0, 0),
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child:  Column(
                                  children: [Text(  Resource.of(context,tag!).strings.AreYouDeleteThisItem,
                                    maxLines: 3,style: TextStyle(fontFamily: 'OpenSans-Bold',fontWeight: FontWeight.w500,fontSize:18
                                        ,color: Color(ColorConsts.blackColor)),),

                                    Stack(children: [
                                      Align(alignment: Alignment.centerLeft,child: InkResponse(
                                        onTap : () async {

                                          Navigator.pop(context, false);
                                          Fluttertoast.showToast(
                                              msg: "Deleting...",
                                              toastLength: Toast.LENGTH_SHORT,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.grey,
                                              textColor: Color(ColorConsts.redColor),
                                              fontSize: 14.0);
                                          await  CatePresenter().doLikeProduct(
                                                _userLoginModel.data.token, _userLoginModel.data.id, pro_id);
                                          setState(() {

                                          });

                                        }, // passing true
                                        child: Container(
                                            margin: EdgeInsets.fromLTRB(0, 16, 5, 0),
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
                                            margin: EdgeInsets.fromLTRB(0, 16,12, 0),
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
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
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
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(38, 0, 0, 0),
                          child: Text(  Resource.of(context,tag!).strings.Wishlist,
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
                      Align(
                          alignment: Alignment.centerRight,
                          child: Container(margin: EdgeInsets.fromLTRB(55, 0, 0, 0),child: InkResponse(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return Search();
                                },
                              ));
                            },
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 6, 86, 6),
                                    child: Image.asset(
                                      'assets/icons/SearchIcon.png',
                                      width: 21,
                                      height: 20,
                                      color: Color(ColorConsts.whiteColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 50,
                            margin: EdgeInsets.fromLTRB(0, 6, 49, 6),child: InkResponse(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return Notifications();
                              },));
                            },child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(

                                  child: Image.asset(
                                    'assets/icons/bell.png',
                                    width: 21,
                                    height: 20,
                                  ),
                                ),
                              ),
                             if(hasData)if(modelSettings.data.notifications_count>0) Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 1, 16),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      color: Color(ColorConsts.redColor),
                                    ),

                                  ))
                            ],
                          ),
                          ),
                          )
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 50,
                            margin: EdgeInsets.fromLTRB(0, 6, 2, 6)
                            ,child: InkResponse(onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return MyCart();
                            },));
                          },child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 6, 12.5, 6),
                                  child: Image.asset(
                                    'assets/icons/cart.png',
                                    width: 21,
                                    height: 20,
                                  ),
                                ),
                              ),
                              if(int.parse(cartLength) >= 1)Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 16),
                                    width: 12.5,
                                    height: 12.5,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.7,
                                          color: Color(ColorConsts.whiteColor)),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      color: Color(ColorConsts.secondaryColor),
                                    ),
                                    child: Text(
                                      cartLength.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Color(ColorConsts.whiteColor)),
                                    ),
                                  ))
                            ],
                          ),
                          ),)
                      )
                    ],
                  )),
              Container(
                margin: EdgeInsets.fromLTRB(0, 70, 0, 0),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,

                            margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                            alignment: Alignment.center,
                            child: FutureBuilder<ModelProduct>(
                                future: hasData
                                    ? CatePresenter().getWishList(
                                    _userLoginModel.data.token, _userLoginModel.data.id)
                                    : null,
                                builder: (context, projectSnap) {
                                  if (projectSnap.hasData) {
                                    if (projectSnap.data!.data.length == 0) {
                                      return Container(
                                        height: (MediaQuery.of(context).size.height-58)
                                      ,child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,children: [
                                        Container(
                                            margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                                            child: Image.asset(
                                              'assets/images/noDataFound.png',
                                              height: 160,
                                            )),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0, 9, 0, 0),
                                          child: Text(
                                            'No Results found ' +

                                                "!",
                                            style: TextStyle(
                                                fontFamily: 'OpenSans-Bold',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                                color: Color(ColorConsts.textColor)),
                                          ),
                                        )
                                      ])
                                      );
                                    }

                                    return GridView.builder(
                                        scrollDirection: Axis.vertical,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: projectSnap.data!.data.length,
                                        gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 95 / 145),
                                        itemBuilder: (BuildContext context, int idx) {


                                          return Column(
                                            // align the text to the left instead of centered
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Stack(
                                                children: [


                                                  InkResponse(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset: Offset(1, 1),
                                                            blurRadius: 8,
                                                            color: Color.fromRGBO(
                                                                0, 0, 0, 0.090),
                                                          )
                                                        ],
                                                        borderRadius:
                                                        BorderRadiusDirectional
                                                            .circular(7.0),

                                                      ),
                                                      height: 175,
                                                      margin: (idx % 2 == 0)
                                                          ? EdgeInsets.fromLTRB(
                                                          0, 8, 6, 8)
                                                          : EdgeInsets.fromLTRB(
                                                          6, 8, 0, 8),

                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        child: FancyShimmerImage(
                                                          imageUrl:projectSnap.data!.data[idx].prod_image[0] ,
                                                          boxFit: BoxFit.cover,
                                                        ),
                                                      ) ,
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return SingleItemScreen('',projectSnap.data!.data[idx].id,projectSnap.data!.data[idx].variant_id);
                                                            },));
                                                    },
                                                  ),
//not available changes
                                                  if (projectSnap.data!.data[idx].prod_quantity == 0)
                                                    Container(
                                                      height: 175,
                                                      margin: (idx % 2 == 0)
                                                          ? EdgeInsets.fromLTRB(
                                                          0, 8, 6, 8)
                                                          : EdgeInsets.fromLTRB(
                                                          6, 8, 0, 8),
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            Color(0x57000000),
                                                            Color(0x4D000000),
                                                          ],
                                                          begin: Alignment.centerLeft,
                                                          end: Alignment.centerRight,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset: Offset(1, 1),
                                                            blurRadius: 8,
                                                            color: Color.fromRGBO(
                                                                0, 0, 0, 0.090),
                                                          )
                                                        ],
                                                        borderRadius:
                                                        BorderRadiusDirectional
                                                            .circular(7.0),
                                                      ),
                                                      child: Container(
                                                          alignment: Alignment.center,
                                                          child: Stack(
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                BoxDecoration(
                                                                  gradient:
                                                                  LinearGradient(
                                                                    colors: [
                                                                      Color(
                                                                          0xFDF50D0D),
                                                                      Color(
                                                                          0xFFFC0000),
                                                                    ],
                                                                    begin: Alignment
                                                                        .centerLeft,
                                                                    end: Alignment
                                                                        .centerRight,
                                                                  ),
                                                                  borderRadius:
                                                                  BorderRadiusDirectional
                                                                      .circular(
                                                                      20),
                                                                ),
                                                                height: 30,
                                                                width: 120,
                                                              ),
                                                              Container(
                                                                height: 32,
                                                                width: 120,
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 0, 0, 2),
                                                                alignment:
                                                                Alignment.center,
                                                                child: Text(
                                                                  'Not Available',
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                      'OpenSans-Bold',
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                      fontSize: 14,
                                                                      color: Color(
                                                                          ColorConsts
                                                                              .whiteColor)),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    ),
                                                  Container(
                                                      margin: (idx%2==0)?EdgeInsets.fromLTRB(10, 19, 11, 0):EdgeInsets.fromLTRB(10, 19, 7, 0),
                                                      alignment: Alignment.centerRight,
                                                      child: InkResponse(onTap:() {

                                                        isDeleteDialog(context,projectSnap.data!.data[idx].variant_id);

                                                      } ,child: Container(
                                                        alignment: Alignment.center,
                                                        margin: EdgeInsets.fromLTRB(
                                                            0, 0, 9, 16),
                                                        width: 28,
                                                        height: 28,
                                                        decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              offset: Offset(1, 1),
                                                              blurRadius: 8,
                                                              color: Color.fromRGBO(
                                                                  0, 0, 0, 0.090),
                                                            )
                                                          ],
                                                          border: Border.all(
                                                              width: 0.7,
                                                              color: Color(
                                                                  ColorConsts
                                                                      .whiteColor)),
                                                          borderRadius: BorderRadius.all(Radius.circular(20),),
                                                          color: Color(ColorConsts.whiteColor),
                                                        ),
                                                          child: Image.asset(
                                                            'assets/icons/delete.png',
                                                            width: 14,
                                                            height: 14,
                                                          )
                                                      )
                                                      )
                                                  ),
                                                ],
                                              ),


                                              Container(
                                                margin:
                                                EdgeInsets.fromLTRB(4, 2, 0, 0),
                                                child: Text(
                                                  projectSnap.data!.data[idx].pro_subtitle,
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                      fontFamily: 'OpenSans-Bold',
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 15,
                                                      color: (projectSnap.data!.data[idx].prod_quantity ==0)
                                                          ? Color(
                                                          ColorConsts.grayColor)
                                                          : Color(ColorConsts
                                                          .blackColor)),
                                                ),
                                                width: 150,
                                              ),
                                              Container(
                                                margin:
                                                EdgeInsets.fromLTRB(3, 0, 0, 2.5),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '$currSym '+projectSnap.data!.data[idx].prod_unitprice.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '')+" ",
                                                      style: TextStyle(
                                                          fontFamily: 'OpenSans',
                                                          fontSize: 13,
                                                          color: (idx == 5)
                                                              ? Color(ColorConsts
                                                              .grayColor)
                                                              : Color(ColorConsts
                                                              .textColor)),
                                                    ),
                                                    if(double.parse(projectSnap.data!.data[idx].prod_discount) > 0)if(double.parse(projectSnap.data!.data[idx].prod_strikeout_price) >= 1.0)Text(
                                                      ''+projectSnap.data!.data[idx].prod_strikeout_price.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), ''),
                                                      style: TextStyle(
                                                          decoration: TextDecoration
                                                              .lineThrough,
                                                          decorationThickness: 2.2,
                                                          fontFamily: 'OpenSans',
                                                          decorationStyle:
                                                          TextDecorationStyle
                                                              .solid,
                                                          decorationColor:
                                                          Colors.black54,
                                                          fontSize: 13,
                                                          color: Color(
                                                              ColorConsts.grayColor)),
                                                    ),
                                                    if(double.parse(projectSnap.data!.data[idx].prod_discount) > 0)(projectSnap.data!.data[idx].prod_discount_type.contains("flat"))?Text(
                                                      " "+projectSnap.data!.data[idx].prod_discount.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '')+' Flat Off',
                                                      style: TextStyle(
                                                          fontFamily: 'OpenSans',
                                                          fontSize: 12.5,
                                                          color: (projectSnap.data!.data[idx].prod_quantity ==0)
                                                              ? Color(0x9AB446FF)
                                                              : Color(ColorConsts
                                                              .primaryColor)),
                                                    ):Text(
                                                      " "+projectSnap.data!.data[idx].prod_discount.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '')+'% Off',
                                                      style: TextStyle(
                                                          fontFamily: 'OpenSans',
                                                          fontSize: 12.5,
                                                          color: (projectSnap.data!.data[idx].prod_quantity ==0)
                                                              ? Color(0x9AB446FF)
                                                              : Color(ColorConsts
                                                              .primaryColor)),
                                                    ),
                                                  ],
                                                ),

                                              ),
                                              Row(
                                                children: [
                                                  if(projectSnap.data!.data[idx].rating_user_count > 0 )Container(
                                                    padding: EdgeInsets.fromLTRB(
                                                        6, 3, 7, 3),
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.fromLTRB(
                                                        4, 2, 0, 0),
                                                    decoration: BoxDecoration(
                                                        color: (projectSnap.data!.data[idx].prod_quantity ==0)
                                                            ? Color(0x9AB446FF)
                                                            : null,
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            Color(ColorConsts
                                                                .primaryColor),
                                                            Color(ColorConsts
                                                                .secondaryColor)
                                                          ],
                                                          begin: Alignment.centerLeft,
                                                          end: Alignment.centerRight,
                                                        ),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            30.0)),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.star_rounded,
                                                          color: Color(
                                                              ColorConsts.whiteColor),
                                                          size: 13,
                                                        ),
                                                        Text(
                                                          " "+projectSnap.data!.data[idx].rating_average.toString(),
                                                          style: TextStyle(
                                                              fontFamily:
                                                              'OpenSans-Bold',
                                                              fontSize: 13,
                                                              color: Color(ColorConsts
                                                                  .whiteColor)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if(projectSnap.data!.data[idx].rating_user_count > 0 )Container(
                                                    padding: EdgeInsets.fromLTRB(
                                                        6, 1, 6, 1),
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.fromLTRB(
                                                        2, 2, 0, 0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          projectSnap.data!.data[idx].rating_user_count.toString(),
                                                          style: TextStyle(
                                                              fontFamily:
                                                              'OpenSans-Bold',
                                                              fontSize: 14,
                                                              color: Color(ColorConsts
                                                                  .lightGrayColor)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        });
                                  }else{
                                    if(projectSnap.hasError){
                                      return Material();
                                    }
                                    return Material(
                                        type: MaterialType.transparency,
                                        child: Container(
                                            height: MediaQuery.of(context).size.height-60,
                                            margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: <Widget>[
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
                                                    margin: EdgeInsets.all(8),
                                                    child: Text(
                                                      Resource.of(context, "en")
                                                          .strings
                                                          .loadingPleaseWait,
                                                      style: TextStyle(
                                                          color: Color(
                                                              ColorConsts.primaryColor),
                                                          fontFamily: 'OpenSans-Bold',
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 18),
                                                    )),
                                              ],
                                            )));
                                  }
                                }
                            )


                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

