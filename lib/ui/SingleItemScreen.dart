import 'dart:convert';

import 'package:e_com/localdb/AppDatabase.dart';
import 'package:e_com/localdb/ListEntity.dart';
import 'package:e_com/model/ModelMostSoldProduct.dart';
import 'package:e_com/model/ModelQues.dart';
import 'package:e_com/model/ModelReviewGraph.dart';
import 'package:e_com/model/ModelReviews.dart';
import 'package:e_com/model/ModelSettings.dart';
import 'package:e_com/presenter/ReviewPresenter.dart';
import 'package:e_com/presenter/SoldItemPresenter.dart';
import 'package:e_com/presenter/ViewCountPresenter.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:e_com/model/ModelProduct.dart';
import 'package:e_com/model/ModelProductSingle.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/presenter/CateSubProductPresenter.dart';
import 'package:e_com/ui/MyCart.dart';
import 'package:e_com/model/ModelHomePage.dart';
import 'package:e_com/utils/mobxStateManagement.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:e_com/utils/Resource.dart';
import '../utils/SharedPref.dart';
import 'Notifications.dart';
import 'ProfileEdit.dart';
import 'Search.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../utils/SharedPref.dart';


String nameItem = '', prodId = '', varientId = '';

class SingleItemScreen extends StatefulWidget {
  int? shouldChange;

  SingleItemScreen(String s, String id, varId) {
    nameItem = s;
    prodId = id;
    varientId = varId;
  }

  @override
  State<StatefulWidget> createState() => new _State();
}

class LanguageDetails {
  const LanguageDetails({required this.title, required this.i});

  final String title;
  final String i;
}

class _State extends State<SingleItemScreen> {
  String currSym = '\$';
  TextEditingController quesController = TextEditingController();
  final controller = PageController(viewportFraction: 0.99, keepPage: false, initialPage: 0);
  bool hasData = false;
  int indexValue = 0;
  int quan = 1;
  String selectedSize = "";
  int selectedPrice=0;
  SharedPref sharePrefs = SharedPref();
  String? tag = '';
  late UserLoginModel _userLoginModel;
  late ModelProductSingle productSingle;
  final _counter = Counter();
  late final access;
  late final database;
  String cartLength = "0";
  late String color_name;
  bool tillLoad = false;
  int va_index = 0;
  late ModelReviewGraph modelReviewGraph;
  late Map<String, dynamic> parsed;
  late ModelQues modelQuesRes;
  late ModelSettings modelSettings;
  bool desLessMore = true;
  List<ProdSize> sizes = []; // Add this line
Future<void> getValue() async {
    tag = await sharePrefs.getLanguage();
    _userLoginModel = await sharePrefs.getLoginUserData();
    String? sett = await sharePrefs.getSettings();
    final Map<String, dynamic> parsed = json.decode(sett!);
    modelSettings = ModelSettings.fromJson(parsed);
    currSym = modelSettings.data.currency_symbol.toString();
    getSingleProduct();
  }

  Future<void> initDb() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db')
        .build();
    access = database.daoaccess;
    refreshDb();
    super.initState();
  }


  Future<void> refreshDb() async {
    List<ListEntity> listdata = await access.getAll();
    cartLength = listdata.length.toString();
    setState(() {});
  }

  @override
  void initState() {
    controller.addListener(() {
      indexValue = controller.page!.round();
      setState(() {});
    });
    initDb();
    getValue();
    super.initState();
  }

  dpProLikeDisLike(String product_id) {
    CatePresenter().doLikeProduct(_userLoginModel.data.token, _userLoginModel.data.id, product_id);
    getSingleProduct();
  }

  getSingleProduct() async {
    productSingle = await CatePresenter().getSingleProd(_userLoginModel.data.token, prodId);
    if (productSingle.data.isLiked.toString().contains("1")) {
      if (!hasData) {
        _counter.like(productSingle.data.prod_variants[va_index].variant_id);
      }
    }

    if (nameItem.isEmpty) {
      nameItem = productSingle.data.prod_name;
    }
    hasData = true;
    await ViewCountPresenter().getList(_userLoginModel.data.token, prodId, _userLoginModel.data.id);

    varientchange();
  }

  Future<void> varientchange() async {
    for (int i = 0; i < productSingle.data.prod_variants.length; i++) {
      if (varientId.contains(productSingle.data.prod_variants[i].variant_id)) {
        va_index = i;
      }
    }

    color_name = "" + productSingle.data.prod_variants[va_index].prod_attributes.toString();
    parsed = json.decode(color_name);
    color_name = "" + parsed["Colorname"].toString();
    if (color_name.contains("null")) {
      color_name = "Not found";
    }
    tillLoad = false;
    modelReviewGraph = await ReviewPresenter().getAverageRating(
        _userLoginModel.data.token, prodId);
    // Populate sizes
    setState(() {
      sizes = productSingle.data.prod_variants[va_index].prod_sizes; // Update sizes list
    });
    getQuestion();
  }

  Future<void> getQuestion() async {
    modelQuesRes = await ReviewPresenter().getQues(_userLoginModel.data.token, prodId);
    setState(() {});
  }

  Future<void> sendQuestion() async {
    String result = await ReviewPresenter().sendQues(
        _userLoginModel.data.token,
        _userLoginModel.data.id,
        prodId,
        productSingle.data.prod_sellerid,
        quesController.text);
    if (result.contains("1")) {
      quesController.text = "";
      getQuestion();
    } else {
      Fluttertoast.showToast(
          msg: 'Re-Try !',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Color(ColorConsts.whiteColor),
          fontSize: 14.0);
    }
  }

  addReviewHelpCount(String review_id) async {
    Fluttertoast.showToast(
        msg: 'Processing please wait..',
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Color(ColorConsts.whiteColor),
        fontSize: 14.0);
    await ReviewPresenter().reviewHelpfulCount(_userLoginModel.data.token, review_id);
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body:Material(
              child:Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Color(0xffffffff),
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
                            /* Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(34, 0, 100, 0),
                          child: Text(nameItem,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(ColorConsts.whiteColor))),
                        ),
                      ),*/
                            Container( width: 55,child: InkResponse(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/icons/Arrow.png',
                                    width: 20,
                                    height: 21,
                                    color: Color(ColorConsts.whiteColor),
                                  ),
                                ),
                              ),
                            ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 6, 89, 6),
                                width: 50,child:
                              Align(
                                  alignment: Alignment.centerRight,
                                  child:  InkResponse(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return Search();
                                      },));
                                    },child: Container(

                                    child: Image.asset(
                                      'assets/icons/SearchIcon.png',
                                      width: 21,
                                      height: 20,
                                      color: Color(ColorConsts.whiteColor),
                                    ),
                                  ),
                                  )
                              ),
                              ),
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
                                    if(hasData)if(modelSettings.data.notifications_count>0)Align(
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
                                  },)).then((value) => refreshDb());
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
                                            cartLength,
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
                    if(!hasData)Container(
                        child:    Material(
                            type: MaterialType.transparency,
                            child: Container(
                                height: MediaQuery.of(context).size.height,
                                margin: EdgeInsets.fromLTRB(0, 50, 0, 4),
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
                                ))
                        )
                    ),
                    if(hasData)Container(

                        child: CustomScrollView(
                          slivers: [

                            SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        productSingle.data.prod_brand.toString()+", "+  productSingle.data.prod_name+" ("+productSingle.data.prod_variants[va_index].pro_subtitle+")",
                                        style: TextStyle(
                                            fontFamily: 'OpenSans-Bold',
                                            fontSize: 18,
                                            color: Color(ColorConsts.textColor)),
                                      ),
                                      margin: EdgeInsets.fromLTRB(16, 2, 16, 10),
                                    ),
                                    Row(
                                      children: [
                                        if(productSingle.data.rating_user_count>0)Container(
                                          padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.fromLTRB(16, 2, 0, 0),
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
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.star_rounded,
                                                color: Color(ColorConsts.whiteColor),
                                                size: 14,
                                              ),
                                              Text(
                                                ' '+productSingle.data.rating_average.toString(),
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans-Bold',
                                                    fontSize: 14,
                                                    color: Color(ColorConsts.whiteColor)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if(productSingle.data.rating_user_count>0)Container(
                                          padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                          child: Row(
                                            children: [
                                              Text(
                                                ''+productSingle.data.rating_user_count.toString(),
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans-Bold',
                                                    fontSize: 15,
                                                    color:
                                                    Color(ColorConsts.lightGrayColor)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(9, 3, 9, 3),
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.fromLTRB(12, 2, 12, 0),
                                          decoration: BoxDecoration(
                                              gradient: (productSingle.data.prod_variants[va_index].prod_quantity == 0)?LinearGradient(
                                                colors: [
                                                  Color(ColorConsts.redColor),
                                                  Color(ColorConsts.redColor)
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ):LinearGradient(
                                                colors: [
                                                  Color(ColorConsts.green),
                                                  Color(ColorConsts.green)
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                              borderRadius: BorderRadius.circular(30.0)),
                                          child: Row(
                                            children: [
                                              Text(
                                                (productSingle.data.prod_variants[va_index].prod_quantity ==0)?'Not In Stock':'In Stock',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans-Bold',
                                                    fontSize: 14,
                                                    color: Color(ColorConsts.whiteColor)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        if(!hasData)Container(
                                            height: 345,
                                            width: MediaQuery.of(context).size.width,
                                            margin: EdgeInsets.fromLTRB(16, 14, 16, 8),
                                            child:   Container(


                                              width: MediaQuery.of(context).size.width,
                                              height: 335,
                                              child:ClipRRect(
                                                borderRadius: BorderRadius.circular(8.0),
                                                child: FancyShimmerImage(
                                                  imageUrl:''+productSingle.data.prod_variants[va_index].prod_image[0],
                                                  boxFit: BoxFit.cover,
                                                ),
                                              ) ,
                                            )



                                        ),
                                        if(hasData)Container(
                                          height: 342,
                                          width: MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.fromLTRB(16, 14, 16, 8),
                                          child:  PageView.builder(
                                              controller: controller,
                                              itemCount:productSingle.data.prod_variants[va_index].prod_image.length,

                                              itemBuilder: (context, int idx) {

                                                return Container(
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        offset: Offset(1, 1),
                                                        blurRadius: 2,
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 0.090),
                                                      )
                                                    ],
                                                    borderRadius:
                                                    BorderRadiusDirectional.circular(7.0),
                                                    image: DecorationImage(
                                                      image: NetworkImage(productSingle.data.prod_variants[va_index].prod_image[idx]),
                                                      fit: BoxFit.contain,
                                                      alignment: Alignment.topCenter,
                                                    ),
                                                  ),
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 335,

                                                )
                                                ;
                                              }
                                          ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.fromLTRB(10, 22, 22, 0),
                                            alignment: Alignment.centerRight,
                                            child: Column(
                                              children: [
                                                if(hasData)InkResponse(onTap: () {
                                                  if(_counter.likedIndex.contains(productSingle.data.prod_variants[va_index].variant_id)){
                                                    _counter.disliked(productSingle.data.prod_variants[va_index].variant_id);
                                                  }else {
                                                    _counter.like(productSingle.data.prod_variants[va_index].variant_id);
                                                  }
                                                  dpProLikeDisLike(""+productSingle.data.prod_variants[va_index].variant_id);

                                                },child: Container(
                                                  alignment: Alignment.center,
                                                  margin:
                                                  EdgeInsets.fromLTRB(0, 6, 9, 16),
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
                                                            ColorConsts.whiteColor)),
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                    color: Color(ColorConsts.whiteColor),
                                                  ),
                                                  child: Observer(
                                                      builder: (_) => (!_counter.likedIndex.contains(""+productSingle.data.prod_variants[va_index].variant_id))
                                                          ? Image.asset('assets/icons/dislike.png', width: 14, height: 14,
                                                      )
                                                          : Image.asset('assets/icons/like.png', width: 14, height: 14,
                                                      )
                                                  ),
                                                )
                                                ),
                                                /*  InkResponse(onTap: () {
                                      Fluttertoast.showToast(
                                          msg: 'share',
                                          toastLength: Toast.LENGTH_SHORT,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey,
                                          textColor: Color(ColorConsts.whiteColor),
                                          fontSize: 14.0);
                                    },child: Container(
                                        alignment: Alignment.center,
                                        margin:
                                            EdgeInsets.fromLTRB(0, 2, 9, 16),
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
                                                  ColorConsts.whiteColor)),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          color: Color(ColorConsts.whiteColor),
                                        ),
                                        child: Image.asset(
                                                'assets/icons/share.png',
                                                width: 14,
                                                height: 14,
                                              )
                                             )
                                    )*/
                                              ],
                                            )),
                                        if(hasData)Container(
                                            width: 70,
                                            height: 300,
                                            margin: EdgeInsets.fromLTRB(28, 22, 22, 0),
                                            alignment: Alignment.centerLeft,

                                            child: ListView.builder(
                                                scrollDirection: Axis.vertical,


                                                itemCount:productSingle.data.prod_variants[va_index].prod_image.length,
                                                itemBuilder: (context, int idx) {
                                                  return
                                                    //images
                                                    InkResponse(onTap: () {
                                                      indexValue=idx;
                                                      controller.jumpToPage(indexValue);
                                                      setState(() {

                                                      });

                                                    },child: Container(
                                                      height: 60,
                                                      width: 60,
                                                      margin: EdgeInsets.fromLTRB(4, 6, 2, 8),
                                                      decoration: new BoxDecoration(
                                                          image: DecorationImage(
                                                            image:
                                                            NetworkImage(productSingle.data.prod_variants[va_index].prod_image[idx]),
                                                            fit: BoxFit.cover,
                                                            alignment: Alignment.topCenter,
                                                          ),
                                                          border: Border.all(
                                                              color: (indexValue==idx)?Color(ColorConsts.primaryColor):Color(ColorConsts.whiteColor), width: 0.8),
                                                          borderRadius: BorderRadius.circular(4.0)),



                                                    )
                                                    );

                                                }
                                            )



                                        )
                                      ],
                                    ),

                                  ],

                                )),
                            if(hasData)SliverToBoxAdapter(
                              child: Container(

                                  alignment: Alignment.bottomCenter,

                                  height: 25,

                                  child:  SmoothPageIndicator(
                                    controller: controller,
                                    count: productSingle.data.prod_variants[va_index].prod_image.length,

                                    axisDirection: Axis.horizontal,
                                    effect:  ExpandingDotsEffect(
                                        spacing:  8.0,
                                        radius:  4.0,
                                        dotWidth:  7.0,
                                        dotHeight:  4.8,
                                        paintStyle:  PaintingStyle.fill,
                                        strokeWidth:  1,
                                        dotColor:  Color(0xffd9d7d7),
                                        activeDotColor: Color(ColorConsts.primaryColor)

                                    ),
                                  )
                              ),
                            ),



                            SliverToBoxAdapter(
                                child: SizedBox(
                                    child: Container(
                                      child: Row(

                                        children: [
                                          Text(
                                            "Color Name : ",
                                            style: TextStyle(
                                                fontFamily: 'OpenSans-Bold',
                                                fontSize: 20,

                                                color: Color(ColorConsts.grayColor)),
                                          ),
                                          if(hasData)Text(
                                            color_name,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans-Bold',
                                                fontSize: 20,
                                                color: Color(ColorConsts.blackColor)),
                                          ),
                                        ],
                                      ),
                                      margin: EdgeInsets.fromLTRB(14, 12, 14, 10),
                                    ))),
                            SliverToBoxAdapter(child:SizedBox(
                              height: 100, child:
                            ListView.builder(
                                scrollDirection: Axis.horizontal,


                                itemCount: productSingle.data.prod_variants.length,
                                itemBuilder: (context, int idx) {
                                  return

                                    //images

                                    InkResponse(onTap: () {
                                      tillLoad=true;
                                      setState(() {

                                      });
                                      varientId=productSingle.data.prod_variants[idx].variant_id;
                                      varientchange();
                                    },child: Container(
                                      height: 90,
                                      width: 90,
                                      margin: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                      decoration: new BoxDecoration(
                                          image: DecorationImage(

                                            image:
                                            NetworkImage(
                                                productSingle.data.prod_variants[idx].prod_image[0]),
                                            fit: BoxFit.cover,
                                            alignment: Alignment.topCenter,
                                          ),
                                          border: Border.all(
                                              color: (va_index==idx)?Color(ColorConsts.primaryColor):Color(ColorConsts.whiteColorTrans), width: 1.5),
                                          borderRadius: BorderRadius.circular(6.0)),
                                      child: (tillLoad)?CircularProgressIndicator(
                                          valueColor:
                                          AlwaysStoppedAnimation(
                                              Color(ColorConsts
                                                  .primaryColor)),
                                          backgroundColor: Color(
                                              ColorConsts.primaryColorLyt),
                                          strokeWidth: 3.0):Container(),padding: EdgeInsets.all(12),

                                    )
                                      ,);
                                }







                            ),
                            )
                            ),
                            SliverToBoxAdapter(child: Column(
                              mainAxisAlignment: MainAxisAlignment.start ,
                              crossAxisAlignment:CrossAxisAlignment.start,children: [

                              Container(height: 1,
                                color: Color(ColorConsts.barGrayColor),
                                margin: EdgeInsets.fromLTRB(0, 12, 0, 12),),
                              Container(
                                width: 120,
                                padding: EdgeInsets.fromLTRB(
                                    6, 4, 6,4),
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(
                                    16, 2, 0, 0),
                                decoration: BoxDecoration(


                                    gradient: LinearGradient(
                                      colors: [
                                        Color(ColorConsts
                                            .pinkLytColor),
                                        Color(ColorConsts
                                            .pinkLytColor)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(
                                        30.0)),
                                child:

                                Text(
                                  'Best Price',
                                  style: TextStyle(
                                      fontFamily:
                                      'OpenSans-Bold',
                                      fontSize: 16,
                                      color: Color(ColorConsts
                                          .barColor)),


                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(16, 4, 0, 0),
                                child: Row(children: [
                                  // Display the selected size's price
                                  Text(
                                    '$currSym ${productSingle.data.prod_variants[va_index].prod_sizes.firstWhere(
                                            (size) => size.size == selectedSize,
                                        orElse: () => ProdSize(size: '', quantity: 0, price: 0)
                                    ).price.toString()} ',
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 20,
                                      color: Color(ColorConsts.blackColor),
                                    ),
                                  ),
                                  if (double.parse((productSingle.data.prod_variants[va_index].prod_discount).toString()) > 0)
                                    if (productSingle.data.prod_variants[va_index].prod_strikeout_price != 0)
                                      Text(
                                        '${productSingle.data.prod_variants[va_index].prod_strikeout_price.toString()}',
                                        style: TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          decorationThickness: 2.2,
                                          fontFamily: 'OpenSans',
                                          decorationStyle: TextDecorationStyle.solid,
                                          decorationColor: Colors.black54,
                                          fontSize: 13,
                                          color: Color(ColorConsts.grayColor),
                                        ),
                                      ),
                                  if (double.parse((productSingle.data.prod_variants[va_index].prod_discount).toString()) > 0)
                                    (productSingle.data.prod_variants[va_index].prod_discount_type.contains("flat"))
                                        ? Text(
                                      " ${productSingle.data.prod_variants[va_index].prod_discount.toString()} Flat Off",
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 13,
                                        color: (productSingle.data.prod_variants[va_index].prod_quantity == 0)
                                            ? Color(0x9AB446FF)
                                            : Color(ColorConsts.primaryColor),
                                      ),
                                    )
                                        : Text(
                                      " ${productSingle.data.prod_variants[va_index].prod_discount.toString()}% Off",
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 13,
                                        color: (productSingle.data.prod_variants[va_index].prod_quantity == 0)
                                            ? Color(0x9AB446FF)
                                            : Color(ColorConsts.primaryColor),
                                      ),
                                    ),
                                ]),
                              ),
                              /*    Container(
            margin: EdgeInsets.fromLTRB(
                16, 2, 0, 0),
            child: Row(children: [
              Image.asset('assets/icons/offer.png',height: 16,width: 19,),
              Text(
                ' $currSym 50 OFF | For Your 1st Order',
                style: TextStyle(
                    fontFamily:
                    'OpenSans-Bold',
                    fontSize: 16,
                    color: Color(ColorConsts
                        .grayColor)),


              )
            ],),
          ),*/
                              Container(
                                width: 120,
                                padding: EdgeInsets.fromLTRB(
                                    8, 4, 8,4),
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(
                                    16, 4, 0, 2),
                                decoration: BoxDecoration(


                                    gradient: LinearGradient(
                                      colors: [
                                        Color(ColorConsts
                                            .whiteLytColor),
                                        Color(ColorConsts
                                            .whiteLytColor)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(
                                        30.0)),
                                child:

                                Text(
                                  Resource.of(context,tag!).strings.FreeDelivery ,
                                  style: TextStyle(
                                      fontFamily:
                                      'OpenSans-Bold',
                                      fontSize: 15,
                                      color: Color(ColorConsts
                                          .grayColor))
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Available Options:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    // Display sizes in a list using ChoiceChip
                                    Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      children: sizes.map((size) {
                                        return ChoiceChip(
                                          label: Text('${size.size}'),
                                          selected: selectedSize == size.size,
                                          onSelected: (isSelected) {
                                            setState(() {
                                              if (isSelected) {
                                                selectedSize = size.size;
                                                quan = 1;
                                                selectedPrice = size.price;
                                              } else {
                                                selectedSize = "";
                                                quan = 1;
                                                selectedPrice = 0;
                                              }
                                            });
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                color: Colors.grey,
                                margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(16, 4, 0, 4),
                                child: Row(
                                  children: [
                                    Text(
                                      'Quantity:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Container(
                                      height: 45,
                                      width: 140,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.fromLTRB(12, 12, 9, 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey, width: 0.6),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkResponse(
                                            onTap: () {
                                              if (quan > 1) {
                                                setState(() {
                                                  quan--;
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: 45,
                                              height: 45,
                                              padding: EdgeInsets.all(0),
                                              child: Image.asset('assets/icons/Minus.png'),
                                            ),
                                          ),
                                          Container(
                                            height: 55,
                                            width: 1,
                                            color: Colors.grey,
                                          ),
                                          Container(
                                            width: 35,
                                            alignment: Alignment.center,
                                            child: Text(
                                              '$quan',
                                              style: TextStyle(
                                                fontSize: 21,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 55,
                                            width: 1,
                                            color: Colors.grey,
                                          ),
                                          InkResponse(
                                            onTap: () {
                                              var selectedSizeData = sizes.firstWhere(
                                                      (size) => size.size == selectedSize,
                                                  orElse: () => ProdSize(size: '', quantity: 0, price: 0));
                                              if (quan < selectedSizeData.quantity) {
                                                setState(() {
                                                  quan++;
                                                });
                                              } else {
                                                Fluttertoast.showToast(
                                                  msg: 'Not Available!',
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.grey,
                                                  textColor: Colors.white,
                                                  fontSize: 14.0,
                                                );
                                              }
                                            },
                                            child: Container(
                                              width: 45,
                                              height: 45,
                                              padding: EdgeInsets.all(10),
                                              child: Image.asset('assets/icons/Plus.png', width: 10),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '(${sizes.firstWhere((size) => size.size == selectedSize, orElse: () => ProdSize(size: '', quantity: 0, price: 0)).quantity} Available)',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(16, 4, 0, 4),
                                child: Text(
                                  'Price: ${(quan * selectedPrice).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              //   Container(
                            //     padding: EdgeInsets.all(16.0),
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Text(
                            //           'Available Options:',
                            //           style: TextStyle(
                            //             fontSize: 18,
                            //             fontWeight: FontWeight.bold,
                            //           ),
                            //         ),
                            //         SizedBox(height: 10),
                            //         // Display sizes in a list using ChoiceChip
                            //         Wrap(
                            //           spacing: 8.0,
                            //           runSpacing: 4.0,
                            //           children: sizes.map((size) {
                            //             return ChoiceChip(
                            //               label: Text('${size.size}'),
                            //               selected: selectedSize == size.size,
                            //               onSelected: (isSelected) {
                            //                 setState(() {
                            //                   selectedSize = isSelected ? size.size : "";
                            //                   quan = isSelected ? size.quantity : 1;  // Update quan based on the selected size
                            //                 });
                            //               },
                            //             );
                            //           }).toList(),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            //   Container(
                            //     height: 1,
                            //     color: Color(ColorConsts.barGrayColor),
                            //     margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            //   ),
                            //   Container(
                            //       margin: EdgeInsets.fromLTRB(16, 4, 0, 4),
                            //       child: Row(
                            //         children: [
                            //         Text(
                            //         'Quantity:',
                            //         style: TextStyle(
                            //           fontFamily: 'OpenSans-Bold',
                            //           fontSize: 18,
                            //           fontWeight: FontWeight.w500,
                            //           color: Color(ColorConsts.blackColor),
                            //         ),
                            //       ),
                            //       Container(
                            //         height: 45,
                            //         width: 140,
                            //         alignment: Alignment.center,
                            //         margin: EdgeInsets.fromLTRB(12, 12, 9, 8),
                            //         decoration: BoxDecoration(
                            //           border: Border.all(color: Color(ColorConsts.grayColor), width: 0.6),
                            //           borderRadius: BorderRadius.circular(8.0),
                            //         ),
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //           children: [
                            //             InkResponse(
                            //               onTap: () {
                            //                 if (quan > 1) {
                            //                   setState(() {
                            //                     quan--;
                            //                   });
                            //                 }
                            //               },
                            //               child: Container(
                            //                 width: 45,
                            //                 height: 45,
                            //                 padding: EdgeInsets.all(0),
                            //                 child: Image.asset('assets/icons/Minus.png'),
                            //               ),
                            //             ),
                            //             Container(
                            //               height: 55,
                            //               width: 1,
                            //               color: Color(ColorConsts.grayColor),
                            //             ),
                            //             Container(
                            //               width: 35,
                            //               alignment: Alignment.center,
                            //               child: Text(
                            //                 '$quan',
                            //                 style: TextStyle(
                            //                   fontFamily: 'OpenSans',
                            //                   fontSize: 21,
                            //                   color: Color(ColorConsts.grayColor),
                            //                 ),
                            //               ),
                            //             ),
                            //             Container(
                            //               height: 55,
                            //               width: 1,
                            //               color: Color(ColorConsts.grayColor),
                            //             ),
                            //             InkResponse(
                            //               onTap: () {
                            //                 if (quan < productSingle.data.prod_variants[va_index].prod_quantity) {
                            //                   setState(() {
                            //                     quan++;
                            //                   });
                            //                 } else {
                            //                   Fluttertoast.showToast(
                            //                     msg: 'Not Available!',
                            //                     toastLength: Toast.LENGTH_SHORT,
                            //                     timeInSecForIosWeb: 1,
                            //                     backgroundColor: Colors.grey,
                            //                     textColor: Color(ColorConsts.whiteColor),
                            //                     fontSize: 14.0,
                            //                   );
                            //                 }
                            //               },
                            //               child: Container(
                            //                 width: 45,
                            //                 height: 45,
                            //                 padding: EdgeInsets.all(10),
                            //                 child: Image.asset('assets/icons/Plus.png', width: 10),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //       Text(
                            //         '(${productSingle.data.prod_variants[va_index].prod_quantity} Available)',
                            //         style: TextStyle(
                            //           fontFamily: 'OpenSans',
                            //           fontSize: 16,
                            //           color: Color(ColorConsts.grayColor),
                            //         ),
                            //       ),
                            //       ],
                            //       ),
                            // ),

                              /*   Container(height: 1,
            color: Color(ColorConsts.barGrayColor),
            margin: EdgeInsets.fromLTRB(0, 8, 0, 8),),*/
                              /* Container(
            margin: EdgeInsets.fromLTRB(
                16, 4, 0, 4),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
              children: [ Container(
              width: 400,child: Text(
              'Select Size: '+selectedSize,
              style: TextStyle(
                  fontFamily:
                  'OpenSans-Bold',
    fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Color(ColorConsts
                      .blackColor)),


            ),
              ),
                Container(
          width: 400,
                height: 70,
                child:ListView.builder(
                  scrollDirection: Axis.horizontal,


                  itemCount: listSize.length,
                  itemBuilder: (context, int idx) {
                    return InkResponse(onTap: () {
                      selectedSize=listSize[idx];
                      setState(() {

                      });
                    },child: Container(
                      height: 38,
                      width: 49,
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(0, 12, 12, 8),
                      decoration: new BoxDecoration(

                          border: Border.all(
                              color: (listSize[idx].toString()==selectedSize)?Color(ColorConsts.secondaryColor):Color(ColorConsts.grayColor), width: 0.8),
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Text(
                      listSize[idx],
                        style: TextStyle(
                            fontFamily:
                            'OpenSans-Bold',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: (listSize[idx].toString()==selectedSize)?Color(ColorConsts.secondaryColor):Color(ColorConsts.grayColor)),


                      ),


                    )
                    )
                    ;

                  }
              ) ,)
            ],)
          ),*/
                              /*
          Container(height: 1,
            color: Color(ColorConsts.barGrayColor),
            margin: EdgeInsets.fromLTRB(0, 8, 0, 8),),Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Offers & Coupons",
                  style: TextStyle(
                      fontFamily: 'OpenSans-Bold',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(ColorConsts.textColor)),
                ),
                Text(
                  "View all",
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 18,
                      color: Color(ColorConsts.primaryColor)),
                ),
              ],
            ),
            margin: EdgeInsets.fromLTRB(14, 12, 14, 10),
          ),*/


                            ],),),/*SliverToBoxAdapter(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 2,
                      itemBuilder: (context, int idx) {
                        return Container(


                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(12, 12, 12, 8),
                          padding: EdgeInsets.all(9),
                          decoration: new BoxDecoration(

                              border: Border.all(
                                  color: Color(ColorConsts.grayColor), width: 0.7),
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,children: [
                           Row(children: [
                             Image.asset(
                             'assets/icons/tag.png',
                             width: 22,
                             height: 14,
                           ),Text(
                             'Special Offer',
                             style: TextStyle(
                                 fontFamily:
                                 'OpenSans-Bold',
                                 fontSize: 18,
                                 color: Color(ColorConsts
                                     .blackColor)),


                           )],) ,

                            Container(child: Text(
                              'Upto Rs. 1500 Off with Dabit Card + 20% Off on First Order.',
                              style: TextStyle(
                                  fontFamily:
                                  'OpenSans',
                                  fontSize: 16,
                                  color: Color(ColorConsts
                                      .grayColor)

                              ),

                            ),margin: EdgeInsets.fromLTRB(0, 8, 0, 1),

                            )
                          ],),


                        );

                      }
                  ) ,
                    ),*/

                            SliverToBoxAdapter(
                                child:Container(
                                    margin:EdgeInsets.fromLTRB(0, 6, 0, 6),child:
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,children: [
                                  Container(height: 1,
                                    color: Color(ColorConsts.barGrayColor),
                                    margin: EdgeInsets.fromLTRB(0, 12, 0, 8),),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
                                    child:   Text(
                                      'Delivery Point',
                                      style: TextStyle(
                                          fontFamily:
                                          'OpenSans-Bold',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Color(ColorConsts
                                              .blackColor)),


                                    ),
                                  ),
                                  /*     Stack(children: [
Container(margin: EdgeInsets.fromLTRB(12, 0, 60, 0),child:TextField( decoration: InputDecoration(
    hintText:
    'Enter Your Pin Code',
    hintStyle: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 16.5,
        color: Color(ColorConsts.lightGrayColor)),
    border: InputBorder.none
),style: TextStyle(
    color: Color(ColorConsts.blackColor),
    fontSize: 17.0,
    fontFamily: 'OpenSans')
),),
              Align(
                alignment: Alignment.centerRight,child:Container(
                margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
                child:   Text(
                  'Check',

                  style: TextStyle(
                      fontFamily:
                      'OpenSans-Bold',
                      fontSize: 18,
                      color: Color(ColorConsts
                          .primaryColor)),


                ),
              ),
              )
            ],),*/
                                  /* Container(height: 0.4,
              color: Color(ColorConsts.barGrayColor),
              margin: EdgeInsets.fromLTRB(12, 0, 12, 8),),*/
                                  if(hasData)Container(
                                    margin: EdgeInsets.fromLTRB(12, 13, 12, 0),
                                    child:   Text(
                                      ''+_userLoginModel.data.fullname,
                                      style: TextStyle(
                                          fontFamily:
                                          'OpenSans-Bold',
                                          fontSize: 18,
                                          color: Color(ColorConsts
                                              .blackColor)),


                                    ),
                                  ),
                                  if(hasData)if(_userLoginModel.data.address.isNotEmpty)Container(
                                    margin: EdgeInsets.fromLTRB(12, 5, 12, 8),
                                    child:   Text(
                                      ''+_userLoginModel.data.address,
                                      style: TextStyle(
                                          fontFamily:
                                          'OpenSans-Bold',
                                          fontSize: 18,
                                          color: Color(ColorConsts
                                              .grayColor)),


                                    ),
                                  ),
                                  if(hasData)if(_userLoginModel.data.address.isEmpty)Container(
                                      margin: EdgeInsets.fromLTRB(12, 5, 12, 8),
                                      child:   InkResponse(onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                          return ProfileEdit();
                                        },));
                                      },child: Text(
                                        'Click Here To Add Address For Delivery',
                                        style: TextStyle(
                                            fontFamily:
                                            'OpenSans-Bold',
                                            fontSize: 18,
                                            color: Color(ColorConsts
                                                .primaryColor)),


                                      ),
                                      )
                                  ),

                                  Container(height: 1,
                                    color: Color(ColorConsts.barGrayColor),
                                    margin: EdgeInsets.fromLTRB(0, 18, 0, 8),),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(11, 0, 12, 8),child: Text(
                                    'Product Details ',
                                    style: TextStyle(
                                        fontFamily:
                                        'OpenSans-Bold',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Color(ColorConsts
                                            .blackColor)),


                                  ),
                                  ),

                                  ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:parsed.length,
                                      itemBuilder: (context, int idx) {
                                        return Container(
                                          margin: EdgeInsets.fromLTRB(11, 4, 4, 0),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween
                                            , children: [
                                              Container(alignment: Alignment.centerLeft,
                                                  width: 154, child: Text((parsed.keys.toList()[idx].toString().contains("Colorname"))?"Color name":''+parsed.keys.toList()[idx], style: TextStyle(
                                                      fontFamily:
                                                      'OpenSans-Bold',
                                                      fontSize: 16,
                                                      color: Color(ColorConsts
                                                          .grayColor)))
                                              ),
                                              Container(width: 26, child: Text(':', style: TextStyle(
                                                  fontFamily:
                                                  'OpenSans-Bold',
                                                  fontSize: 17,
                                                  color: Color(ColorConsts
                                                      .grayColor)))
                                              ),
                                              (parsed.values.toList()[idx].toString().contains("#"))?Container(
                                                  width: 190,
                                                  height: 20,
                                                  alignment: Alignment.centerRight,
                                                  decoration: new BoxDecoration(
                                                      borderRadius: BorderRadius.circular(22.0)),
                                                  padding: EdgeInsets.fromLTRB(139, 0, 0, 0),
                                                  child: Container(
                                                    alignment: Alignment.centerRight,
                                                    width: 30,
                                                    decoration: new BoxDecoration(
                                                        color: HexColor(parsed.values.toList()[idx].toString()),
                                                        borderRadius: BorderRadius.circular(3.0)),
                                                  )

                                              ):Container(     width:(MediaQuery.of(context).size.width - 199),
                                                  alignment: Alignment.centerRight,
                                                  child: Text(parsed.values.toList()[idx].toString(), style: TextStyle(
                                                      fontFamily:
                                                      'OpenSans-Bold',
                                                      fontSize: 16,
                                                      color: Color(ColorConsts
                                                          .grayColor)))
                                              ),

                                            ],),
                                        );
                                      }),



                                  /*    Container(
                margin: EdgeInsets.fromLTRB(13.5,12, 12, 0),child:Text(
              'View More',
              style: TextStyle(
                  fontFamily:
                  'OpenSans-Bold',
                  fontSize: 15,
                  color: Color(ColorConsts
                      .primaryColor)),


            ),
              ),*/
                                  Container(height: 1,
                                    color: Color(ColorConsts.barGrayColor),
                                    margin: EdgeInsets.fromLTRB(0, 22, 0, 5),)
                                  ,
                                  Row(
                                    children: [
                                      Text(
                                        '  Description',
                                        style: TextStyle(
                                            fontFamily:
                                            'OpenSans',
                                            fontSize: 20,
                                            color: Color(ColorConsts
                                                .primaryColor)),


                                      ),
                                      /*  Container(width: 1,
                height: 50,color: Color(ColorConsts.grayColor),),
                Text(
                  'More Info',
                  style: TextStyle(
                      fontFamily:
                      'OpenSans',
                      fontSize: 20,
                      color: Color(ColorConsts
                          .grayColor)),


                ),*/
                                    ],),
                                  /*Container(height: 1,
              color: Color(ColorConsts.barGrayColor),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),)
            ,*/
                                  if(hasData)Container(margin: EdgeInsets.fromLTRB(12, 6, 12, 0),child: Text(
                                    (desLessMore && (productSingle.data.prod_description.length > 149))?productSingle.data.prod_description.substring(0,150):productSingle.data.prod_description,
                                    style: TextStyle(
                                        fontFamily:
                                        'OpenSans-Bold',
                                        fontSize: 16,
                                        color: Color(ColorConsts
                                            .grayColor)),


                                  ),
                                  ),

                                  if(hasData && (productSingle.data.prod_description.length > 149))InkResponse(child: Container(width: MediaQuery.of(context).size.width,alignment: Alignment.centerRight,margin: EdgeInsets.fromLTRB(12, 0, 12, 0),child: Text(
                                    desLessMore?'Read more..':'Read less',
                                    style: TextStyle(
                                        fontFamily:
                                        'OpenSans-Bold',
                                        fontSize: 16,
                                        color: Color(ColorConsts
                                            .barColor)),


                                  ),
                                  ),onTap: () {
                                    if (desLessMore) {
                                      desLessMore = false;
                                    } else {
                                      desLessMore = true;
                                    }

                                    setState(() {

                                    });
                                  }
                                  ),

                                  Container(height: 1,
                                    color: Color(ColorConsts.barGrayColor),
                                    margin: EdgeInsets.fromLTRB(0, 12, 0, 8),)
                                ],)
                                )

                            ),

                            SliverToBoxAdapter(
                                child: SizedBox(
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Similar Products",
                                            style: TextStyle(
                                                fontFamily: 'OpenSans-Bold',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Color(ColorConsts.textColor)),
                                          ),
                                          /* Text(
                                    "View all",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 18,
                                        color: Color(ColorConsts.primaryColor)),
                                  ),*/
                                        ],
                                      ),
                                      margin: EdgeInsets.fromLTRB(14, 12, 14, 10),
                                    ))),

                            SliverToBoxAdapter(
                              child: SizedBox(
                                child: Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
                                    alignment: Alignment.center,
                                    child: FutureBuilder<ModelProduct>(
                                        future: hasData
                                            ? CatePresenter().getSubCatProductList(
                                            _userLoginModel.data.token, productSingle.data.prod_cate,'','',6,'')
                                            : null,
                                        builder: (context, projectSnap) {

                                          if (projectSnap.hasData) {
                                            if (projectSnap.data!.data.length == 0) {
                                              return Column(children: [
                                                Container(
                                                    margin: EdgeInsets.fromLTRB(0, 24, 0, 4),
                                                    child: Image.asset(
                                                      'assets/images/noDataFound.png',
                                                      height: 160,
                                                    )),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(0, 9, 0, 24),
                                                  child: Text(
                                                    'No Results found under ' +
                                                        nameItem +
                                                        "!",
                                                    style: TextStyle(
                                                        fontFamily: 'OpenSans-Bold',
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 18,
                                                        color: Color(ColorConsts.textColor)),
                                                  ),
                                                )
                                              ]);
                                            }

                                            return GridView.builder(
                                                scrollDirection: Axis.vertical,
                                                physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: projectSnap.data!.data.length,
                                                gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 7,
                                                  mainAxisExtent: 266,),
                                                itemBuilder: (BuildContext context, int idx) {
                                                  if(projectSnap.data!
                                                      .data[idx].isLiked.toString().contains("1")) {
                                                    _counter.like(projectSnap.data!
                                                        .data[idx].variant_id);
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
                                                                      return SingleItemScreen(''+projectSnap.data!.data[idx].prod_name,projectSnap.data!.data[idx].id,projectSnap.data!.data[idx].variant_id);
                                                                    },)).then((value) {
                                                                debugPrint(value);
                                                                refreshDb();
                                                              });
                                                            },
                                                          ),
//not available changes
                                                          if (projectSnap.data!.data[idx].prod_quantity == 0)
                                                            Container(
                                                              height: 175,
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
                                                              margin: EdgeInsets.fromLTRB(10, 12, 12, 0),
                                                              alignment: Alignment.centerRight,
                                                              child: InkResponse(onTap:() {

                                                                dpProLikeDisLike(""+projectSnap.data!.data[idx].variant_id);
                                                                if(_counter.likedIndex.contains(projectSnap.data!.data[idx].variant_id)){
                                                                  _counter.disliked(projectSnap.data!
                                                                      .data[idx].variant_id);
                                                                }else {
                                                                  _counter.like(projectSnap.data!
                                                                      .data[idx].variant_id);
                                                                }


                                                              } ,child: Container(
                                                                alignment: Alignment.center,

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
                                                                child: Observer(
                                                                    builder: (_) => (!_counter.likedIndex.contains(""+projectSnap.data!.data[idx].variant_id))
                                                                        ? Image.asset('assets/icons/dislike.png', width: 14, height: 14,
                                                                    )
                                                                        : Image.asset('assets/icons/like.png', width: 14, height: 14,
                                                                    )
                                                                ),
                                                              )
                                                              )
                                                          ),
                                                        ],
                                                      ),


                                                      Container(
                                                        margin:
                                                        EdgeInsets.fromLTRB(2, 2, 0, 0),
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
                                                        width: 152,
                                                      ),
                                                      Container(
                                                        margin:
                                                        EdgeInsets.fromLTRB(2, 0, 0, 2.5),
                                                        child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              projectSnap.data!.data[idx].prod_unitprice.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '')+" ",
                                                              style: TextStyle(
                                                                  fontFamily: 'OpenSans',
                                                                  fontSize: 13,
                                                                  color: Color(ColorConsts.textColor)),
                                                            ),
                                                            if(double.parse((projectSnap.data!.data[idx].prod_discount).toString()) > 0)if(double.parse(projectSnap.data!.data[idx].prod_strikeout_price) >= 1.0)Text(
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
                                                            if(double.parse((projectSnap.data!.data[idx].prod_discount).toString()) > 0)(projectSnap.data!.data[idx].prod_discount_type.contains("flat"))?
                                                            Flexible(child: Text(
                                                              " "+projectSnap.data!.data[idx].prod_discount.toString()+' Flat Off',
                                                              style: TextStyle(
                                                                  fontFamily: 'OpenSans',
                                                                  fontSize: 12.5,
                                                                  color: (projectSnap.data!.data[idx].prod_quantity ==0)
                                                                      ? Color(0x9AB446FF)
                                                                      : Color(ColorConsts
                                                                      .primaryColor)),
                                                            )
                                                            ):Flexible(child: Text(
                                                              "  "+projectSnap.data!.data[idx].prod_discount.toString()+'% Off',
                                                              style: TextStyle(
                                                                  fontFamily: 'OpenSans',
                                                                  fontSize: 12.5,
                                                                  color: (projectSnap.data!.data[idx].prod_quantity ==0)
                                                                      ? Color(0x9AB446FF)
                                                                      : Color(ColorConsts
                                                                      .primaryColor)),
                                                            ),
                                                            )
                                                          ],
                                                        ),

                                                      ),
                                                      Row(
                                                        children: [
                                                          if(projectSnap.data!.data[idx].rating_user_count > 0)Container(
                                                            padding: EdgeInsets.fromLTRB(
                                                                6, 3, 7, 3),
                                                            alignment: Alignment.center,
                                                            margin: EdgeInsets.fromLTRB(
                                                                2, 2, 0, 0),
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
                                                          if(projectSnap.data!.data[idx].rating_user_count > 0)Container(
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
                                            return Material(
                                                type: MaterialType.transparency,
                                                child: Container(
                                                    height: 200,
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
                            if(hasData)SliverToBoxAdapter(
                              child: Column(
                                children: <Widget>[
                                  Container(height: 1,
                                    color: Color(ColorConsts.barGrayColor),
                                    margin: EdgeInsets.fromLTRB(0, 8, 0, 8),),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Products Reviews & Ratings',
                                      style: TextStyle(
                                          fontFamily: 'OpenSans-Bold',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Color(ColorConsts.blackColor)),
                                    ),
                                    margin: EdgeInsets.fromLTRB(12, 3, 0, 6),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 30,
                                        child: Icon(
                                          Icons.star_rounded,
                                          color: Color(ColorConsts.barColor),
                                          size: 29,
                                        ),
                                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      ),
                                      if(hasData)Container(
                                        height: 30,
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          modelReviewGraph.data.averageRating.toString(),

                                          style: TextStyle(
                                              fontFamily: 'OpenSans-Bold',
                                              fontSize: 28,
                                              fontWeight: FontWeight.w700,
                                              color: Color(ColorConsts.barColor)),
                                        ),
                                        margin: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                      ),
                                      Container(
                                        height: 30,
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          'Out of 5',
                                          style: TextStyle(
                                              fontFamily: 'OpenSans-Bold',
                                              fontSize: 16,
                                              color: Color(ColorConsts.blackColor)),
                                        ),
                                        margin: EdgeInsets.fromLTRB(4, 3.5, 0, 0),
                                      ),
                                    ],
                                  ),
                                  if(hasData)Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      modelReviewGraph.data.totalRatings.toString()+' Ratings, ${modelReviewGraph.data.totalReviews.toString()} Reviews',
                                      style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontSize: 16,
                                          color: Color(ColorConsts.grayColor)),
                                    ),
                                    margin: EdgeInsets.fromLTRB(12, 3, 0, 6),
                                  ),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(2, 6, 2, 0),
                                      height: 25,
                                      child: Stack(
                                        children: [
                                          Align(
                                            child: Container(
                                              child: Icon(
                                                Icons.star_rounded,
                                                color: Color(ColorConsts.yelloColor),
                                                size: 16.6,
                                              ),
                                              margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                            ),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          Align(
                                            child: Container(
                                              child: Text(
                                                '5',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 15,
                                                    color:
                                                    Color(ColorConsts.grayColor)),
                                              ),
                                              margin: EdgeInsets.fromLTRB(28, 0, 0, 0),
                                            ),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          Align(
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(35, 0, 0, 0),
                                              child: new LinearPercentIndicator(
                                                width:
                                                MediaQuery.of(context).size.width -
                                                    82,
                                                lineHeight: 5.0,
                                                backgroundColor:
                                                Color(ColorConsts.barGrayColor),
                                                percent: double.parse((modelReviewGraph.data.ratingInPercantage.five/100).toString()),
                                                progressColor:
                                                Color(ColorConsts.barColor),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                          Align(
                                            child: Container(
                                              child: Text(
                                                modelReviewGraph.data.ratingInPercantage.five.toString()+'%',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 15,
                                                    color:
                                                    Color(ColorConsts.grayColor)),
                                              ),
                                              margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                            ),
                                            alignment: Alignment.centerRight,
                                          ),
                                        ],
                                      )),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(2, 6, 2, 0),
                                      height: 25,
                                      child: Stack(
                                        children: [
                                          Align(
                                            child: Container(
                                              child: Icon(
                                                Icons.star_rounded,
                                                color: Color(ColorConsts.yelloColor),
                                                size: 16.6,
                                              ),
                                              margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                            ),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          Align(
                                            child: Container(
                                              child: Text(
                                                '4',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 15,
                                                    color:
                                                    Color(ColorConsts.grayColor)),
                                              ),
                                              margin: EdgeInsets.fromLTRB(28, 0, 0, 0),
                                            ),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          Align(
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(35, 0, 0, 0),
                                              child: new LinearPercentIndicator(
                                                width:
                                                MediaQuery.of(context).size.width -
                                                    82,
                                                lineHeight: 5.0,
                                                backgroundColor:
                                                Color(ColorConsts.barGrayColor),
                                                percent: double.parse((modelReviewGraph.data.ratingInPercantage.four/100).toString()),
                                                progressColor:
                                                Color(ColorConsts.barColor),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                          Align(
                                            child: Container(
                                              child: Text(
                                                modelReviewGraph.data.ratingInPercantage.four.toString()+'%',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 15,
                                                    color:
                                                    Color(ColorConsts.grayColor)),
                                              ),
                                              margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                            ),
                                            alignment: Alignment.centerRight,
                                          ),
                                        ],
                                      )),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(2, 6, 2, 0),
                                      height: 25,
                                      child: Stack(
                                        children: [
                                          Align(
                                            child: Container(
                                              child: Icon(
                                                Icons.star_rounded,
                                                color: Color(ColorConsts.yelloColor),
                                                size: 16.6,
                                              ),
                                              margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                            ),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          Align(
                                            child: Container(
                                              child: Text(
                                                '3',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 15,
                                                    color:
                                                    Color(ColorConsts.grayColor)),
                                              ),
                                              margin: EdgeInsets.fromLTRB(28, 0, 0, 0),
                                            ),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          Align(
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(35, 0, 0, 0),
                                              child: new LinearPercentIndicator(
                                                width:
                                                MediaQuery.of(context).size.width -82,
                                                lineHeight: 5.0,
                                                backgroundColor:
                                                Color(ColorConsts.barGrayColor),
                                                percent: double.parse((modelReviewGraph.data.ratingInPercantage.three/100).toString()),
                                                progressColor:
                                                Color(ColorConsts.barColor),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                          Align(
                                            child: Container(
                                              child: Text(
                                                modelReviewGraph.data.ratingInPercantage.three.toString()+'%',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 15,
                                                    color:
                                                    Color(ColorConsts.grayColor)),
                                              ),
                                              margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                            ),
                                            alignment: Alignment.centerRight,
                                          ),
                                        ],
                                      )),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(2, 6, 2, 0),
                                      height: 25,
                                      child: Stack(
                                        children: [
                                          Align(
                                            child: Container(
                                              child: Icon(
                                                Icons.star_rounded,
                                                color: Color(ColorConsts.yelloColor),
                                                size: 16.6,
                                              ),
                                              margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                            ),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          Align(
                                            child: Container(
                                              child: Text(
                                                '2',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 15,
                                                    color:
                                                    Color(ColorConsts.grayColor)),
                                              ),
                                              margin: EdgeInsets.fromLTRB(28, 0, 0, 0),
                                            ),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          Align(
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(35, 0, 0, 0),
                                              child: new LinearPercentIndicator(
                                                width:
                                                MediaQuery.of(context).size.width -
                                                    82,
                                                lineHeight: 5.0,
                                                backgroundColor:
                                                Color(ColorConsts.barGrayColor),
                                                percent: double.parse((modelReviewGraph.data.ratingInPercantage.two/100).toString()),
                                                progressColor:
                                                Color(ColorConsts.barColor),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                          Align(
                                            child: Container(
                                              child: Text(
                                                modelReviewGraph.data.ratingInPercantage.two.toString()+'%',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 15,
                                                    color:
                                                    Color(ColorConsts.grayColor)),
                                              ),
                                              margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                            ),
                                            alignment: Alignment.centerRight,
                                          ),
                                        ],
                                      )),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(2, 6, 2, 0),
                                      height: 25,
                                      child: Stack(
                                        children: [
                                          Align(
                                            child: Container(
                                              child: Icon(
                                                Icons.star_rounded,
                                                color: Color(ColorConsts.yelloColor),
                                                size: 16.6,
                                              ),
                                              margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                            ),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          Align(
                                            child: Container(
                                              child: Text(
                                                '1',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 15,
                                                    color:
                                                    Color(ColorConsts.grayColor)),
                                              ),
                                              margin: EdgeInsets.fromLTRB(28, 0, 0, 0),
                                            ),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          Align(
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(35, 0, 0, 0),
                                              child: new LinearPercentIndicator(
                                                width:
                                                MediaQuery.of(context).size.width -
                                                    82,
                                                lineHeight: 5.0,
                                                backgroundColor:
                                                Color(ColorConsts.barGrayColor),
                                                percent: double.parse((modelReviewGraph.data.ratingInPercantage.one/100).toString()),
                                                progressColor:
                                                Color(ColorConsts.barColor),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                          Align(
                                            child: Container(
                                              child: Text(
                                                modelReviewGraph.data.ratingInPercantage.one.toString()+'%',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 15,
                                                    color:
                                                    Color(ColorConsts.grayColor)),
                                              ),
                                              margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                            ),
                                            alignment: Alignment.centerRight,
                                          ),
                                        ],
                                      )),
                                  Container(height: 1,
                                    color: Color(ColorConsts.barGrayColor),
                                    margin: EdgeInsets.fromLTRB(0, 22, 0, 8),),
                                ],
                              ),
                            ),
                            SliverToBoxAdapter(
                                child: SizedBox(
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Customer Reviews & Image",
                                            style: TextStyle(
                                                fontFamily: 'OpenSans-Bold',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Color(ColorConsts.textColor)),
                                          ),
                                          /*  Text(
                                    "View all",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 18,
                                        color: Color(ColorConsts.primaryColor)),
                                  ),*/
                                        ],
                                      ),
                                      margin: EdgeInsets.fromLTRB(10, 12, 8, 0),
                                    ))),
                            if(hasData)SliverToBoxAdapter(
                                child:FutureBuilder<ModelReviews>(
                                    future: hasData
                                        ? ReviewPresenter().getListWithProId(_userLoginModel.data.token,productSingle.data.id,'')
                                        : null,
                                    builder: (context, projectSnap) { if(projectSnap.hasData) {


                                      if (projectSnap.data!.data.length == 0) {
                                        return Column(children: [
                                          Container(
                                              margin: EdgeInsets.fromLTRB(0, 24, 0, 4),
                                              child: Image.asset(
                                                'assets/images/noDataFound.png',
                                                height: 140,
                                              )),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0, 12, 0, 24),
                                            child: Text(
                                              'No Reviews Yet '
                                                  "!",
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans-Bold',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: Color(ColorConsts.textColor)),
                                            ),
                                          )
                                        ]);
                                      }
                                      return ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: projectSnap.data!.data.length,
                                          itemBuilder: (context, int idx) {
                                            return Column(children: [
                                              Container(margin: EdgeInsets.fromLTRB(12, 24, 10, 2)
                                                , child:
                                                Stack(children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                    width: 36,
                                                    height: 36,
                                                    decoration: BoxDecoration(

                                                      image: DecorationImage(
                                                        image:
                                                        NetworkImage(projectSnap.data!.data[idx].rating_user_image),
                                                        fit: BoxFit.cover,
                                                        alignment: Alignment.topCenter,
                                                      ),
                                                      border: Border.all(
                                                          width: 0.1,
                                                          color: Color(
                                                              ColorConsts.grayColor)),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                      color: Color(ColorConsts.grayColor),
                                                    ),
                                                  ),
                                                  Container(width: 150,
                                                    margin: EdgeInsets.fromLTRB(40, 6, 0, 0),
                                                    child: Align(child: Text(
                                                      projectSnap.data!.data[idx].rating_uname,
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'OpenSans-Bold',
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 18,
                                                          color: Color(ColorConsts
                                                              .blackColor)),


                                                    ),
                                                      alignment: Alignment.centerLeft,),
                                                  ),
                                                  Container(
                                                    width: 60,
                                                    padding: EdgeInsets.fromLTRB(1, 3, 1, 3),
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.fromLTRB(150, 6, 0, 0),
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
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          Icons.star_rounded,
                                                          color: Color(ColorConsts.whiteColor),
                                                          size: 15,
                                                        ),
                                                        Text(
                                                          " "+projectSnap.data!.data[idx].rating.toString(),
                                                          style: TextStyle(
                                                              fontFamily: 'OpenSans-Bold',
                                                              fontSize: 15,
                                                              color: Color(ColorConsts.whiteColor)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),


                                                  Align(child: Container(
                                                    margin: EdgeInsets.fromLTRB(0, 6, 0, 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end, children: [
                                                      Image.asset(
                                                        'assets/icons/Calender.png', height: 15, width: 22,),
                                                      Text(
                                                        projectSnap.data!.data[idx].createdAt,
                                                        style: TextStyle(
                                                            fontFamily:
                                                            'OpenSans-Bold',

                                                            fontSize: 15,
                                                            color: Color(ColorConsts
                                                                .grayColor)),


                                                      ),
                                                    ],),
                                                    alignment: Alignment.centerRight,),
                                                    alignment: Alignment.centerRight,)
                                                ]),
                                              ),
                                              Container(alignment: Alignment.centerLeft,margin: EdgeInsets.fromLTRB(12, 2, 12, 2), child: Text(
                                                projectSnap.data!.data[idx].review,
                                                style: TextStyle(
                                                    fontFamily:
                                                    'OpenSans-Bold',

                                                    fontSize: 17,
                                                    color: Color(ColorConsts
                                                        .grayColor)),


                                              ),),
                                              /*  Container(
                  margin: EdgeInsets.fromLTRB(10, 2, 22, 0),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      //images

                      Container(
                        height: 65,
                        width: 65,
                        margin: EdgeInsets.fromLTRB(4, 6, 12, 8),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                              image:
                              AssetImage('assets/images/tsht.png'),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),

                            borderRadius: BorderRadius.circular(7.0)),


                      ),
                      Container(
                        height: 65,
                        width: 65,
                        margin: EdgeInsets.fromLTRB(8, 6, 12, 8),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                              image:
                              AssetImage('assets/images/redtst.png'),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                            borderRadius: BorderRadius.circular(7.0)),


                      ),
                      Container(
                        height: 65,
                        width: 65,
                        margin: EdgeInsets.fromLTRB(8, 6, 12, 8),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                              image:
                              AssetImage('assets/images/blackTsht.png'),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                            borderRadius: BorderRadius.circular(7.0)),


                      ),


                    ],
                  )),*/
                                              Row(
                                                children: [
                                                  InkResponse(onTap: () {
                                                    addReviewHelpCount( projectSnap.data!.data[idx].review_id);
                                                  },child: Container(
                                                      alignment: Alignment.center,
                                                      margin: EdgeInsets.fromLTRB(12, 9, 8, 8),
                                                      padding: EdgeInsets.all(9),
                                                      decoration: new BoxDecoration(

                                                          border: Border.all(
                                                              color: Color(ColorConsts.secondaryColor),
                                                              width: 0.7),
                                                          borderRadius: BorderRadius.circular(8.0)),
                                                      child: Row(children: [
                                                        Image.asset(
                                                          'assets/icons/thumb.png', height: 20, width: 27,),
                                                        Text(
                                                          'Helpful',
                                                          style: TextStyle(
                                                              fontFamily:
                                                              'OpenSans-Bold',
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 18,
                                                              color: Color(ColorConsts
                                                                  .barColor)),)
                                                      ])
                                                  ),
                                                  ),
                                                  if(projectSnap.data!.data[idx].helpful_count > 0)Text(
                                                    projectSnap.data!.data[idx].helpful_count.toString()+' People found this helpful',
                                                    style: TextStyle(
                                                        fontFamily:
                                                        'OpenSans',

                                                        fontSize: 16,
                                                        color: Color(ColorConsts
                                                            .grayColor)),


                                                  )
                                                ],


                                              )
                                            ]);
                                          }
                                      );
                                    }

                                    return Material(
                                        type: MaterialType.transparency,
                                        child:  (!projectSnap.hasError)?Container(
                                            height: 200,
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
                                            )):Container());

                                    })
                            ),
                            SliverToBoxAdapter(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 14, 0, 14),
                                height: 0.5,
                                color: Color(ColorConsts.grayColor),
                              ),
                            ),
                            SliverToBoxAdapter(
                                child: SizedBox(
                                    child: Container(
                                        margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                        child: Column(children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Customer Questions",
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans-Bold',
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(ColorConsts.textColor)),
                                              ),
                                              /*   Text(
                              "View all",
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 18,
                                  color: Color(ColorConsts.primaryColor)),
                            ),*/
                                            ],
                                          ),
                                          Stack(children: [
                                            Container(alignment: Alignment.center,

                                                margin: EdgeInsets.fromLTRB(0, 16, 95, 19),
                                                padding: EdgeInsets.fromLTRB(11, 0, 8, 0),
                                                decoration: new BoxDecoration(

                                                    border: Border.all(
                                                        color: Color(ColorConsts.grayColor), width: 0.5),
                                                    borderRadius: BorderRadius.circular(8.0)),
                                                child:TextField(
                                                    minLines: 1,
                                                    maxLines: 3,
                                                    controller: quesController,
                                                    decoration: InputDecoration(
                                                        hintText:
                                                        'Your Question Here.. ',
                                                        hintStyle: TextStyle(
                                                            fontFamily: 'OpenSans',
                                                            fontSize: 15,
                                                            color: Color(ColorConsts.lightGrayColor)),
                                                        border: InputBorder.none
                                                    ),style: TextStyle(
                                                    color: Color(ColorConsts.blackColor),
                                                    fontSize: 16.0,
                                                    fontFamily: 'OpenSans')
                                                )
                                            ),
                                            Align(alignment: Alignment.centerRight,
                                                child:InkResponse(
                                                  onTap: () {
                                                    if(quesController.text.isNotEmpty){
                                                      sendQuestion();}else{
                                                      Fluttertoast.showToast(
                                                          msg: 'Enter question to continue!',
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor: Colors.grey,
                                                          textColor: Color(ColorConsts.whiteColor),
                                                          fontSize: 14.0);

                                                    }
                                                  },child: Container(
                                                  width: 82,
                                                  height: 48,
                                                  padding: EdgeInsets.fromLTRB(6, 4, 8, 4),
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.fromLTRB(10, 16, 0, 0),
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(ColorConsts.primaryColor),
                                                          Color(ColorConsts.secondaryColor)
                                                        ],
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                      ),
                                                      borderRadius: BorderRadius.circular(6.0)),
                                                  child:

                                                  Text(
                                                    'Send',
                                                    style: TextStyle(
                                                        fontFamily: 'OpenSans-Bold',
                                                        fontSize: 19,
                                                        color: Color(ColorConsts.whiteColor)
                                                    ),

                                                  ),
                                                ),
                                                )
                                            )

                                          ],),
                                        ]))
                                )
                            )
                            ,if(hasData)SliverToBoxAdapter(
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: modelQuesRes.data.length,
                                  itemBuilder: (context, int idx) {
                                    return Container(


                                      alignment: Alignment.center,

                                      padding: EdgeInsets.all(9),
                                      decoration: new BoxDecoration(


                                          borderRadius: BorderRadius.circular(8.0)),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,children: [
                                        Text(
                                          ' Q: '+modelQuesRes.data[idx].question,
                                          style: TextStyle(
                                              fontFamily:
                                              'OpenSans-Bold',
                                              fontSize: 18,
                                              color: Color(ColorConsts
                                                  .blackColor)),


                                        ),Text(
                                          (modelQuesRes.data[idx].answer.isNotEmpty)?" A : "+modelQuesRes.data[idx].answer:' A: Not replied' ,
                                          style:TextStyle(
                                              fontFamily:
                                              'OpenSans',
                                              fontSize: 18,
                                              color: Color(ColorConsts
                                                  .blackColor)),


                                        ),Row(children: [
                                          Image.asset('assets/icons/user.png',height: 15,width: 20,),
                                          Text(
                                            " "+modelQuesRes.data[idx].question_uname,
                                            style: TextStyle(
                                                fontFamily:
                                                'OpenSans',
                                                fontSize: 16,
                                                color: Color(ColorConsts
                                                    .grayColor)),


                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                            width: 6,
                                            height: 6,
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
                                                      ColorConsts.grayColor)),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                              color: Color(ColorConsts.grayColor),
                                            ),
                                          ),
                                          Image.asset('assets/icons/Calender.png',height: 16,width: 25,),Text(
                                            modelQuesRes.data[idx].createdAt,
                                            style: TextStyle(
                                                fontFamily:
                                                'OpenSans',
                                                fontSize: 16,
                                                color: Color(ColorConsts
                                                    .grayColor)),


                                          )
                                        ],)
                                        ,Container(
                                          margin: EdgeInsets.fromLTRB(0, 12, 0, 12),
                                          height: 0.5,
                                          color: Color(ColorConsts.grayColor),
                                        )
                                      ],),


                                    );

                                  }
                              ) ,
                            ),
                            SliverToBoxAdapter(
                                child: SizedBox(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            Resource.of(context,tag!).strings.MostSoldItems + " ",
                                            style: TextStyle(
                                                fontFamily: 'OpenSans-Bold',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Color(ColorConsts.textColor)),
                                          ),
                                        ],
                                      ),
                                      margin: EdgeInsets.fromLTRB(10, 12, 8, 14),
                                    ))),
                            SliverToBoxAdapter(
                              child: SizedBox(
                                child: FutureBuilder<dynamic>(
                                    future: hasData
                                        ? SoldItemPresenter()
                                        .getMostSoldProductList(_userLoginModel.data.token,1000)
                                        : null,
                                    builder: (context, projectSnap) {
                                      if (projectSnap.hasData) {


                                        return Container(
                                            width: MediaQuery.of(context).size.width,
                                            margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                            alignment: Alignment.center,
                                            child: ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemCount: projectSnap.data!.data.length,
                                                itemBuilder: (context, int idx) {

                                                  final r = projectSnap.data!.data[idx];
                                                  if(projectSnap.data!.data[idx].isLiked.toString().contains("1")) {
                                                    _counter.like(projectSnap.data!.data[idx].variant_id);
                                                  }
                                                  return InkResponse(child: Row(
                                                    // align the text to the left instead of centered
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Stack(
                                                        children: [

                                                          Container(
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
                                                              image:( projectSnap.data!.data[idx].prod_image.length > 0)?DecorationImage(
                                                                image: NetworkImage(projectSnap.data!.data[idx].prod_image[0]),
                                                                fit: BoxFit.cover,
                                                                alignment:
                                                                Alignment.topCenter,
                                                              ):null,
                                                            ),
                                                            height: 128,
                                                            width: 125,
                                                            margin: (idx % 2 == 0)
                                                                ? EdgeInsets.fromLTRB(
                                                                0, 6, 11, 8)
                                                                : EdgeInsets.fromLTRB(
                                                                0, 6, 11, 8),

                                                          ),
                                                          Container(
                                                              height: 90,
                                                              width: 115,
                                                              margin: EdgeInsets.fromLTRB(
                                                                  1, 15, 8, 0),
                                                              alignment: Alignment.topRight,
                                                              child: InkResponse(onTap:() {

                                                                dpProLikeDisLike(""+projectSnap.data!.data[idx].variant_id);
                                                                if(_counter.likedIndex.contains(projectSnap.data!.data[idx].variant_id)){
                                                                  _counter.disliked(projectSnap.data!
                                                                      .data[idx].variant_id);
                                                                }else {
                                                                  _counter.like(projectSnap.data!
                                                                      .data[idx].variant_id);
                                                                }} ,child: Container(
                                                                alignment: Alignment.center,

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
                                                                child: Observer(
                                                                    builder: (_) => (!_counter.likedIndex.contains(""+projectSnap.data!.data[idx].variant_id))
                                                                        ? Image.asset('assets/icons/dislike.png', width: 14, height: 14,
                                                                    )
                                                                        : Image.asset('assets/icons/like.png', width: 14, height: 14,
                                                                    )
                                                                ),
                                                              )
                                                              )

                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets.fromLTRB(
                                                                1, 6, 0, 3),
                                                            child: Text(
                                                              projectSnap.data!.data[idx].pro_subtitle,
                                                              style: TextStyle(
                                                                  fontFamily: 'OpenSans-Bold',

                                                                  fontSize: 16.5,
                                                                  color: Color(ColorConsts
                                                                      .blackColor)),
                                                            ),
                                                            width: 190,
                                                          ),
                                                          Container(
                                                            width: 190,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                              children: [
                                                                if(projectSnap.data!.data[idx].rating_user_count > 0)Container(
                                                                  padding:
                                                                  EdgeInsets.fromLTRB(
                                                                      6, 4, 6, 4),
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
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
                                                                        " "+projectSnap.data!.data[idx].rating_average.toString(),
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
                                                                if(projectSnap.data!.data[idx].rating_user_count > 0)Container(
                                                                  padding:
                                                                  EdgeInsets.fromLTRB(
                                                                      6, 1, 6, 1),
                                                                  alignment: Alignment.center,
                                                                  margin: EdgeInsets.fromLTRB(
                                                                      0, 2, 0, 1),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        projectSnap.data!.data[idx].rating_user_count.toString(),
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                            'OpenSans-Bold',
                                                                            fontSize: 15,
                                                                            color: Color(
                                                                                ColorConsts
                                                                                    .lightGrayColor)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.fromLTRB(
                                                                0, 1, 0, 2.5),
                                                            width: 192,
                                                            alignment: Alignment.centerLeft,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  '$currSym '+projectSnap.data!.data[idx].prod_unitprice.toString()+" ",
                                                                  style: TextStyle(
                                                                      fontFamily: 'OpenSans',
                                                                      fontSize: 12.5,
                                                                      color:
                                                                      Color(ColorConsts
                                                                          .textColor)),
                                                                ),
                                                                if(double.parse((projectSnap.data!.data[idx].prod_discount).toString()) > 0)if(double.parse(projectSnap.data!.data[idx].prod_strikeout_price) >= 1.0)Text(
                                                                  projectSnap.data!.data[idx].prod_strikeout_price.toString(),
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
                                                                      fontSize: 12.5,
                                                                      color: Color(
                                                                          ColorConsts.grayColor)),
                                                                ),
                                                                if(double.parse((projectSnap.data!.data[idx].prod_discount).toString()) > 0)(projectSnap.data!.data[idx].prod_discount_type.contains("flat"))?
                                                                Flexible(child: Text(
                                                                  " "+projectSnap.data!.data[idx].prod_discount.toString()+' Flat Off',
                                                                  style: TextStyle(
                                                                      fontFamily: 'OpenSans',
                                                                      fontSize: 12.5,
                                                                      color: (projectSnap.data!.data[idx].prod_quantity ==0)
                                                                          ? Color(0x9AB446FF)
                                                                          : Color(ColorConsts
                                                                          .primaryColor)),
                                                                )
                                                                ):Flexible(child: Text(
                                                                  "  "+projectSnap.data!.data[idx].prod_discount.toString()+'% Off',
                                                                  style: TextStyle(
                                                                      fontFamily: 'OpenSans',
                                                                      fontSize: 12.5,
                                                                      color: (projectSnap.data!.data[idx].prod_quantity ==0)
                                                                          ? Color(0x9AB446FF)
                                                                          : Color(ColorConsts
                                                                          .primaryColor)),
                                                                ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.fromLTRB(
                                                                1, 2, 0, 0),
                                                            child: Text(
                                                              Resource.of(context,tag!)
                                                                  .strings
                                                                  .FreeDelivery,
                                                              style: TextStyle(
                                                                  fontFamily: 'OpenSans',
                                                                  fontSize: 12,
                                                                  color: Color(
                                                                      ColorConsts.grayColor)),
                                                            ),
                                                            width: 190,
                                                          ),
                                                          /*   Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  1, 2, 0, 0),
                                              child: Text(
                                                'Upto 999 Off on Exchange',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 13,
                                                    color: Color(ColorConsts
                                                        .blackColor)),
                                              ),
                                              width: 190,
                                            ),*/
                                                        ],
                                                      ),
                                                    ],
                                                  ), onTap: () {

                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                          builder: (context) {
                                                            return SingleItemScreen(''+projectSnap.data!.data[idx].prod_name,projectSnap.data!.data[idx].id,projectSnap.data!.data[idx].variant_id);
                                                          },)).then((value) {
                                                      debugPrint(value);

                                                    });
                                                  },
                                                  );


                                                })
                                        );
                                      }else{
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
                                                        child: (!projectSnap.hasError)?CircularProgressIndicator(
                                                            valueColor:
                                                            AlwaysStoppedAnimation(
                                                                Color(ColorConsts
                                                                    .primaryColor)),
                                                            backgroundColor: Color(
                                                                ColorConsts
                                                                    .primaryColorLyt),
                                                            strokeWidth: 4.0):null
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.all(6),
                                                        child: Text(
                                                          (!projectSnap.hasError)? Resource.of(context, "en")
                                                              .strings
                                                              .loadingPleaseWait:'Something went wrong..',
                                                          style: TextStyle(
                                                              color: Color(ColorConsts
                                                                  .primaryColor),
                                                              fontFamily: 'OpenSans-Bold',
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 18),
                                                        )),
                                                  ],
                                                ))) ;

                                      }
                                    }
                                ),
                              ),
                            ),
                          ],
                        ),
                        margin:EdgeInsets.fromLTRB(0, 68, 0, 50)

                    ),
                    if(hasData) Align(alignment: Alignment.bottomCenter,child:  Container(child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                      InkResponse(
    onTap: () async {
      if(selectedSize==""){
        // print("ok");
        Fluttertoast.showToast(
            msg: 'Please Select  Option',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Color(ColorConsts.whiteColor),
            fontSize: 14.0);
      }
    if (productSingle.data.prod_variants[va_index].prod_quantity == 0) {
    Fluttertoast.showToast(
    msg: 'Not Available!',
    toastLength: Toast.LENGTH_SHORT,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.grey,
    textColor: Color(ColorConsts.whiteColor),
    fontSize: 14.0,
    );
    } else {
    List<ListEntity> listCheck = await access.findAllList(
    productSingle.data.prod_variants[va_index].variant_id,
    );
    if (listCheck.isEmpty&&selectedSize!="") {
    await access.insertInList(ListEntity(
    productSingle.data.id,
    productSingle.data.prod_variants[va_index].variant_id,
    productSingle.data.prod_sellerid,
    productSingle.data.prod_variants[va_index].prod_unitprice,
    productSingle.data.prod_discount_type,
    "" + quan.toString(),
    productSingle.data.prod_variants[va_index].prod_quantity.toString(),
    productSingle.data.prod_variants[va_index].prod_image[0],
    productSingle.data.prod_name + " (" +
    productSingle.data.prod_variants[va_index].pro_subtitle + ")",
    productSingle.data.prod_discount.toString(),
    productSingle.data.prod_variants[va_index].prod_strikeout_price,
    productSingle.data.isLiked,
    ));

    // Store variant_id, selectedSize, and selectedPrice in SharedPreferences
    String vid = productSingle.data.prod_variants[va_index].variant_id;

    Map<String, dynamic> data = {
    'selectedSize': selectedSize,
    'selectedPrice': selectedPrice.toString(),  // Ensure the price is stored as a string
    };
SharedPref sharedPref=new SharedPref();
    await sharedPref.storeData(vid, jsonEncode(data));

    Fluttertoast.showToast(
    msg: 'Added Successfully',
    toastLength: Toast.LENGTH_SHORT,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.grey,
    textColor: Color(ColorConsts.whiteColor),
    fontSize: 14.0,
    );
    refreshDb();
    } else {
    Fluttertoast.showToast(
    msg: 'Already In Cart',
    toastLength: Toast.LENGTH_SHORT,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.grey,
    textColor: Color(ColorConsts.whiteColor),
    fontSize: 14.0,
    );
    }
    }
    },
    child: Container(
    width: MediaQuery.of(context).size.width / 2,
    height: 50,
    alignment: Alignment.center,
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [
    Color(ColorConsts.whiteColor),
    Color(ColorConsts.whiteColor),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    ),
    ),
    child: Text(
    'Add to Cart',
    style: TextStyle(
    fontFamily: 'OpenSans-Bold',
    fontSize: 16,
    color: Color(ColorConsts.blackColor),
    ),
    ),
    ),
    ),



    InkResponse(onTap: () async {
                        if( productSingle.data.prod_variants[va_index].prod_quantity==0){

                          Fluttertoast.showToast(
                              msg: 'Not Available!',
                              toastLength: Toast.LENGTH_SHORT,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Color(ColorConsts.whiteColor),
                              fontSize: 14.0);
                        }
                        else {
                          List<ListEntity> listCheck = await access.findAllList(
                            productSingle.data.prod_variants[va_index].variant_id,
                          );
                          if (listCheck.isEmpty) {
                            await access.insertInList(ListEntity(
                              productSingle.data.id,
                              productSingle.data.prod_variants[va_index].variant_id,
                              productSingle.data.prod_sellerid,
                              productSingle.data.prod_variants[va_index].prod_unitprice,
                              productSingle.data.prod_discount_type,
                              "" + quan.toString(),
                              productSingle.data.prod_variants[va_index].prod_quantity.toString(),
                              productSingle.data.prod_variants[va_index].prod_image[0],
                              productSingle.data.prod_name + " (" +
                                  productSingle.data.prod_variants[va_index].pro_subtitle + ")",
                              productSingle.data.prod_discount.toString(),
                              productSingle.data.prod_variants[va_index].prod_strikeout_price,
                              productSingle.data.isLiked,
                            ));

                            // Store variant_id, selectedSize, and selectedPrice in SharedPreferences
                            String vid = productSingle.data.prod_variants[va_index].variant_id;

                            Map<String, dynamic> data = {
                              'selectedSize': selectedSize,
                              'selectedPrice': selectedPrice.toString(),  // Ensure the price is stored as a string
                            };
                            SharedPref sharedPref=new SharedPref();
                            await sharedPref.storeData(vid, jsonEncode(data));
                            refreshDb();
                          }
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            return MyCart();
                          },)).then((value) => refreshDb());
                        }

                      },child: Container(

                        height: 50,
                        width: MediaQuery.of(context).size.width/2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(ColorConsts.primaryColor),
                              Color(ColorConsts.secondaryColor)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child:

                        Text(
                          'Buy Now',
                          style: TextStyle(
                              fontFamily: 'OpenSans-Bold',
                              fontSize: 16,
                              color: Color(ColorConsts.whiteColor)),

                        ),
                      )
                      )
                  ],
                ),
              )
                    ),
                  ],
                ),
              )
            /*   Material(
            type: MaterialType.transparency,
            child: Container(
                height: MediaQuery.of(context).size.height,
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
                )))*/
          ),
        )
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
