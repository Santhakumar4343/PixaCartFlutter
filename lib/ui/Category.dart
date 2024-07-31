import 'dart:convert';

import 'package:e_com/localdb/AppDatabase.dart';
import 'package:e_com/localdb/ListEntity.dart';
import 'package:e_com/model/ModelCategory.dart';
import 'package:e_com/model/ModelSettings.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/presenter/CateSubProductPresenter.dart';
import 'package:e_com/ui/Notifications.dart';
import 'package:e_com/ui/Search.dart';
import 'package:e_com/utils/ConnectionCheck.dart';
import 'package:e_com/utils/Resource.dart';
import 'package:e_com/utils/SharedPref.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'InsideCategory.dart';
import 'MyCart.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

class Category extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}






class _State extends State<Category> {
  SharedPref sharePrefs = SharedPref();
  late UserLoginModel _userLoginModel;
  bool hasData=false,hasConnection=true;
  late final access;
  late final database;
  String cartLength="0";
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  late ModelSettings modelSettings ;

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {});
    _refreshController.refreshCompleted();
  }

  Future<bool> getValue() async {
   bool check= await ConnectionCheck()
        .checkConnection();
   if(!check){
     hasConnection=false;
   }else{
     hasConnection=true;
   }
    _userLoginModel=await sharePrefs.getLoginUserData();
   String? sett = await sharePrefs.getSettings();
   final Map<String, dynamic> parsed = json.decode(sett!);
   modelSettings = ModelSettings.fromJson(parsed);

   initDb();
    return true;
  }

  Future<void> initDb() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    access = database.daoaccess;
   reload();
  }
  reload() async {
    hasData=true;
    List<ListEntity> listdata = await access.getAll();
    cartLength=listdata.length.toString();
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
                          margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                          child: Text('All Categories',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(ColorConsts.whiteColor))),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Stack(
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(0, 6, 86, 6),
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return Search();
                                    },));
                                  },
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
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Stack(
                          children: [
                             Align(
                              alignment: Alignment.centerRight,
                              child:InkResponse(onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                  return Notifications();
                                },));

                              },child:   Container(
                                padding: EdgeInsets.fromLTRB(0, 6, 49, 6),
                                child: Image.asset(
                                  'assets/icons/bell.png',
                                  width: 21,
                                  height: 20,
                                ),
                              ),
                              )
                            ),   if(hasData)if(modelSettings.data.notifications_count > 0)Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 48, 16),
                                  width: 9,
                                  height: 9,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    color: Color(ColorConsts.redColor),
                                  ),

                                )
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child:  InkResponse(onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                  return MyCart();
                                },));

                              },child:Container(
                                padding: EdgeInsets.fromLTRB(0, 6, 12.5, 6),
                                child: Image.asset(
                                  'assets/icons/cart.png',
                                  width: 21,
                                  height: 20,
                                ),
                              ),
                              )
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

                      )
                    ],
                  )),
              if(!hasConnection)Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,children: [
                Container(
                    margin: EdgeInsets.fromLTRB(0, 54, 0, 4),
                    child: Image.asset(
                      'assets/images/noDataFound.png',
                      height: 160,
                      width: MediaQuery.of(context).size.width,
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 9, 0, 0),
                  child: Text(
                    'No Internet found' +
                        " !",
                    style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Color(ColorConsts.textColor)),
                  ),
                ),
                InkResponse(onTap: () {
                getValue();
                },child: Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 24),
                  child: Text(
                    'Try Again !' +
                        " ",
                    style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Color(ColorConsts.textColor)),
                  ),
                )
                )

              ]),
            if(hasConnection)FutureBuilder<ModelCategory>(
            future:hasData?CatePresenter().getCatList(_userLoginModel.data.token):null,
    builder: (context, projectSnap) {


              if(projectSnap.hasData) {
                if(projectSnap.data!.data.length == 0){
                  return Container(
                    margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                    alignment: Alignment.center,
                    child:Column(
                      mainAxisAlignment:MainAxisAlignment.center,children: [
                      Image.asset('assets/images/noDataFound.png') ,
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text('No Category Found!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'OpenSans-Bold',
                                fontSize: 18,

                                color: Color(ColorConsts.blackColor))),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                        child: Text('We\'ll Notify You When Something Arrives',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 17,

                                color: Color(ColorConsts.grayColor))),
                      ),

                    ],) ,);
                }

                return Container(
                  padding: EdgeInsets.all(1.0),
                  margin: EdgeInsets.fromLTRB(8, 82, 8, 0),
                  child:SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      controller: _refreshController,
      onRefresh: _onRefresh,
      physics: BouncingScrollPhysics(),
      header: ClassicHeader(
      refreshingIcon: Icon(Icons.refresh,
      color: Color(ColorConsts.primaryColor)),
      refreshingText: '',
      ),
      child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: projectSnap.data!.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10.0,

                      mainAxisExtent: 146,

                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(children: [
                        Container(
                            width: 100,
                            height: 89,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 5.5),
                            child: InkResponse(
                              child:  ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: FancyShimmerImage(
                                  imageUrl: projectSnap.data!.data[index].cate_image ,
                                  boxFit: BoxFit.cover,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return InsideCategory2(
                                        "" + projectSnap.data!.data[index].cate_name,  "" + projectSnap.data!.data[index].id);
                                  },
                                )).then((value) {
                                  debugPrint(value);
                                  reload();
                                });
                              },
                            ),
                          ),

                        Text(
                          projectSnap.data!.data[index].cate_name,
                          style: TextStyle(
                              fontFamily: 'OpenSans-Bold',
                              fontSize: 15,
                              color: Color(ColorConsts.textColor)),
                        ),
                      ]);
//
                    },
                  ),
                  )
                );
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
    }),

            ],
          ),
        ),
      ),
    );
  }
}


