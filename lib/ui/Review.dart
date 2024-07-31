import 'dart:convert';

import 'package:e_com/model/ModelReviews.dart';
import 'package:e_com/model/ModelSettings.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:e_com/utils/Resource.dart';

import '../model/UserLoginModel.dart';
import '../presenter/ReviewPresenter.dart';
import '../utils/SharedPref.dart';
import 'SingleItemScreen.dart';

class Review extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}




class _State extends State<Review> {
  String currSym = '\$';
  SharedPref sharePrefs = SharedPref();
  String? tag = '';
  late UserLoginModel _userLoginModel;
  bool hasData = false;

  Future<void> getValue() async {
    tag = await sharePrefs.getLanguage();
    _userLoginModel = await sharePrefs.getLoginUserData();
    String? sett = await sharePrefs.getSettings() ;
    final Map<String, dynamic> parsed = json.decode(sett!);
    ModelSettings  modelSettings = ModelSettings.fromJson(parsed);
    currSym=modelSettings.data.currency_symbol.toString();
    hasData = true;
    setState(() {});

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
            child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(children: [
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
                    child: Text(Resource.of(context, tag!).strings.reviews,
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
                      padding: EdgeInsets.all(8),
                      child: Image.asset(
                        'assets/icons/Arrow.png',
                        width: 23,
                        height: 23,
                        color: Color(ColorConsts.whiteColor),
                      ),
                    ),
                  ),
                ),
              ],
            )),
        FutureBuilder<ModelReviews>(
            future: hasData
                ? ReviewPresenter().getList(_userLoginModel.data.token)
                : null,
            builder: (context, projectSnap) {
    if (projectSnap.hasError) {
      return Container();
    }
              if (projectSnap.hasData) {


                if(projectSnap.data!.data.length > 0){

                return Container(
                  padding: EdgeInsets.all(1.0),
                  margin: EdgeInsets.fromLTRB(8, 65, 8, 0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: projectSnap.data!.data.length,
                      itemBuilder: (context, index) {
                        return InkResponse(
                          onTap: () {

                            Navigator.push(context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return SingleItemScreen('',projectSnap.data!.data[index].id,projectSnap.data!.data[index].variant_id);
                                  },)).then((value) {
                              debugPrint(value);

                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(6, 5, 0, 6),
                            child: Column(children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xffffb2b9),
                                          Color(0xffffb2b9)
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius:
                                          BorderRadiusDirectional.circular(6.0),
                                      image: DecorationImage(
                                        image: NetworkImage(projectSnap.data!.data[index].prod_image[0]),
                                        fit: BoxFit.fill,
                                        alignment: Alignment.topCenter,
                                      ),
                                    ),
                                    width: 70,
                                    height: 70,
                                    margin: EdgeInsets.fromLTRB(0, 0, 14, 8),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 4),
                                        child: Text(
                                          projectSnap.data!.data[index].prod_name,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: 'OpenSans-Bold',
                                            fontSize: 18,
                                            color:
                                                Color(ColorConsts.blackColor),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '$currSym '+projectSnap.data!.data[index].prod_unitprice.toString()+" ",
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 13,
                                            ),
                                          ),
                                          if(double.parse(projectSnap.data!.data[index].prod_strikeout_price) >= 1.0)Text(
                                            ''+projectSnap.data!.data[index].prod_strikeout_price.toString(),
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
                                          if(double.parse((projectSnap.data!.data[index].prod_discount).toString()) > 0)(projectSnap.data!.data[index].prod_discount_type.contains("flat"))?Text(
                                            "  "+projectSnap.data!.data[index].prod_discount.toString()+' Flat Off',
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12.5,
                                                color: (projectSnap.data!.data[index].prod_quantity ==0)
                                                    ? Color(0x9AB446FF)
                                                    : Color(ColorConsts
                                                    .primaryColor)),
                                          ):Text(
                                            "  "+projectSnap.data!.data[index].prod_discount.toString()+'% Off',
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12.5,
                                                color: (projectSnap.data!.data[index].prod_quantity ==0)
                                                    ? Color(0x9AB446FF)
                                                    : Color(ColorConsts
                                                    .primaryColor)),
                                          ),
                                        ],
                                      ),
                                      RatingBar.builder(
                                        initialRating: double.parse(projectSnap.data!.data[index].rating.toString()),
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        ignoreGestures: true,
                                        itemCount: 5,
                                        itemSize: 19,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 6, 0, 3),
                                color: Color(ColorConsts.grayColor),
                                height: 0.2,
                              )
                            ]),
                          ),
                        );
                      }),
                );}else{
                  print('???????????????????');
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,child:Column(     crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                  children: [ Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 9),
                      child: Image.asset(
                        'assets/images/noDataFound.png',
                        height: 160,
                        width: MediaQuery.of(context).size.width,
                      )), Text('Not found !',
              style: TextStyle(color: Color(ColorConsts.blackColor), fontFamily: 'OpenSans-Bold', fontWeight: FontWeight.w500, fontSize: 18),),
              ])
                  );
                }
              }else{
                return Material(
                    type: MaterialType
                        .transparency,
                    child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: <
                              Widget>[
                            SizedBox(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(ColorConsts.primaryColor)), backgroundColor: Color(ColorConsts.pinkLytColor), strokeWidth: 4.0)),
                            Container(
                                margin: EdgeInsets.all(6),
                                child: Text(
                                  Resource.of(context, "en").strings.loadingPleaseWait,
                                  style: TextStyle(color: Color(ColorConsts.primaryColor), fontFamily: 'OpenSans-Bold', fontWeight: FontWeight.w500, fontSize: 18),
                                )),
                          ],
                        )));
              }
            })
      ]),
    )));
  }
}
