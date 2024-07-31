import 'dart:convert';
import 'package:e_com/localdb/AppDatabase.dart';
import 'package:e_com/localdb/ListEntity.dart';
import 'package:e_com/model/ModelSettings.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/presenter/CateSubProductPresenter.dart';
import 'package:e_com/presenter/SearchPresenter.dart';
import 'package:e_com/presenter/SoldItemPresenter.dart';
import 'package:e_com/ui/SingleItemScreen.dart';
import 'package:e_com/utils/mobxStateManagement.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_com/utils/Resource.dart';
import '../utils/SharedPref.dart';
import 'MyCart.dart';
import 'Notifications.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

String nameItem = '';
String cateId = '';
String subcat = '';

class AllProducts extends StatefulWidget {
  int? shouldChange;

  AllProducts(String s, catId, subCatId) {
    nameItem = s;
    cateId = catId;
    subcat = subCatId;
  }

  @override
  State<StatefulWidget> createState() => new _State();
}







class _State extends State<AllProducts> {
  String currSym = '\$';
  var isChecked = true;
  String sortBy = '';
  int selectedIndex = 0;
  late UserLoginModel _userLoginModel;
  late final access;
  late final database;
  String cartLength="0";
  late ModelSettings  modelSettings ;
  final controller = PageController(
      viewportFraction: 0.86, keepPage: false, initialPage: 1);
  SharedPref sharePrefs = SharedPref();
  String? tag = '';
  bool hasData = false;
  final _counter = Counter();

  Future<void> getValue() async {
    tag = await sharePrefs.getLanguage();
    _userLoginModel = await sharePrefs.getLoginUserData();
    String? sett = await sharePrefs.getSettings() ;
    final Map<String, dynamic> parsed = json.decode(sett!);
      modelSettings = ModelSettings.fromJson(parsed);
    currSym=modelSettings.data.currency_symbol.toString();

    initDb();
  }

  Future<void> _reload() async {
    List<ListEntity> listdata = await access.getAll();
    cartLength=listdata.length.toString();
    setState(() {

    });
  }

  dpProLikeDisLike(String product_id) {
    CatePresenter().doLikeProduct(
        _userLoginModel.data.token, _userLoginModel.data.id, product_id);
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


  @override
  void initState() {
    getValue();

    super.initState();
  }


  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
          child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Stack(
                children: [
                  Container(
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
                              margin: EdgeInsets.fromLTRB(39, 0, 88, 0),
                              child: Text(nameItem + "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color(ColorConsts.whiteColor))),
                            ),
                          ),
                          Container(width: 55, child: InkResponse(
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
                              width: 50
                            ),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                width: 50,
                                margin: EdgeInsets.fromLTRB(0, 6, 49, 6),
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                          return Notifications();
                                        },));
                                  }, child: Stack(
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
                                    if(hasData)if(modelSettings.data.notifications_count > 0)Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 0, 1, 16),
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
                                , child: InkResponse(onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      return MyCart();
                                    },));
                              }, child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(
                                          0, 6, 12.5, 6),
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
                                        margin: EdgeInsets.fromLTRB(
                                            0, 0, 10, 16),
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
                                          color: Color(
                                              ColorConsts.secondaryColor),
                                        ),
                                        child: Text(
                                          cartLength.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Color(
                                                  ColorConsts.whiteColor)),
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
              margin: EdgeInsets.fromLTRB(10, 6, 10, 0),
              alignment: Alignment.center,
              child: FutureBuilder<dynamic>(
                  future: hasData
                      ? (nameItem.contains("People Also Viewed"))?CatePresenter().getSubCatProductList(_userLoginModel.data.token, '', '', 'most_viewed',100,'')
                      :(nameItem.contains("Popular Products"))?SoldItemPresenter()
                      .getMostSoldProductList(_userLoginModel.data.token,1000,):
                  (nameItem.contains("Recommended Items"))?CatePresenter().getRecomm(
                      _userLoginModel.data.token,100):(nameItem.contains("Trending Now"))?CatePresenter().getTrendingProducts(
                      _userLoginModel.data.token,100):
                  SearchPresenter().getSearchContent(_userLoginModel.data.token,100,nameItem):null,
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
                            mainAxisExtent: 264,),
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
                                                return SingleItemScreen(''+projectSnap.data!.data[idx].prod_name,projectSnap.data!.data[idx].id,projectSnap.data!.data[idx].id);
                                              },)).then((value) {
                                          debugPrint(value);
                                          _reload();
                                        });
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
                                        margin: (idx%2==0)?EdgeInsets.fromLTRB(10, 16, 16, 0):EdgeInsets.fromLTRB(10, 16, 10, 0),
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
                                    (projectSnap.data!.data[idx].pro_subtitle.toString().isNotEmpty)?projectSnap.data!.data[idx].pro_subtitle:projectSnap.data!.data[idx].prod_name,
                                    maxLines: 1,
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
                                  width: 160,
                                ),
                                Container(
                                  margin:
                                  EdgeInsets.fromLTRB(2, 0, 0, 2.5),
                                  child: Row(
                                    children: [
                                      Text(
                                        '$currSym'+projectSnap.data!.data[idx].prod_unitprice.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '')+" ",
                                        style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontSize: 13,
                                            color: (idx == 5)
                                                ? Color(ColorConsts
                                                .grayColor)
                                                : Color(ColorConsts
                                                .textColor)),
                                      ),
                                      if(double.parse((projectSnap.data!.data[idx].prod_discount).toString()) > 0)if(double.parse(projectSnap.data!.data[idx].prod_strikeout_price) >= 1.0)Text(
                                       projectSnap.data!.data[idx].prod_strikeout_price.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), ''),
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
                                      if(double.parse((projectSnap.data!.data[idx].prod_discount).toString()) > 0)(projectSnap.data!.data[idx].prod_discount_type.contains("flat"))?Text(
                                        " "+projectSnap.data!.data[idx].prod_discount.toString()+'Flat Off',
                                        style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontSize: 12,
                                            color: (projectSnap.data!.data[idx].prod_quantity ==0)
                                                ? Color(0x9AB446FF)
                                                : Color(ColorConsts
                                                .primaryColor)),
                                      ):Text(
                                        "  "+projectSnap.data!.data[idx].prod_discount.toString()+'% Off',
                                        style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontSize: 12,
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
                                    if(projectSnap.data!.data[idx].rating_user_count >0)Container(
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
                                    if(projectSnap.data!.data[idx].rating_user_count >0)Container(
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
                              height: MediaQuery.of(context).size.height-85,
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

