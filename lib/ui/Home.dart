import 'dart:convert';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:e_com/localdb/AppDatabase.dart';
import 'package:e_com/localdb/ListEntity.dart';
import 'package:e_com/model/ModelProBanners.dart';
import 'package:e_com/model/ModelProduct.dart';
import 'package:e_com/presenter/CateSubProductPresenter.dart';
import 'package:e_com/presenter/PromotionalBannersPresenter.dart';
import 'package:e_com/presenter/SoldItemPresenter.dart';
import 'package:e_com/ui/AllProducts.dart';
import 'package:e_com/utils/ConnectionCheck.dart';
import 'package:e_com/utils/Resource.dart';
import 'package:e_com/ui/MyCart.dart';
import 'package:e_com/utils/mobxStateManagement.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:e_com/utils/AppConstant.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../model/ModelCategory.dart';
import '../model/ModelSettings.dart';
import '../model/UserLoginModel.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../presenter/PaymetDetailPresenter.dart';
import '../utils/SharedPref.dart';
import 'InsideCategory.dart';
import 'Notifications.dart';
import 'Search.dart';
import 'SingleItemScreen.dart';
import 'package:upgrader/upgrader.dart';



class Home extends StatefulWidget {
  int? shouldChange;

  Home({int? this.shouldChange, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _State();
}



class _State extends State<Home> {

  final controller =
      PageController(viewportFraction: 0.9, keepPage: false, initialPage: 1);
  final controllerTwo =
      PageController(viewportFraction: 0.9, keepPage: false, initialPage: 1);
  bool hasData = false;
  SharedPref sharePrefs = SharedPref();
  String tag = 'en';
  late final access;
  late final database;
  String cartLength = "0";
  late UserLoginModel _userLoginModel;
  String currencySym = '';
  final _counter = Counter();
  late ModelSettings modelSettings ;
  late ModelProBanners bannersList;

  Future<void> getValue() async {

    bool check= await ConnectionCheck()
        .checkConnection();
    tag = (await sharePrefs.getLanguage())!;
    await ConnectionCheck().checkConnection();
    _userLoginModel = await sharePrefs.getLoginUserData();
    paymentDetailFetch();


  }

  dpProLikeDisLike(String product_id) {

  Future<String> s=  CatePresenter().doLikeProduct(
        _userLoginModel.data.token, _userLoginModel.data.id, product_id) ;

  }

  Future<void> initDb() async {
    try {
      database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      access = database.daoaccess;
      List<ListEntity> listdata = await access.getAll();
      cartLength = listdata.length.toString();
    }catch(e){}
    setState(() {});
    // callRecomm();
  }

  Future<void> paymentDetailFetch() async {

    await PaymetDetailPresenter().get(_userLoginModel.data.token);

    String? sett = await sharePrefs.getSettings();
    final Map<String, dynamic> parsed = json.decode(sett!);
modelSettings = ModelSettings.fromJson(parsed);
    currencySym = modelSettings.data.currency_symbol.toString();
     bannersList= await PromotionalBannersPresenter()
        .getList(_userLoginModel.data.token);
    hasData = true;
    initDb();
  }

  Future<void> _reload() async {
    getValue();
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
                          margin: EdgeInsets.fromLTRB(38, 0, 0, 0),
                          child: Text(AppConstant.appName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConsts.whiteColor))),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(6),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 28,
                            height: 28,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Stack(
                          children: [
                            Align(
                                alignment: Alignment.centerRight,
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return Notifications();
                                      },
                                    )).then((value) => _reload());
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 6, 49, 6),
                                    child: Image.asset(
                                      'assets/icons/bell.png',
                                      width: 21,
                                      height: 20,
                                    ),
                                  ),
                                )),
                            if(hasData)if(modelSettings.data.notifications_count > 0)Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 48, 16),
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: Stack(
                          children: [
                            Align(
                                alignment: Alignment.centerRight,
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return MyCart();
                                      },
                                    )).then((value) {
                                      _reload();
                                    });
                                    ;
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 6, 12.5, 6),
                                    child: Image.asset(
                                      'assets/icons/cart.png',
                                      width: 21,
                                      height: 20,
                                    ),
                                  ),
                                )),
                            if (int.parse(cartLength) >= 1)
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: InkResponse(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) {
                                            return MyCart();
                                          },
                                        )).then((value) {
                                          _reload();
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 10, 16),
                                        width: 12.5,
                                        height: 12.5,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.7,
                                              color: Color(
                                                  ColorConsts.whiteColor)),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          color:
                                              Color(ColorConsts.secondaryColor),
                                        ),
                                        child: Text(
                                          cartLength.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Color(
                                                  ColorConsts.whiteColor)),
                                        ),
                                      )))
                          ],
                        ),
                      )
                    ],
                  )),
              //Header end
              Container(
                height: 43,
                margin: (Platform.isAndroid) ?EdgeInsets.fromLTRB(12, 79, 65, 8):EdgeInsets.fromLTRB(12, 79, 16, 8),
                padding: EdgeInsets.fromLTRB(3, 0, 6, 0),
                decoration: new BoxDecoration(
                    border: Border.all(
                        color: Color(ColorConsts.lightGrayColor), width: 0.5),
                    borderRadius: BorderRadius.circular(4.0)),
                child: InkResponse(
                  onTap: () {
                    setState(() {});
                    Navigator.push(
                      context,
                      new MaterialPageRoute(builder: (context) => Search()),
                    ).then((value) {
                      _reload();
                    });
                  },
                  child: Stack(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 4.5, 0),
                              padding: EdgeInsets.fromLTRB(12, 0, 1, 0),
                              child: Text(
                                Resource.of(context, tag.toString()).strings.search,
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
                          padding: EdgeInsets.fromLTRB(0, 13, 6.5, 13),
                          child: Image(
                            image: AssetImage('assets/icons/SearchIcon.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Search box end

              if (Platform.isAndroid) Align(
                child: Container(
                  margin: EdgeInsets.fromLTRB(12, 79, 12, 8),
                  child: InkResponse(
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) => Search()),
                      ).then((value) {
                        _reload();
                      });
                    },
                    child: Container(
                      height: 43,
                      width: 43,
                      decoration: new BoxDecoration(
                          border: Border.all(
                              color: Color(ColorConsts.primaryColor),
                              width: 0.8),
                          borderRadius: BorderRadius.circular(4.0)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                          child: Image(
                            image: AssetImage('assets/icons/mic.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                alignment: Alignment.topRight,
              ),

              Container(
                  height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.fromLTRB(12, 127, 12, 0),
                  child: CustomScrollView(slivers: [
                    SliverToBoxAdapter(
                      child: FutureBuilder<ModelCategory>(
                          future: hasData
                              ? CatePresenter()
                                  .getCatList(_userLoginModel.data.token)
                              : null,
                          builder: (context, projectSnap) {
                            if (projectSnap.hasData) {
                              if(projectSnap.data!.data.length == 0){
                                return Container();
                              }
                              return Container(
                                  height: 110,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: projectSnap.data!.data.length,
                                      itemBuilder: (context, idx) {
                                        return Column(
                                          // align the text to the left instead of centered
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            InkResponse(
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  width: 75,
                                                  height: 65,
                                                  margin: EdgeInsets.fromLTRB(
                                                      3, 12, 5, 6),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: FancyShimmerImage(
                                                      imageUrl: '' +
                                                          projectSnap
                                                              .data!
                                                              .data[idx]
                                                              .cate_image,
                                                      boxFit: BoxFit.cover,
                                                    ),
                                                  )),
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder: (context) {
                                                    return InsideCategory2(
                                                        "" +
                                                            projectSnap
                                                                .data!
                                                                .data[idx]
                                                                .cate_name,
                                                        "" +
                                                            projectSnap.data!
                                                                .data[idx].id);
                                                  },
                                                )).then((value) {
                                                  _reload();
                                                });
                                              },
                                            ),
                                            Container(
                                              child: Text(
                                                projectSnap
                                                    .data!.data[idx].cate_name,
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontFamily: 'OpenSans-Bold',
                                                    color: Color(ColorConsts
                                                        .lightGrayColor)),
                                              ),
                                              width: 85,
                                            ),
                                          ],
                                        );
                                      }));
                            }
                            return Material(
                                type: MaterialType.transparency,
                                child: Container(
                                    height: 90,
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                                    ColorConsts
                                                        .primaryColorLyt),
                                                strokeWidth: 2.0)),/*
                                        Container(
                                            margin: EdgeInsets.all(3),
                                            child: Text(
                                              Resource.of(context, "en")
                                                  .strings
                                                  .loadingPleaseWait,
                                              style: TextStyle(
                                                  color: Color(
                                                      ColorConsts.primaryColor),
                                                  fontFamily: 'OpenSans-Bold',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            )),*/
                                      ],
                                    )));
                          }),
                    ),
                    if(hasData)SliverToBoxAdapter(
                        child:
    (bannersList.data.length == 0)?Container():Container(
                            margin: EdgeInsets.fromLTRB(0, 8, 0, 12),
                            width: MediaQuery.of(context).size.width,
                            height: 140,
                            child: hasData? Stack(
                                      children: <Widget>[
                                        PageView.builder(
                                          controller: controller,
                                          itemCount:bannersList.data.length,
                                          itemBuilder: (_, index) {
                                            return InkResponse(
                                              child: Container(
                                                height: 140,
                                                margin: EdgeInsets.fromLTRB(
                                                    1, 0, 7, 0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: FancyShimmerImage(
                                                    imageUrl: bannersList
                                                        .data[index]
                                                        .banner_image,
                                                    boxFit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              onTap: () async {

                                                await launch( bannersList
                                                    .data[index]
                                                    .banner_link);
                                              },
                                            );
                                          },
                                        ),
                                        Align(
                                          child: Container(
                                              alignment: Alignment.bottomCenter,
                                              height: 88,
                                              child: SmoothPageIndicator(
                                                controller: controller,
                                                count:bannersList.data.length,
                                                axisDirection: Axis.horizontal,
                                                effect: ExpandingDotsEffect(
                                                    spacing: 8.0,
                                                    radius: 4.0,
                                                    dotWidth: 7.0,
                                                    dotHeight: 4.8,
                                                    paintStyle:
                                                        PaintingStyle.fill,
                                                    strokeWidth: 1,
                                                    dotColor: Color(0xffd9d7d7),
                                                    activeDotColor:
                                                        Color(0xffFFFFFF)),
                                              )),
                                        ),
                                      ],
                                    ):
                                  Material(
                                        type: MaterialType.transparency,
                                        child: Container(
                                            height: 90,
                                            margin:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                                            ColorConsts
                                                                .primaryColorLyt),
                                                        strokeWidth: 2.0)),
                                                Container(
                                                    margin: EdgeInsets.all(3),
                                                    child: Text(
                                                      Resource.of(context, "en")
                                                          .strings
                                                          .loadingPleaseWait,
                                                      style: TextStyle(
                                                          color: Color(
                                                              ColorConsts
                                                                  .primaryColor),
                                                          fontFamily:
                                                              'OpenSans-Bold',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14),
                                                    )),
                                              ],
                                            )),
                                  )),),

                    if(hasData)SliverToBoxAdapter(
                        child: SizedBox(
                      child: Container(
                        child: FutureBuilder<dynamic>(
                            future: SoldItemPresenter().getMostSoldProductList(
                                    _userLoginModel.data.token, 5),
                            builder: (context, projectSnap) {
                              if (projectSnap.hasData) {
                                return (projectSnap.data!.data.length < 1)
                                    ? Container(
                                        height: 2,
                                      )
                                    : Column(
                                        children: [
                                          Stack(
                                            children: [
                                              InkResponse(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                    builder: (context) {
                                                      return AllProducts(
                                                          'Popular Products',
                                                          '',
                                                          '');
                                                    },
                                                  )).then((value) {
                                                    _reload();
                                                  });
                                                },
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        2, 14, 2, 7),
                                                    child: Text('View All',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily:
                                                              'OpenSans-Bold',
                                                          color: Color(
                                                              ColorConsts
                                                                  .primaryColor),
                                                        )),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    2, 14, 2, 7),
                                                alignment: Alignment.centerLeft,
                                                child: Text('Popular Products',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'OpenSans-Bold',
                                                      color: Color(ColorConsts
                                                          .textColor),
                                                    )),
                                              ),
                                            ],
                                          ),
                                          Container(
                                              height: 150,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: projectSnap
                                                      .data!.data.length,
                                                  itemBuilder: (context, idx) {
                                                    final r = projectSnap
                                                        .data!.data[idx];
                                                    return InkResponse(
                                                      child: Column(
                                                        // align the text to the left instead of centered
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          Container(
                                                            width: 115,
                                                            height: 95,
                                                            margin: EdgeInsets
                                                                .fromLTRB(
                                                                    1,
                                                                    4.6,
                                                                    2,
                                                                    4.5),
                                                            child: (projectSnap
                                                                        .data!
                                                                        .data[
                                                                            idx]
                                                                        .prod_image
                                                                        .length >
                                                                    0)
                                                                ? ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                    child:
                                                                        FancyShimmerImage(
                                                                      imageUrl: projectSnap
                                                                          .data!
                                                                          .data[
                                                                              idx]
                                                                          .prod_image[0],
                                                                      boxFit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  )
                                                                : ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                    child:
                                                                        Container(
                                                                      color: Color(
                                                                          ColorConsts
                                                                              .grayColor),
                                                                    ),
                                                                  ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(
                                                                    0, 0, 0, 0),
                                                            child: Text(
                                                              'From $currencySym' +
                                                                  projectSnap
                                                                      .data!
                                                                      .data[idx]
                                                                      .prod_unitprice.replaceAll(RegExp(r'([.]*0)(?!.*\d)'), ''),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'OpenSans-Bold',
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color(
                                                                      ColorConsts
                                                                          .textColor)),
                                                            ),
                                                            width: 127,
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(
                                                                    0, 0, 0, 2),
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              projectSnap
                                                                  .data!
                                                                  .data[idx]
                                                                  .prod_name,
                                                              maxLines: 1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'OpenSans',
                                                                  fontSize: 13,
                                                                  color: Color(
                                                                      ColorConsts
                                                                          .lightGrayColor)),
                                                            ),
                                                            width: 130,
                                                          ),
                                                        ],
                                                      ),
                                                      onTap: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                          builder: (context) {
                                                            return SingleItemScreen(''+projectSnap
                                                                    .data!
                                                                    .data[idx]
                                                                    .prod_name,
                                                                projectSnap
                                                                    .data!
                                                                    .data[idx]
                                                                    .id,
                                                                projectSnap
                                                                    .data!
                                                                    .data[idx]
                                                                    .variant_id);
                                                          },
                                                        )).then((value) {
                                                          _reload();
                                                        });
                                                      },
                                                    );
                                                  }))
                                        ],
                                      );
                              } else {
                                if (projectSnap.hasError) {
                                  return Material();
                                }
                                return Material(
                                    type: MaterialType.transparency,
                                    child: Container(
                                        height: 100,
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                                child: (!projectSnap.hasError)
                                                    ? CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation(
                                                                Color(ColorConsts
                                                                    .primaryColor)),
                                                        backgroundColor: Color(
                                                            ColorConsts
                                                                .primaryColorLyt),
                                                        strokeWidth: 2.0)
                                                    : null),/*
                                            Container(
                                                margin: EdgeInsets.all(6),
                                                child: Text(
                                                  Resource.of(context, "en")
                                                      .strings
                                                      .loadingPleaseWait,
                                                  style: TextStyle(
                                                      color: Color(ColorConsts
                                                          .primaryColor),
                                                      fontFamily:
                                                          'OpenSans-Bold',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14),
                                                )),*/
                                          ],
                                        )));
                              }
                            }),
                      ),
                    )),
                    SliverToBoxAdapter(
                      child: Stack(
                        children: [
                          Align(
                              alignment: Alignment.centerRight,
                              child: InkResponse(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return AllProducts(
                                          'Trending Now', '', '');
                                    },
                                  )).then((value) {
                                    _reload();
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(2, 12, 2, 8),
                                  child: Text('View All',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'OpenSans-Bold',
                                        color: Color(ColorConsts.primaryColor),
                                      )),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.fromLTRB(2, 12, 2, 8),
                            alignment: Alignment.centerLeft,
                            child: Text('Trending Now',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'OpenSans-Bold',
                                  color: Color(ColorConsts.textColor),
                                )),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.fromLTRB(5, 12, 4, 0),
                            alignment: Alignment.center,
                            child: FutureBuilder<ModelProduct>(
                                future: hasData
                                    ? CatePresenter().getTrendingProducts(
                                        _userLoginModel.data.token, 6)
                                    : null,
                                builder: (context, projectSnap) {

                                  if (projectSnap.hasData){
                                  if(projectSnap.data!.data.length == 0){
                                  return Container(
                                  margin: EdgeInsets.fromLTRB(40, 10, 40, 42),
                                  alignment: Alignment.center,
                                  child:Column(
                                  mainAxisAlignment:MainAxisAlignment.center,children: [
                                  Image.asset('assets/images/noDataFound.png',width: 200,),Text('No Data Found!',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'OpenSans-Bold',
                                          color: Color(ColorConsts.textColor),
                                        )) ]),
                                  );
                                  }
                                    return GridView.builder(
                                        scrollDirection: Axis.vertical,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            projectSnap.data!.data.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 7,
                                          mainAxisExtent: 266,
                                        ),
                                        itemBuilder:
                                            (BuildContext context, int idx) {
                                          if (projectSnap
                                              .data!.data[idx].isLiked
                                              .toString()
                                              .contains("1")) {
                                            _counter.like(
                                                projectSnap.data!.data[idx].variant_id);
                                          }

                                          return Column(
                                            // align the text to the left instead of centered
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Stack(
                                                children: [
                                                  InkResponse(
                                                    child: Container(
                                                      height: 175,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child:
                                                            FancyShimmerImage(
                                                          imageUrl: projectSnap
                                                              .data!
                                                              .data[idx]
                                                              .prod_image[0],
                                                          boxFit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                        builder: (context) {
                                                          return SingleItemScreen(
                                                              ''+projectSnap.data!
                                                                  .data[idx].prod_name,
                                                              projectSnap.data!
                                                                  .data[idx].id,
                                                              projectSnap
                                                                  .data!
                                                                  .data[idx]
                                                                  .variant_id);
                                                        },
                                                      )).then((value) {
                                                        debugPrint(value);
                                                        _reload();
                                                      });
                                                    },
                                                  ),
//not available changes
                                                  if (projectSnap
                                                          .data!
                                                          .data[idx]
                                                          .prod_quantity ==
                                                      0)
                                                    Container(
                                                      height: 175,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Color(0x57000000),
                                                            Color(0x4D000000),
                                                          ],
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset:
                                                                Offset(1, 1),
                                                            blurRadius: 8,
                                                            color:
                                                                Color.fromRGBO(
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    0.090),
                                                          )
                                                        ],
                                                        borderRadius:
                                                            BorderRadiusDirectional
                                                                .circular(7.0),
                                                      ),
                                                      child: Container(
                                                          alignment:
                                                              Alignment.center,
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
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            2),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  'Not Available',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'OpenSans-Bold',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14,
                                                                      color: Color(
                                                                          ColorConsts
                                                                              .whiteColor)),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    ),
                                                  Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              10, 12, 12, 0),
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: InkResponse(
                                                          onTap: () {
                                                            dpProLikeDisLike("" + projectSnap.data!.data[idx].variant_id);
                                                            if (_counter
                                                                .likedIndex
                                                                .contains(
                                                                    projectSnap
                                                                        .data!
                                                                        .data[
                                                                            idx]
                                                                        .variant_id)) {
                                                              _counter.disliked(
                                                                  projectSnap
                                                                      .data!
                                                                      .data[idx]
                                                                      .variant_id);
                                                            } else {
                                                              _counter.like(
                                                                  projectSnap
                                                                      .data!
                                                                      .data[idx]
                                                                      .variant_id);
                                                            }

                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: 28,
                                                            height: 28,
                                                            decoration:
                                                                BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  offset:
                                                                      Offset(
                                                                          1, 1),
                                                                  blurRadius: 8,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0.090),
                                                                )
                                                              ],
                                                              border: Border.all(
                                                                  width: 0.7,
                                                                  color: Color(
                                                                      ColorConsts
                                                                          .whiteColor)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    20),
                                                              ),
                                                              color: Color(
                                                                  ColorConsts
                                                                      .whiteColor),
                                                            ),
                                                            child: Observer(
                                                                builder: (_) => (!_counter.likedIndex.contains("" +
                                                                    projectSnap
                                                                        .data!
                                                                        .data[
                                                                    idx]
                                                                        .variant_id))
                                                                    ? Image
                                                                    .asset(
                                                                  'assets/icons/dislike.png',
                                                                  width:
                                                                  14,
                                                                  height:
                                                                  14,
                                                                )
                                                                    : Image
                                                                    .asset(
                                                                  'assets/icons/like.png',
                                                                  width:
                                                                  14,
                                                                  height:
                                                                  14,
                                                                )),
                                                          )
                                                      )
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    2, 2, 0, 0),
                                                child: Text(
                                                  projectSnap.data!.data[idx]
                                                      .pro_subtitle,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'OpenSans-Bold',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15,
                                                      color: (projectSnap
                                                                  .data!
                                                                  .data[idx]
                                                                  .prod_quantity ==
                                                              0)
                                                          ? Color(ColorConsts
                                                              .grayColor)
                                                          : Color(ColorConsts
                                                              .blackColor)),
                                                ),
                                                width: 155,
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    1, 0, 0, 2.5),
                                                width: (MediaQuery.of(context).size.width/2)-10,
                                                child:  Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                      '$currencySym' +
                                                          projectSnap
                                                              .data!
                                                              .data[idx]
                                                              .prod_unitprice
                                                              .toString()
                                                              .replaceAll(
                                                                  RegExp(
                                                                      r'([.]*0)(?!.*\d)'),
                                                                  '') +
                                                          " ",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontSize: 13,
                                                          color:
                                                               Color(ColorConsts
                                                                  .textColor)),
                                                    ),
                                                    if (double.parse((projectSnap
                                                        .data!
                                                        .data[idx]
                                                        .prod_discount)
                                                        .toString()) >
                                                        0) if (double.parse(projectSnap
                                                            .data!
                                                            .data[idx]
                                                            .prod_strikeout_price) >=
                                                        1.0)
                                                      Text(
                                                        '' +
                                                            projectSnap
                                                                .data!
                                                                .data[idx]
                                                                .prod_strikeout_price
                                                                .toString()
                                                                .replaceAll(
                                                                    RegExp(
                                                                        r'([.]*0)(?!.*\d)'),
                                                                    ''),
                                                        style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            decorationThickness:
                                                                2.2,
                                                            fontFamily:
                                                                'OpenSans',
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                            decorationColor:
                                                                Colors.black54,
                                                            fontSize: 13,
                                                            color: Color(
                                                                ColorConsts
                                                                    .grayColor)),
                                                      ),
                                                    if (double.parse((projectSnap
                                                                .data!
                                                                .data[idx]
                                                                .prod_discount)
                                                            .toString()) >
                                                        0)
                                                      (projectSnap
                                                              .data!
                                                              .data[idx]
                                                              .prod_discount_type
                                                              .contains("flat"))
                                                          ? Flexible(child:Text(
                                                              " " +
                                                                  projectSnap
                                                                      .data!
                                                                      .data[idx]
                                                                      .prod_discount
                                                                      .toString() .replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '')+
                                                                  ' Flat Off',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'OpenSans',
                                                                  fontSize:
                                                                      13,
                                                                  color: (projectSnap
                                                                              .data!
                                                                              .data[
                                                                                  idx]
                                                                              .prod_quantity ==
                                                                          0)
                                                                      ? Color(
                                                                          0x9AB446FF)
                                                                      : Color(ColorConsts
                                                                          .primaryColor)),
                                                            )
                                                      )
                                                          : Flexible(child: Text(
                                                              " " +
                                                                  projectSnap
                                                                      .data!
                                                                      .data[idx]
                                                                      .prod_discount
                                                                      .toString() +
                                                                  '% Off',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'OpenSans',
                                                                  fontSize:
                                                                      13,
                                                                  color: (projectSnap
                                                                              .data!
                                                                              .data[
                                                                                  idx]
                                                                              .prod_quantity ==
                                                                          0)
                                                                      ? Color(
                                                                          0x9AB446FF)
                                                                      : Color(ColorConsts
                                                                          .primaryColor)),
                                                            ),
                                                      )
                                                  ],

                                                )
                                              ),
                                              Row(
                                                children: [
                                                  if(projectSnap
                                                      .data!
                                                      .data[idx]
                                                      .rating_user_count > 0)Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            6, 3, 7, 3),
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.fromLTRB(
                                                        2, 2, 0, 0),
                                                    decoration: BoxDecoration(
                                                        color: (projectSnap
                                                                    .data!
                                                                    .data[idx]
                                                                    .prod_quantity ==
                                                                0)
                                                            ? Color(0x9AB446FF)
                                                            : null,
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Color(ColorConsts
                                                                .primaryColor),
                                                            Color(ColorConsts
                                                                .secondaryColor)
                                                          ],
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    30.0)),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.star_rounded,
                                                          color: Color(
                                                              ColorConsts
                                                                  .whiteColor),
                                                          size: 13,
                                                        ),
                                                        Text(
                                                          " " +
                                                              projectSnap
                                                                  .data!
                                                                  .data[idx]
                                                                  .rating_average
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'OpenSans-Bold',
                                                              fontSize: 13,
                                                              color: Color(
                                                                  ColorConsts
                                                                      .whiteColor)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if(projectSnap
                                                      .data!
                                                      .data[idx]
                                                      .rating_user_count > 0)Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            6, 1, 6, 1),
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.fromLTRB(
                                                        2, 2, 0, 0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          projectSnap
                                                              .data!
                                                              .data[idx]
                                                              .rating_user_count
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'OpenSans-Bold',
                                                              fontSize: 14,
                                                              color: Color(
                                                                  ColorConsts
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
                                  } else {
                                    if (projectSnap.hasError) {}
                                    return Material(
                                        type: MaterialType.transparency,
                                        child: Container(
                                            height: 200,
                                            margin:
                                                EdgeInsets.fromLTRB(0, 0, 0, 4),
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                if (!projectSnap.hasError)
                                                  SizedBox(
                                                      child: CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation(
                                                                  Color(ColorConsts
                                                                      .primaryColor)),
                                                          backgroundColor:
                                                              Color(ColorConsts
                                                                  .primaryColorLyt),
                                                          strokeWidth: 4.0)),/*
                                                if (!projectSnap.hasError)
                                                  Container(
                                                      margin: EdgeInsets.all(8),
                                                      child: Text(
                                                        Resource.of(
                                                                context, "en")
                                                            .strings
                                                            .loadingPleaseWait,
                                                        style: TextStyle(
                                                            color: Color(
                                                                ColorConsts
                                                                    .primaryColor),
                                                            fontFamily:
                                                                'OpenSans-Bold',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 18),
                                                      )),*/
                                              ],
                                            )));
                                  }
                                })),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Stack(
                        children: [
                          Align(
                              alignment: Alignment.centerRight,
                              child: InkResponse(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return AllProducts(
                                          'People Also Viewed', '', '');
                                    },
                                  )).then((value) {
                                    _reload();
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(2, 12, 2, 13),
                                  child: Text('View All',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'OpenSans-Bold',
                                        color: Color(ColorConsts.primaryColor),
                                      )),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.fromLTRB(2, 12, 2, 13),
                            alignment: Alignment.centerLeft,
                            child: Text('People Also Viewed',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'OpenSans-Bold',
                                  color: Color(ColorConsts.textColor),
                                )),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                          child: FutureBuilder<ModelProduct>(
                              future: hasData
                                  ? CatePresenter().getSubCatProductList(
                                      _userLoginModel.data.token,
                                      '',
                                      '',
                                      'most_viewed',
                                      100,'')
                                  : null,
                              builder: (context, projectSnap) {
                                if (projectSnap.hasData) {
                                  if (projectSnap.data!.data.length > 0) {
                                    for (int i = 0;
                                        i < projectSnap.data!.data.length;
                                        i++) {
                                      if (projectSnap.data!.data[i].isLiked
                                          .toString()
                                          .contains("1")) {
                                        _counter
                                            .like(projectSnap.data!.data[i].variant_id);
                                      }
                                    }

                                    return StaggeredGrid.count(
                                      crossAxisCount: 4,
                                      mainAxisSpacing: 0.7,
                                      crossAxisSpacing: 0.7,
                                      children: [
                                        if (projectSnap.data!.data.length >= 1)
                                          StaggeredGridTile.count(
                                            crossAxisCellCount: 2,
                                            mainAxisCellCount: 3.6,
                                            child: Container(
                                              child: Stack(
                                                children: [
                                                  InkResponse(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                projectSnap
                                                                        .data!
                                                                        .data[0]
                                                                        .prod_image[
                                                                    0]),
                                                            alignment: Alignment
                                                                .topCenter,
                                                            fit: BoxFit.cover),
                                                      ),
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 4, 40),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                        builder: (context) {
                                                          return SingleItemScreen(
                                                              ''+projectSnap.data!
                                                                  .data[0].prod_name,
                                                              projectSnap.data!
                                                                  .data[0].id,
                                                              projectSnap
                                                                  .data!
                                                                  .data[0]
                                                                  .variant_id);
                                                        },
                                                      )).then((value) {
                                                        debugPrint(value);
                                                        _reload();
                                                      });
                                                    },
                                                  ),
                                                  if (projectSnap.data!.data[0]
                                                      .prod_quantity == 0)
                                                    Container(

                                                      decoration:
                                                      BoxDecoration(
                                                        gradient:
                                                        LinearGradient(
                                                          colors: [
                                                            Color(0x57000000),
                                                            Color(0x4D000000),
                                                          ],
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset:
                                                            Offset(1, 1),
                                                            blurRadius: 8,
                                                            color: Color
                                                                .fromRGBO(
                                                                0,
                                                                0,
                                                                0,
                                                                0.090),
                                                          )
                                                        ],
                                                        borderRadius:
                                                        BorderRadiusDirectional
                                                            .circular(
                                                            1.0),
                                                      ),
                                                      child: Container(
                                                          alignment: Alignment
                                                              .center,
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
                                                                  BorderRadiusDirectional.circular(
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
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    2),
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                child: Text(
                                                                  'Not Available',
                                                                  textAlign:
                                                                  TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                      'OpenSans-Bold',
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                      fontSize:
                                                                      14,
                                                                      color: Color(
                                                                          ColorConsts.whiteColor)),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    ),
                                                  Container(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: InkResponse(
                                                          onTap: () {
                                                            dpProLikeDisLike("" + projectSnap.data!.data[0].variant_id);
                                                            if (_counter
                                                                .likedIndex
                                                                .contains(
                                                                    projectSnap
                                                                        .data!
                                                                        .data[0]
                                                                        .variant_id)) {
                                                              _counter.disliked(
                                                                  projectSnap
                                                                      .data!
                                                                      .data[0]
                                                                      .variant_id);
                                                            } else {
                                                              _counter.like(
                                                                  projectSnap
                                                                      .data!
                                                                      .data[0]
                                                                      .variant_id);
                                                            }
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            margin: EdgeInsets
                                                                .fromLTRB(1, 9,
                                                                    9, 16),
                                                            width: 28,
                                                            height: 28,
                                                            decoration:
                                                                BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  offset:
                                                                      Offset(
                                                                          1, 1),
                                                                  blurRadius: 8,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0.090),
                                                                )
                                                              ],
                                                              border: Border.all(
                                                                  width: 0.7,
                                                                  color: Color(
                                                                      ColorConsts
                                                                          .whiteColor)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    20),
                                                              ),
                                                              color: Color(
                                                                  ColorConsts
                                                                      .whiteColor),
                                                            ),
                                                            child: Observer(
                                                                builder: (_) => (!_counter.likedIndex.contains("" +
                                                                        projectSnap
                                                                            .data!
                                                                            .data[
                                                                                0]
                                                                            .variant_id))
                                                                    ? Image
                                                                        .asset(
                                                                        'assets/icons/dislike.png',
                                                                        width:
                                                                            14,
                                                                        height:
                                                                            14,
                                                                      )
                                                                    : Image
                                                                        .asset(
                                                                        'assets/icons/like.png',
                                                                        width:
                                                                            14,
                                                                        height:
                                                                            14,
                                                                      )),
                                                          ))),
                                                  Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 0, 0),
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                child: Text(
                                                                  ' ' +
                                                                      projectSnap
                                                                          .data!
                                                                          .data[0]
                                                                          .pro_subtitle,
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontFamily:
                                                                          'OpenSans-Bold',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Color(
                                                                          ColorConsts
                                                                              .blackColor)),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            2,
                                                                            0,
                                                                            0),
                                                                    child: Text(
                                                                      ' $currencySym' +
                                                                          projectSnap
                                                                              .data!
                                                                              .data[0]
                                                                              .prod_unitprice
                                                                              .replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '') +
                                                                          " ",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'OpenSans-Bold',
                                                                          fontSize:
                                                                              13,
                                                                          color:
                                                                              Color(ColorConsts.blackColor)),
                                                                    ),
                                                                  ),
                                                                  if (double.parse((projectSnap.data!.data[0].prod_discount).toString()) > 0) Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            2),
                                                                    child: Text(
                                                                      projectSnap
                                                                          .data!
                                                                          .data[
                                                                              0]
                                                                          .prod_strikeout_price
                                                                          .replaceAll(
                                                                              RegExp(r'([.]*0)(?!.*\d)'),
                                                                              ''),
                                                                      style: TextStyle(
                                                                          decoration: TextDecoration
                                                                              .lineThrough,
                                                                          decorationThickness:
                                                                              2.2,
                                                                          fontFamily:
                                                                              'OpenSans',
                                                                          decorationStyle: TextDecorationStyle
                                                                              .solid,
                                                                          decorationColor: Colors
                                                                              .black54,
                                                                          fontSize:
                                                                              13,
                                                                          color:
                                                                              Color(ColorConsts.grayColor)),
                                                                    ),
                                                                  ),
                                                                  if (double.parse((projectSnap
                                                                              .data!
                                                                              .data[
                                                                                  0]
                                                                              .prod_discount)
                                                                          .toString()) >
                                                                      0)
                                                                    (projectSnap
                                                                            .data!
                                                                            .data[
                                                                                0]
                                                                            .prod_discount_type
                                                                            .contains(
                                                                                "flat"))
                                                                        ? Expanded(
                                                                            child:
                                                                                Text(
                                                                            " " +
                                                                                projectSnap.data!.data[0].prod_discount.toString() .replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '')+
                                                                                ' Flat Off',


                                                                            style: TextStyle(
                                                                                fontFamily: 'OpenSans',
                                                                                fontSize: 13,
                                                                                color: (projectSnap.data!.data[0].prod_quantity == 0) ? Color(0x9AB446FF) : Color(ColorConsts.primaryColor)),
                                                                          ))
                                                                        : Expanded(
                                                                            child:
                                                                                Text(
                                                                              " " + projectSnap.data!.data[0].prod_discount.toString() .replaceAll(
                                                                                  RegExp(r'([.]*0)(?!.*\d)'),
                                                                                  '') + '% Off',
                                                                              style: TextStyle(fontFamily: 'OpenSans', fontSize: 14, color: (projectSnap.data!.data[0].prod_quantity == 0) ? Color(0x9AB446FF) : Color(ColorConsts.primaryColor)),
                                                                            ),
                                                                          )
                                                                ],
                                                              )
                                                            ],
                                                          )))
                                                ],
                                              ),

                                            ),
                                          ),
                                        if (projectSnap.data!.data.length >= 2)
                                          StaggeredGridTile.count(
                                            crossAxisCellCount: 2,
                                            mainAxisCellCount: 1.8,
                                            child: Container(
                                              child: Stack(
                                                children: [
                                                  InkResponse(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                projectSnap
                                                                        .data!
                                                                        .data[1]
                                                                        .prod_image[
                                                                    0]),
                                                            alignment: Alignment
                                                                .topCenter,
                                                            fit: BoxFit.cover),
                                                      ),
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 40),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return SingleItemScreen(
                                                                  ''+projectSnap.data!
                                                                      .data[1].prod_name,
                                                                  projectSnap.data!
                                                                      .data[1].id,
                                                                  projectSnap
                                                                      .data!
                                                                      .data[1]
                                                                      .variant_id);
                                                            },
                                                          )).then((value) {
                                                        debugPrint(value);
                                                        _reload();
                                                      });


                                                    },
                                                  ),
                                                  if (projectSnap.data!.data[1]
                                                      .prod_quantity == 0)
                                                    Container(
                                                      height: 175,
                                                      decoration:
                                                      BoxDecoration(
                                                        gradient:
                                                        LinearGradient(
                                                          colors: [
                                                            Color(0x57000000),
                                                            Color(0x4D000000),
                                                          ],
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset:
                                                            Offset(1, 1),
                                                            blurRadius: 8,
                                                            color: Color
                                                                .fromRGBO(
                                                                0,
                                                                0,
                                                                0,
                                                                0.090),
                                                          )
                                                        ],
                                                        borderRadius:
                                                        BorderRadiusDirectional
                                                            .circular(
                                                            1.0),
                                                      ),
                                                      child: Container(
                                                          alignment: Alignment
                                                              .center,
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
                                                                  BorderRadiusDirectional.circular(
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
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    2),
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                child: Text(
                                                                  'Not Available',
                                                                  textAlign:
                                                                  TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                      'OpenSans-Bold',
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                      fontSize:
                                                                      14,
                                                                      color: Color(
                                                                          ColorConsts.whiteColor)),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    ),
                                                  Container(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: InkResponse(
                                                          onTap: () {
                                                            dpProLikeDisLike(
                                                                "" +
                                                                    projectSnap
                                                                        .data!
                                                                        .data[1]
                                                                        .variant_id);
                                                            if (_counter
                                                                .likedIndex
                                                                .contains(
                                                                    projectSnap
                                                                        .data!
                                                                        .data[1]
                                                                        .variant_id)) {
                                                              _counter.disliked(
                                                                  projectSnap
                                                                      .data!
                                                                      .data[1]
                                                                      .variant_id);
                                                            } else {
                                                              _counter.like(
                                                                  projectSnap
                                                                      .data!
                                                                      .data[1]
                                                                      .variant_id);
                                                            }
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            margin: EdgeInsets
                                                                .fromLTRB(1, 9,
                                                                    9, 16),
                                                            width: 28,
                                                            height: 28,
                                                            decoration:
                                                                BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  offset:
                                                                      Offset(
                                                                          1, 1),
                                                                  blurRadius: 8,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0.090),
                                                                )
                                                              ],
                                                              border: Border.all(
                                                                  width: 0.7,
                                                                  color: Color(
                                                                      ColorConsts
                                                                          .whiteColor)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    20),
                                                              ),
                                                              color: Color(
                                                                  ColorConsts
                                                                      .whiteColor),
                                                            ),
                                                            child: Observer(
                                                                builder: (_) => (!_counter.likedIndex.contains("" +
                                                                        projectSnap
                                                                            .data!
                                                                            .data[
                                                                                1]
                                                                            .variant_id))
                                                                    ? Image
                                                                        .asset(
                                                                        'assets/icons/dislike.png',
                                                                        width:
                                                                            14,
                                                                        height:
                                                                            14,
                                                                      )
                                                                    : Image
                                                                        .asset(
                                                                        'assets/icons/like.png',
                                                                        width:
                                                                            14,
                                                                        height:
                                                                            14,
                                                                      )),
                                                          ))),
                                                  Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    4, 0, 0, 0),
                                                            child: Text(
                                                              projectSnap.data!.data[1].pro_subtitle,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      'OpenSans-Bold',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color(
                                                                      ColorConsts
                                                                          .blackColor)),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            4,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        2),
                                                                child: Text(
                                                                  '$currencySym' +
                                                                      projectSnap
                                                                          .data!
                                                                          .data[
                                                                              1]
                                                                          .prod_unitprice
                                                                          .replaceAll(
                                                                              RegExp(r'([.]*0)(?!.*\d)'),
                                                                              '') +
                                                                      " ",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'OpenSans-Bold',
                                                                      fontSize:
                                                                          13,
                                                                      color: Color(
                                                                          ColorConsts
                                                                              .blackColor)),
                                                                ),
                                                              ),
                                                              if (double.parse((projectSnap.data!.data[1].prod_discount).toString()) > 0) Container(
                                                               padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        2),
                                                                child:
                                                                    Text(
                                                                      projectSnap
                                                                          .data!
                                                                          .data[
                                                                              1]
                                                                          .prod_strikeout_price
                                                                          .replaceAll(
                                                                              RegExp(r'([.]*0)(?!.*\d)'),
                                                                              ''),
                                                                      style: TextStyle(
                                                                          decoration: TextDecoration
                                                                              .lineThrough,
                                                                          decorationThickness:
                                                                              2.2,
                                                                          fontFamily:
                                                                              'OpenSans',
                                                                          decorationStyle: TextDecorationStyle
                                                                              .solid,
                                                                          decorationColor: Colors
                                                                              .black54,
                                                                          fontSize:
                                                                              13,
                                                                          color:
                                                                              Color(ColorConsts.grayColor)),
                                                                    ),

                                                              ),
                                                              if (double.parse((projectSnap
                                                                          .data!
                                                                          .data[
                                                                              1]
                                                                          .prod_discount)
                                                                      .toString()) >
                                                                  0)
                                                                (projectSnap
                                                                        .data!
                                                                        .data[1]
                                                                        .prod_discount_type
                                                                        .contains(
                                                                            "flat"))
                                                                    ? Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            2),
                                                                        child:

                                                                                    Text(
                                                                          " " +
                                                                              projectSnap.data!.data[1].prod_discount.toString()   .replaceAll(
                                                                                  RegExp(r'([.]*0)(?!.*\d)'),
                                                                                  '')+
                                                                              ' Flat Off',
                                                                          style: TextStyle(
                                                                              fontFamily: 'OpenSans',
                                                                              fontSize: 13,
                                                                              color: (projectSnap.data!.data[1].prod_quantity == 0) ? Color(0x9AB446FF) : Color(ColorConsts.primaryColor)),
                                                                        ))
                                                                    : Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            2),
                                                                        child:

                                                                              Text(
                                                                            "  " +
                                                                                projectSnap.data!.data[1].prod_discount.toString()   .replaceAll(
                                                                                    RegExp(r'([.]*0)(?!.*\d)'),
                                                                                    '')+
                                                                                '% Off',
                                                                            style: TextStyle(
                                                                                fontFamily: 'OpenSans',
                                                                                fontSize: 12.5,
                                                                                color: (projectSnap.data!.data[1].prod_quantity == 0) ? Color(0x9AB446FF) : Color(ColorConsts.primaryColor)),

                                                                        ))
                                                            ],
                                                          )
                                                        ],
                                                      ))
                                                ],
                                              ),

                                            ),
                                          ),
                                        if (projectSnap.data!.data.length >= 3)
                                          StaggeredGridTile.count(
                                            crossAxisCellCount: 2,
                                            mainAxisCellCount: 1.8,
                                            child: Container(
                                              child: Stack(
                                                children: [
                                                  InkResponse(
                                                    child: Container(
                                                      alignment:
                                                      Alignment.center,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                projectSnap
                                                                    .data!
                                                                    .data[2]
                                                                    .prod_image[
                                                                0]),
                                                            alignment: Alignment
                                                                .topCenter,
                                                            fit: BoxFit.cover),
                                                      ),
                                                      margin:
                                                      EdgeInsets.fromLTRB(
                                                          0, 0, 0, 40),
                                                    ),
                                                    onTap: () {


                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return SingleItemScreen(
                                                                  ''+projectSnap.data!
                                                                      .data[2].prod_name,
                                                                  projectSnap.data!
                                                                      .data[2].id,
                                                                  projectSnap
                                                                      .data!
                                                                      .data[2]
                                                                      .variant_id);
                                                            },
                                                          )).then((value) {
                                                        debugPrint(value);
                                                        _reload();
                                                      });

                                                    },
                                                  ),
                                                  if (projectSnap.data!.data[2]
                                                      .prod_quantity ==
                                                      0)
                                                    Container(
                                                      height: 175,
                                                      decoration:
                                                      BoxDecoration(
                                                        gradient:
                                                        LinearGradient(
                                                          colors: [
                                                            Color(0x57000000),
                                                            Color(0x4D000000),
                                                          ],
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset:
                                                            Offset(1, 1),
                                                            blurRadius: 8,
                                                            color: Color
                                                                .fromRGBO(
                                                                0,
                                                                0,
                                                                0,
                                                                0.090),
                                                          )
                                                        ],
                                                        borderRadius:
                                                        BorderRadiusDirectional
                                                            .circular(
                                                            1.0),
                                                      ),
                                                      child: Container(
                                                          alignment: Alignment
                                                              .center,
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
                                                                  BorderRadiusDirectional.circular(
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
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    2),
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                child: Text(
                                                                  'Not Available',
                                                                  textAlign:
                                                                  TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                      'OpenSans-Bold',
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                      fontSize:
                                                                      14,
                                                                      color: Color(
                                                                          ColorConsts.whiteColor)),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    ),
                                                  Container(
                                                    alignment:
                                                    Alignment.topRight,
                                                    child: InkResponse(
                                                        onTap: () {

                                                          dpProLikeDisLike("" +
                                                              projectSnap.data!
                                                                  .data[2].variant_id);
                                                          if (_counter
                                                              .likedIndex
                                                              .contains(
                                                              projectSnap
                                                                  .data!
                                                                  .data[2]
                                                                  .id)) {
                                                            _counter.disliked(
                                                                projectSnap
                                                                    .data!
                                                                    .data[2]
                                                                    .variant_id);
                                                          } else {
                                                            _counter.like(
                                                                projectSnap
                                                                    .data!
                                                                    .data[2]
                                                                    .variant_id);
                                                          }
                                                        },
                                                        child: Container(
                                                          alignment:
                                                          Alignment.center,
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                              1, 9, 9, 16),
                                                          width: 28,
                                                          height: 28,
                                                          decoration:
                                                          BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                offset: Offset(
                                                                    1, 1),
                                                                blurRadius: 8,
                                                                color: Color
                                                                    .fromRGBO(
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    0.090),
                                                              )
                                                            ],
                                                            border: Border.all(
                                                                width: 0.7,
                                                                color: Color(
                                                                    ColorConsts
                                                                        .whiteColor)),
                                                            borderRadius:
                                                            BorderRadius
                                                                .all(
                                                              Radius.circular(
                                                                  20),
                                                            ),
                                                            color: Color(
                                                                ColorConsts
                                                                    .whiteColor),
                                                          ),
                                                          child: Observer(
                                                              builder: (_) => (!_counter
                                                                  .likedIndex
                                                                  .contains("" +
                                                                  projectSnap
                                                                      .data!
                                                                      .data[2]
                                                                      .variant_id))
                                                                  ? Image.asset(
                                                                'assets/icons/dislike.png',
                                                                width: 14,
                                                                height:
                                                                14,
                                                              )
                                                                  : Image.asset(
                                                                'assets/icons/like.png',
                                                                width: 14,
                                                                height:
                                                                14,
                                                              )),
                                                        )),
                                                  ),
                                                  Align(
                                                      alignment:
                                                      Alignment.bottomLeft,
                                                      child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .end,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Container(
                                                              padding:
                                                              EdgeInsets
                                                                  .fromLTRB(
                                                                  4,
                                                                  0,
                                                                  0,
                                                                  0),
                                                              child: Text(
                                                                projectSnap
                                                                    .data!
                                                                    .data[2]
                                                                    .pro_subtitle,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    15,
                                                                    fontFamily:
                                                                    'OpenSans-Bold',
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                    color: Color(
                                                                        ColorConsts
                                                                            .blackColor)),
                                                              ),
                                                            ),
                                                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                      4,
                                                                      0,
                                                                      0,
                                                                      1.6),
                                                                  alignment:
                                                                  Alignment
                                                                      .center,
                                                                  margin: EdgeInsets
                                                                      .fromLTRB(
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0),
                                                                  child:
                                                                      Text(
                                                                        '$currencySym' +
                                                                            projectSnap.data!.data[2].prod_unitprice.replaceAll(RegExp(r'([.]*0)(?!.*\d)'),
                                                                                '') +
                                                                            " ",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                            'OpenSans-Bold',
                                                                            fontSize:
                                                                            13,
                                                                            color:
                                                                            Color(ColorConsts.blackColor)),

                                                                  ),
                                                                ),
                                                                if (double.parse(
                                                                    (projectSnap.data!.data[2].prod_discount).toString()) >
                                                                    0) Container(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0),
                                                                  alignment:
                                                                  Alignment
                                                                      .center,
                                                                  margin: EdgeInsets
                                                                      .fromLTRB(
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      2),
                                                                  child:
                                                                      Text(
                                                                        projectSnap
                                                                            .data!
                                                                            .data[
                                                                        2]
                                                                            .prod_strikeout_price
                                                                            .replaceAll(RegExp(r'([.]*0)(?!.*\d)'),
                                                                            ''),
                                                                        style: TextStyle(
                                                                            decoration: TextDecoration
                                                                                .lineThrough,
                                                                            decorationThickness:
                                                                            2.2,
                                                                            fontFamily:
                                                                            'OpenSans',
                                                                            decorationStyle: TextDecorationStyle
                                                                                .solid,
                                                                            decorationColor: Colors
                                                                                .black54,
                                                                            fontSize:
                                                                            13,
                                                                            color:
                                                                            Color(ColorConsts.grayColor)),

                                                                  ),
                                                                ),


                                                                      if (double.parse(
                                                                          (projectSnap.data!.data[2].prod_discount).toString()) >
                                                                          0)
                                                                        (projectSnap.data!.data[2].prod_discount_type.contains("flat"))
                                                                            ? Text(
                                                                          " " + projectSnap.data!.data[2].prod_discount.toString()   .replaceAll(
                                                                              RegExp(r'([.]*0)(?!.*\d)'),
                                                                              '')+ ' Flat Off',
                                                                          style: TextStyle(fontFamily: 'OpenSans', fontSize: 12.5, color: (projectSnap.data!.data[2].prod_quantity == 0) ? Color(0x9AB446FF) : Color(ColorConsts.primaryColor)),
                                                                        )

                                                                            :  Text(
                                                                          "  " + projectSnap.data!.data[2].prod_discount.toString()  .replaceAll(
                                                                              RegExp(r'([.]*0)(?!.*\d)'),
                                                                              '') + '% Off',
                                                                          style: TextStyle(fontFamily: 'OpenSans', fontSize: 12.5, color: (projectSnap.data!.data[2].prod_quantity == 0) ? Color(0x9AB446FF) : Color(ColorConsts.primaryColor)),


                                                                ),
                                                              ],
                                                            )
                                                          ]))
                                                ],
                                              ),

                                            ),
                                          ),
                                      ],
                                    );
                                  } else {
                                    return Container(
                                      margin: EdgeInsets.fromLTRB(40, 10, 40, 2),
                                      alignment: Alignment.center,
                                      child:Column(
                                          mainAxisAlignment:MainAxisAlignment.center,children: [
                                        Image.asset('assets/images/noDataFound.png',width: 200,),Text('No Data Found!',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'OpenSans-Bold',
                                              color: Color(ColorConsts.textColor),
                                            )) ]),
                                    );

                                  }
                                } else {
                                  return Material(
                                      type: MaterialType.transparency,
                                      child: Container(
                                          height: 160,
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
                                                          ColorConsts
                                                              .primaryColorLyt),
                                                      strokeWidth: 2.0)),/*
                                              Container(
                                                  margin: EdgeInsets.all(3),
                                                  child: Text(
                                                    Resource.of(context, "en")
                                                        .strings
                                                        .loadingPleaseWait,
                                                    style: TextStyle(
                                                        color: Color(ColorConsts
                                                            .primaryColor),
                                                        fontFamily:
                                                            'OpenSans-Bold',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14),
                                                  )),*/
                                            ],
                                          )));
                                }
                              })),
                    ),
                    SliverToBoxAdapter(
                        child: Container(
                            margin: EdgeInsets.fromLTRB(0, 27, 0, 12),
                            width: MediaQuery.of(context).size.width,
                            height: hasData?(bannersList.data.length > 1 )?140:0:60,
                            child:hasData? Stack(
                                      children: <Widget>[
                                        PageView.builder(
                                          controller: controllerTwo,
                                          itemCount:
                                              bannersList.data.length,
                                          itemBuilder: (_, index) {
                                            return InkResponse(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadiusDirectional
                                                          .circular(7.0),
                                                  color: Color(
                                                      ColorConsts.grayColor),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          bannersList
                                                              .data[index]
                                                              .banner_image),
                                                      alignment:
                                                          Alignment.topCenter,
                                                      fit: BoxFit.fill),
                                                ),
                                                height: 140,
                                                margin: EdgeInsets.fromLTRB(
                                                    1, 0, 7, 0),
                                              ),
                                              onTap: () async {

                                                await launch( bannersList
                                                    .data[index]
                                                    .banner_link);
                                              },
                                            );
                                          },
                                        ),
                                       if(bannersList.data.length > 1) Align(
                                          child: Container(
                                              alignment: Alignment.bottomCenter,
                                              height: 88,
                                              child: SmoothPageIndicator(
                                                controller: controllerTwo,
                                                count: bannersList
                                                    .data.length,
                                                axisDirection: Axis.horizontal,
                                                effect: ExpandingDotsEffect(
                                                    spacing: 8.0,
                                                    radius: 4.0,
                                                    dotWidth: 7.0,
                                                    dotHeight: 4.8,
                                                    paintStyle:
                                                        PaintingStyle.fill,
                                                    strokeWidth: 1,
                                                    dotColor: Color(0xffd9d7d7),
                                                    activeDotColor:
                                                        Color(0xffFFFFFF)),
                                              )),
                                        ),
                                      ],
                                    ):

                                     Material(
                                        type: MaterialType.transparency,
                                        child: Container(
                                            height: 90,
                                            margin:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                                            ColorConsts
                                                                .primaryColorLyt),
                                                        strokeWidth: 2.0)),
                                              /*  Container(
                                                    margin: EdgeInsets.all(3),
                                                    child: Text(
                                                      Resource.of(context, "en")
                                                          .strings
                                                          .loadingPleaseWait,
                                                      style: TextStyle(
                                                          color: Color(
                                                              ColorConsts
                                                                  .primaryColor),
                                                          fontFamily:
                                                              'OpenSans-Bold',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14),
                                                    )),*/
                                              ],
                                            ))),

                                )),

                    SliverToBoxAdapter(
                      child: SizedBox(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.fromLTRB(5, 12, 5, 0),
                            alignment: Alignment.center,
                            child: FutureBuilder<ModelProduct>(
                                future: hasData
                                    ? CatePresenter().getRecomm(
                                        _userLoginModel.data.token, 8)
                                    : null,
                                builder: (context, proRes) {
                                  if (proRes.hasError) {
                                    return Container();
                                  }
                                  if (proRes.hasData) {

                                    return (proRes.data!.data.length == 0)?Container():Column(children: [
                                      Stack(
                                        children: [
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: InkResponse(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                    builder: (context) {
                                                      return AllProducts(
                                                          'Recommended Items',
                                                          '',
                                                          '');
                                                    },
                                                  )).then((value) {
                                                    _reload();
                                                  });
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      2, 12, 2, 12),
                                                  child: Text('View All',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily:
                                                            'OpenSans-Bold',
                                                        color: Color(ColorConsts
                                                            .primaryColor),
                                                      )),
                                                ),
                                              )),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                2, 12, 2, 12),
                                            alignment: Alignment.centerLeft,
                                            child: Text('Recommended Items',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'OpenSans-Bold',
                                                  color: Color(
                                                      ColorConsts.textColor),
                                                )),
                                          ),
                                        ],
                                      ),
                                      GridView.builder(
                                          scrollDirection: Axis.vertical,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: proRes.data!.data.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 7,
                                            mainAxisExtent: 266,
                                          ),
                                          itemBuilder:
                                              (BuildContext context, int idx) {
                                            if (proRes.data!.data[idx].isLiked
                                                .toString()
                                                .contains("1")) {
                                              _counter.like(
                                                  proRes.data!.data[idx].variant_id);
                                            }

                                            return Column(
                                              // align the text to the left instead of centered
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Stack(
                                                  children: [
                                                    InkResponse(
                                                      child: Container(
                                                        height: 175,
                                                        child: (proRes
                                                                    .data!
                                                                    .data[idx]
                                                                    .prod_image
                                                                    .length >
                                                                0)
                                                            ? ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                child:
                                                                    FancyShimmerImage(
                                                                  imageUrl: proRes
                                                                      .data!
                                                                      .data[idx]
                                                                      .prod_image[0],
                                                                  boxFit: BoxFit
                                                                      .cover,
                                                                ),
                                                              )
                                                            : null,
                                                      ),
                                                      onTap: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                          builder: (context) {
                                                            return SingleItemScreen(
                                                                ''+proRes.data!.data[idx].prod_name,
                                                                proRes
                                                                    .data!
                                                                    .data[idx]
                                                                    .id,
                                                                proRes
                                                                    .data!
                                                                    .data[idx]
                                                                    .variant_id);
                                                          },
                                                        )).then((value) {
                                                          debugPrint(value);
                                                          _reload();
                                                        });
                                                      },
                                                    ),
//not available changes
                                                    if (proRes.data!.data[idx]
                                                            .prod_quantity ==
                                                        0)
                                                      Container(
                                                        height: 175,
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Color(0x57000000),
                                                              Color(0x4D000000),
                                                            ],
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight,
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              offset:
                                                                  Offset(1, 1),
                                                              blurRadius: 8,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0.090),
                                                            )
                                                          ],
                                                          borderRadius:
                                                              BorderRadiusDirectional
                                                                  .circular(
                                                                      7.0),
                                                        ),
                                                        child: Container(
                                                            alignment: Alignment
                                                                .center,
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
                                                                        BorderRadiusDirectional.circular(
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
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          2),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    'Not Available',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'OpenSans-Bold',
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            14,
                                                                        color: Color(
                                                                            ColorConsts.whiteColor)),
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                      ),
                                                    Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 12, 12, 0),
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: InkResponse(
                                                            onTap: () {
                                                              dpProLikeDisLike(
                                                                  "" +
                                                                      proRes
                                                                          .data!
                                                                          .data[
                                                                              idx]
                                                                          .variant_id);
                                                              if (_counter
                                                                  .likedIndex
                                                                  .contains(proRes
                                                                      .data!
                                                                      .data[idx]
                                                                      .variant_id)) {
                                                                _counter.disliked(
                                                                    proRes
                                                                        .data!
                                                                        .data[
                                                                            idx]
                                                                        .variant_id);
                                                              } else {
                                                                _counter.like(
                                                                    proRes
                                                                        .data!
                                                                        .data[
                                                                            idx]
                                                                        .variant_id);
                                                              }
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 28,
                                                              height: 28,
                                                              decoration:
                                                                  BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    offset:
                                                                        Offset(
                                                                            1,
                                                                            1),
                                                                    blurRadius:
                                                                        8,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            0.090),
                                                                  )
                                                                ],
                                                                border: Border.all(
                                                                    width: 0.7,
                                                                    color: Color(
                                                                        ColorConsts
                                                                            .whiteColor)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                                color: Color(
                                                                    ColorConsts
                                                                        .whiteColor),
                                                              ),
                                                              child: Observer(
                                                                  builder: (_) => (!_counter.likedIndex.contains("" +
                                                                          proRes
                                                                              .data!
                                                                              .data[
                                                                                  idx]
                                                                              .variant_id))
                                                                      ? Image
                                                                          .asset(
                                                                          'assets/icons/dislike.png',
                                                                          width:
                                                                              14,
                                                                          height:
                                                                              14,
                                                                        )
                                                                      : Image
                                                                          .asset(
                                                                          'assets/icons/like.png',
                                                                          width:
                                                                              14,
                                                                          height:
                                                                              14,
                                                                        )),
                                                            ))),
                                                  ],
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      2, 2, 0, 0),
                                                  child: Text(
                                                    proRes.data!.data[idx]
                                                        .pro_subtitle,
                                                    maxLines: 3,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'OpenSans-Bold',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15,
                                                        color: (proRes
                                                                    .data!
                                                                    .data[idx]
                                                                    .prod_quantity ==
                                                                0)
                                                            ? Color(ColorConsts
                                                                .grayColor)
                                                            : Color(ColorConsts
                                                                .blackColor)),
                                                  ),
                                                  width: 150,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      2, 0, 0, 2.5),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '$currencySym' +
                                                            proRes
                                                                .data!
                                                                .data[idx]
                                                                .prod_unitprice
                                                                .toString()
                                                                .replaceAll(
                                                                    RegExp(
                                                                        r'([.]*0)(?!.*\d)'),
                                                                    '') +
                                                            " ",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'OpenSans',
                                                            fontSize: 12.5,
                                                            color: (idx == 5)
                                                                ? Color(ColorConsts
                                                                    .grayColor)
                                                                : Color(ColorConsts
                                                                    .textColor)),
                                                      ),
                                                      if (double.parse((proRes
                                                          .data!
                                                          .data[idx]
                                                          .prod_discount)
                                                          .toString()) >
                                                          0)if (double.parse(proRes
                                                              .data!
                                                              .data[idx]
                                                              .prod_strikeout_price) >=
                                                          1.0)
                                                        Text(
                                                          '' +
                                                              proRes
                                                                  .data!
                                                                  .data[idx]
                                                                  .prod_strikeout_price
                                                                  .toString()
                                                                  .replaceAll(
                                                                      RegExp(
                                                                          r'([.]*0)(?!.*\d)'),
                                                                      ''),
                                                          style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              decorationThickness:
                                                                  2.2,
                                                              fontFamily:
                                                                  'OpenSans',
                                                              decorationStyle:
                                                                  TextDecorationStyle
                                                                      .solid,
                                                              decorationColor:
                                                                  Colors
                                                                      .black54,
                                                              fontSize: 12.5,
                                                              color: Color(
                                                                  ColorConsts
                                                                      .grayColor)),
                                                        ),
                                                      if (double.parse((proRes
                                                                  .data!
                                                                  .data[idx]
                                                                  .prod_discount)
                                                              .toString()) >
                                                          0)
                                                        (proRes.data!.data[idx]
                                                                .prod_discount_type
                                                                .contains(
                                                                    "flat"))
                                                            ? Flexible(child:Text(
                                                                " " +
                                                                    proRes
                                                                        .data!
                                                                        .data[
                                                                            idx]
                                                                        .prod_discount
                                                                        .toString() .replaceAll(RegExp(r'([.]*0)(?!.*\d)'),
                                                                        '')+
                                                                    ' Flat Off',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'OpenSans',
                                                                    fontSize:
                                                                    12.5,
                                                                    color: (proRes.data!.data[idx].prod_quantity ==
                                                                            0)
                                                                        ? Color(
                                                                            0x9AB446FF)
                                                                        : Color(
                                                                            ColorConsts.primaryColor)),
                                                              )
                                                        )
                                                            : Flexible(child:Text(
                                                                " " +
                                                                    proRes
                                                                        .data!
                                                                        .data[
                                                                            idx]
                                                                        .prod_discount
                                                                        .toString() .replaceAll(RegExp(r'([.]*0)(?!.*\d)'),
                                                                        '')+
                                                                    '% Off',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'OpenSans',
                                                                    fontSize:
                                                                        12.5,
                                                                    color: (proRes.data!.data[idx].prod_quantity ==
                                                                            0)
                                                                        ? Color(
                                                                            0x9AB446FF)
                                                                        : Color(
                                                                            ColorConsts.primaryColor)),
                                                              ),
                                                        )
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    if(proRes
                                                        .data!
                                                        .data[idx]
                                                        .rating_user_count > 0)Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              6, 3, 7, 3),
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              2, 2, 0, 0),
                                                      decoration: BoxDecoration(
                                                          color: (proRes.data!.data[idx].prod_quantity == 0)
                                                              ? Color(
                                                                  0x9AB446FF)
                                                              : null,
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Color(ColorConsts
                                                                  .primaryColor),
                                                              Color(ColorConsts
                                                                  .secondaryColor)
                                                            ],
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0)),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.star_rounded,
                                                            color: Color(
                                                                ColorConsts
                                                                    .whiteColor),
                                                            size: 13,
                                                          ),
                                                          Text(
                                                            " " +
                                                                proRes
                                                                    .data!
                                                                    .data[idx]
                                                                    .rating_average
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'OpenSans-Bold',
                                                                fontSize: 13,
                                                                color: Color(
                                                                    ColorConsts
                                                                        .whiteColor)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if(proRes
                                                        .data!
                                                        .data[idx]
                                                        .rating_user_count>0)Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              6, 1, 6, 1),
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              2, 2, 0, 0),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            proRes
                                                                .data!
                                                                .data[idx]
                                                                .rating_user_count
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'OpenSans-Bold',
                                                                fontSize: 14,
                                                                color: Color(
                                                                    ColorConsts
                                                                        .lightGrayColor)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          })
                                    ]);
                                  } else {
                                    return Material(
                                        type: MaterialType.transparency,
                                        child: Container(
                                            height: 200,
                                            margin:
                                                EdgeInsets.fromLTRB(0, 0, 0, 4),
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
                                                            ColorConsts
                                                                .primaryColorLyt),
                                                        strokeWidth: 4.0)),
                                              /*  Container(
                                                    margin: EdgeInsets.all(8),
                                                    child: Text(
                                                      Resource.of(context, "en")
                                                          .strings
                                                          .loadingPleaseWait,
                                                      style: TextStyle(
                                                          color: Color(
                                                              ColorConsts
                                                                  .primaryColor),
                                                          fontFamily:
                                                              'OpenSans-Bold',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 18),
                                                    )),*/
                                              ],
                                            )));
                                  }
                                })),
                      ),
                    ),
                  ])),
              Container(
                  margin: EdgeInsets.fromLTRB(12.0, 65.0, 12.0, 0.0),
                  child: UpgradeCard()),
            ],
          ),
        ),
      ),
    );
  }
}
