import 'dart:convert';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import 'package:e_com/localdb/AppDatabase.dart';
import 'package:e_com/localdb/ListEntity.dart';
import 'package:e_com/model/ModelBrand.dart';
import 'package:e_com/model/ModelMostSoldProduct.dart';
import 'package:e_com/model/ModelProBanners.dart';
import 'package:e_com/model/ModelProduct.dart';
import 'package:e_com/model/ModelSettings.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/presenter/BrandPresenter.dart';
import 'package:e_com/presenter/CateSubProductPresenter.dart';
import 'package:e_com/presenter/PromotionalBannersPresenter.dart';
import 'package:e_com/presenter/SoldItemPresenter.dart';
import 'package:e_com/ui/SingleItemScreen.dart';
import 'package:e_com/utils/mobxStateManagement.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:e_com/model/ModelHomePage.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_com/utils/Resource.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../utils/SharedPref.dart';
import 'MyCart.dart';
import 'Notifications.dart';
import 'Search.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

String nameItem = '';
String cateId = '';
String subcat = '',brand_id="";

class InsideSubCategory extends StatefulWidget {
  int? shouldChange;

  InsideSubCategory(String s, catId, subCatId, String brandId) {
    nameItem = s;
    cateId = catId;
    subcat = subCatId;
    brand_id = brandId;
  }

  @override
  State<StatefulWidget> createState() => new _State();
}

class LanguageDetails {
  const LanguageDetails({required this.title, required this.i});

  final String title;
  final String i;
}

List<LanguageDetails> listCate = [
  LanguageDetails(
      title: 'Men Clothing & Fashion', i: 'assets/images/boycat.png'),
  LanguageDetails(title: 'Kids & Toys', i: 'assets/images/kitchenCat.png'),
  LanguageDetails(
      title: 'Women Clothing & Fashion', i: 'assets/images/beauticat.png'),
  LanguageDetails(title: 'Mobiles & Tabs', i: 'assets/images/girlscat.png'),
  LanguageDetails(title: 'Computer & Accessories', i: 'assets/images/kids.png'),
  LanguageDetails(title: 'Sports & Outdoor', i: 'assets/images/toys.png'),
  LanguageDetails(title: 'Home Improvement', i: 'assets/images/boycat.png'),
  LanguageDetails(title: 'Beauty & Hair', i: 'assets/images/boycat.png'),
  LanguageDetails(title: 'Grocery', i: 'assets/images/mobilecat.png'),
  LanguageDetails(title: 'Jewelry & Watches', i: 'assets/images/mobilecat.png'),
  LanguageDetails(title: 'Cars', i: 'assets/images/mobilecat.png'),
  LanguageDetails(title: 'Accessories', i: 'assets/images/boycat.png'),
  LanguageDetails(title: 'Mobiles', i: 'assets/images/boycat.png'),
];

class brandDetails {
  const brandDetails({required this.title, required this.i, required this.lst});

  final String title;
  final String i;
  final List lst;
}

List<brandDetails> listbrand = [
  brandDetails(title: 'Price', i: '0', lst: [
    'All',
    'Under \$500',
    '\$500 to \$1000',
    '\$1000 to \$2000',
    '\$2000 to \$3000',
    '\$3000 to \$4000',
    '\$4000 to \$5000'
  ]),
  brandDetails(title: 'Brands', i: '0', lst: [
    'lavie',
    'lino parros',
    'caprese',
    'mochi',
    'Pantaloons',
    'Buterflies',
    'Guchi',
    'H&M',
  ]),
  brandDetails(title: 'Gender', i: '0', lst: [
    'All',
    'Woman',
    'Man',
    'Girl',
    'Boy',
  ]),
  brandDetails(title: 'Size', i: '0', lst: [
    'Medium',
    'Small',
    'Large',
    'XL',
  ]),
  brandDetails(title: 'Pattern', i: '0', lst: []),
  brandDetails(title: 'Offer', i: '0', lst: []),
  brandDetails(title: 'Discount', i: '0', lst: []),
  brandDetails(title: 'Color', i: '0', lst: [
    'RED',
    'PINK',
    'BLUE',
    'WHITE',
    'BLACK',
    'GRAY',
    'Yellow',
  ]),
  brandDetails(title: 'Ocassion', i: '0', lst: []),
  brandDetails(title: 'Delivery at', i: '0', lst: []),
  brandDetails(title: 'Category', i: '0', lst: []),
  brandDetails(title: 'Customer', i: '0', lst: []),
  brandDetails(title: 'Fit', i: '0', lst: []),
];

class _State extends State<InsideSubCategory> {
  String currSym = '\$';
  var isChecked = true;
  String sortBy = '';
  int selectedIndex = 0;
  late UserLoginModel _userLoginModel;
  late final access;
  late final database;
  String cartLength = "0";
  late Future<ModelProduct> mainItems;
  late Future<ModelBrand> brandsList;
  late Future<ModelProBanners> bannerItems;
  late ModelSettings modelSettings;

  final controller =
      PageController(viewportFraction: 0.86, keepPage: false, initialPage: 1);
  SharedPref sharePrefs = SharedPref();
  String? tag = '';
  bool hasData = false;
  final _counter = Counter();

  Future<void> getValue() async {
    tag = await sharePrefs.getLanguage();
    _userLoginModel = await sharePrefs.getLoginUserData();
    String? sett = await sharePrefs.getSettings();
    final Map<String, dynamic> parsed = json.decode(sett!);
    modelSettings = ModelSettings.fromJson(parsed);
    currSym = modelSettings.data.currency_symbol.toString();
    getDataFuture();
    hasData = true;

    initDb();
  }

  getDataFuture() {

    mainItems = CatePresenter()
        .getSubCatProductList(_userLoginModel.data.token, cateId, subcat,'',100,brand_id);


    brandsList = BrandPresenter().getList(_userLoginModel.data.token);
    bannerItems =
        PromotionalBannersPresenter().getList(_userLoginModel.data.token);

  }

  Future<void> _reload() async {

    List<ListEntity> listdata = await access.getAll();
    cartLength = listdata.length.toString();
    setState(() {});
  }

  dpProLikeDisLike(String product_id) {
    CatePresenter().doLikeProduct(
        _userLoginModel.data.token, _userLoginModel.data.id, product_id);
  }

  Future<void> initDb() async {
    database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    access = database.daoaccess;
    List<ListEntity> listdata = await access.getAll();
    cartLength = listdata.length.toString();

    setState(() {});
  }

  @override
  void initState() {
    getValue();

    super.initState();
  }

  void slideSheet(String s) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return s.contains('sort')
                ? Container(
                    color: Color(0xFF737373),
                    child: Container(
                      height: 280,
                      padding: EdgeInsets.fromLTRB(0, 9, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: [
                              Align(
                                child: Container(
                                  margin: EdgeInsets.all(14),
                                  child: Text(
                                    'Sort By',
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Bold',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Color(ColorConsts.textColor)),
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              Align(
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(14),
                                    child: Icon(
                                      Icons.clear,
                                      color: Color(ColorConsts.grayColor),
                                      size: 24,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.centerRight,
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 9, 0, 9),
                            width: MediaQuery.of(context).size.width,
                            height: 0.8,
                            color: Color(ColorConsts.grayColor),
                          ),
                          Stack(children: <Widget>[
                            Align(
                                child: Container(
                              margin: EdgeInsets.fromLTRB(12, 9, 0, 9),
                              child: Text(
                                'Poplularity',
                                style: TextStyle(
                                    fontFamily: 'OpenSans-Bold',
                                    fontSize: 20,
                                    color: Color(ColorConsts.textColor)),
                              ),
                              alignment: Alignment.centerLeft,
                            )),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkResponse(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(2, 9, 12, 9),
                                  child: (sortBy.contains('Poplularity'))
                                      ? Image.asset(
                                          'assets/icons/radioFill.png',
                                          width: 23)
                                      : Image.asset('assets/icons/radio.png',
                                          width: 23),
                                ),
                                onTap: () {
                                  setState(() {
                                    sortBy = 'Poplularity';
                                  });
                                },
                              ),
                            )
                          ]),
                          Stack(
                            children: <Widget>[
                              Align(
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(12, 9, 0, 9),
                                    child: Text(
                                      'New Arrivals',
                                      style: TextStyle(
                                          fontFamily: 'OpenSans-Bold',
                                          fontSize: 20,
                                          color: Color(ColorConsts.textColor)),
                                    )),
                                alignment: Alignment.centerLeft,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkResponse(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(2, 9, 12, 9),
                                    child: (sortBy.contains('New Arrivals'))
                                        ? Image.asset(
                                            'assets/icons/radioFill.png',
                                            width: 23)
                                        : Image.asset('assets/icons/radio.png',
                                            width: 23),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      sortBy = 'New Arrivals';
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                          Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(12, 9, 0, 9),
                                    child: Text(
                                      'Price - Low to High',
                                      style: TextStyle(
                                          fontFamily: 'OpenSans-Bold',
                                          fontSize: 20,
                                          color: Color(ColorConsts.textColor)),
                                    )),
                              ),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: InkResponse(
                                    child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(2, 9, 12, 9),
                                        child: (sortBy.contains('Low to High'))
                                            ? Image.asset(
                                                'assets/icons/radioFill.png',
                                                width: 23)
                                            : Image.asset(
                                                'assets/icons/radio.png',
                                                width: 23)),
                                    onTap: () {
                                      setState(() {
                                        sortBy = 'Low to High';
                                      });
                                    },
                                  ))
                            ],
                          ),
                          Stack(
                            children: <Widget>[
                              Align(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(12, 9, 0, 9),
                                  child: Text(
                                    'Price - High to Low',
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Bold',
                                        fontSize: 20,
                                        color: Color(ColorConsts.textColor)),
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkResponse(
                                  child: Container(
                                      margin: EdgeInsets.fromLTRB(2, 9, 12, 9),
                                      child: (sortBy.contains('High to Low'))
                                          ? Image.asset(
                                              'assets/icons/radioFill.png',
                                              width: 23)
                                          : Image.asset(
                                              'assets/icons/radio.png',
                                              width: 23)),
                                  onTap: () {
                                    setState(() {
                                      sortBy = 'High to Low';
                                    });
                                  },
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                : s.contains('cate')
                    ? Container(
                        color: Color(0xFF737373),
                        child: Container(
                            height: 500,
                            padding: EdgeInsets.fromLTRB(0, 9, 0, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              color: Colors.white,
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  children: <Widget>[
                                    Stack(
                                      children: [
                                        Align(
                                          child: Container(
                                            margin: EdgeInsets.all(14),
                                            child: Text(
                                              'Category',
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans-Bold',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(
                                                      ColorConsts.textColor)),
                                            ),
                                          ),
                                          alignment: Alignment.centerLeft,
                                        ),
                                        Align(
                                          child: InkResponse(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(14),
                                              child: Icon(
                                                Icons.clear,
                                                color: Color(
                                                    ColorConsts.grayColor),
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 9, 0, 9),
                                      width: MediaQuery.of(context).size.width,
                                      height: 0.8,
                                      color: Color(ColorConsts.grayColor),
                                    ),
                                    Container(
                                        child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: listCate.length,
                                            itemBuilder: (context, int idx) {
                                              return Stack(children: <Widget>[
                                                Align(
                                                    child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      45, 8, 0, 9),
                                                  child: Text(
                                                    listCate[idx].title,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'OpenSans-Bold',
                                                        fontSize: 20,
                                                        color: Color(ColorConsts
                                                            .textColor)),
                                                  ),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                )),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        12, 9, 12, 9),
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Color(
                                                                ColorConsts
                                                                    .whiteColor)),
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 12, 9),
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Color(
                                                                      ColorConsts
                                                                          .whiteColor)),
                                                              child:
                                                                  Image.asset(
                                                                (idx == 0)
                                                                    ? 'assets/icons/unselected.png'
                                                                    : 'assets/icons/selectedIcon.png',
                                                                width: 20,
                                                                height: 20,
                                                              )),
                                                        )),
                                                  ),
                                                ),
                                                Align(
                                                    child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      12, 10, 10, 8),
                                                  child: Text(
                                                    '(1299)',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'OpenSans-Bold',
                                                        fontSize: 18,
                                                        color: Color(ColorConsts
                                                            .grayColor)),
                                                  ),
                                                  alignment:
                                                      Alignment.centerRight,
                                                )),
                                              ]);
                                            }),
                                        height: 358),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Material(
                                    elevation: 1,
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Color(ColorConsts.whiteColor),
                                        margin: EdgeInsets.fromLTRB(0, 6, 0, 0),
                                        height: 59,
                                        child: Stack(
                                          children: [
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: RichText(
                                                  text: new TextSpan(
                                                    // Note: Styles for TextSpans must be explicitly defined.
                                                    // Child text spans will inherit styles from parent
                                                    style: new TextStyle(
                                                      fontSize: 17.0,
                                                      color: Colors.grey,
                                                    ),
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                        text: '  8795+ ',
                                                        style: new TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Color(
                                                                ColorConsts
                                                                    .blackColor)),
                                                      ),
                                                      new TextSpan(
                                                          text: 'Product Found',
                                                          style: new TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ],
                                                  ),
                                                )),
                                            Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: InkResponse(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    width: 120,
                                                    height: 38,
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.fromLTRB(
                                                        4, 2, 12, 2),
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
                                                    child: Text(
                                                      'Apply Now',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans-Bold',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                          color: Color(
                                                              ColorConsts
                                                                  .whiteColor)),
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        )),
                                  ),
                                )
                              ],
                            )),
                      )
                    : Container(
                        color: Color(0xFF737373),
                        child: Container(
                            height: 600,
                            padding: EdgeInsets.fromLTRB(0, 9, 0, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              color: Colors.white,
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  children: <Widget>[
                                    Stack(
                                      children: [
                                        Align(
                                          child: Container(
                                            margin: EdgeInsets.all(14),
                                            child: Text(
                                              'Filters',
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans-Bold',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(
                                                      ColorConsts.textColor)),
                                            ),
                                          ),
                                          alignment: Alignment.centerLeft,
                                        ),
                                        Align(
                                          child: InkResponse(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(14),
                                              child: Icon(
                                                Icons.clear,
                                                color: Color(
                                                    ColorConsts.grayColor),
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 9, 0, 0),
                                      width: MediaQuery.of(context).size.width,
                                      height: 0.8,
                                      color: Color(ColorConsts.grayColor),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          width: 105,
                                          child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              itemCount: listbrand.length,
                                              itemBuilder: (context, int idx) {
                                                return Container(
                                                    color:
                                                        (idx != selectedIndex)
                                                            ? Color(ColorConsts
                                                                .pinkLytColor)
                                                            : null,
                                                    child: InkResponse(
                                                      child: Stack(children: <
                                                          Widget>[
                                                        Align(
                                                            child: Container(
                                                          height: 29,
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  15, 6, 0, 9),
                                                          child: Text(
                                                            listbrand[idx]
                                                                .title,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'OpenSans-Bold',
                                                                fontSize: 18,
                                                                color: (idx !=
                                                                        selectedIndex)
                                                                    ? Color(ColorConsts
                                                                        .blackColor)
                                                                    : Color(ColorConsts
                                                                        .primaryColor)),
                                                          ),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                        )),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(0, 5,
                                                                    12, 9),
                                                            child: (idx ==
                                                                    selectedIndex)
                                                                ? Image.asset(
                                                                    'assets/images/dropVerti.png',
                                                                    height: 29,
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                  )
                                                                : Container(),
                                                          ),
                                                        ),
                                                      ]),
                                                      onTap: () {
                                                        setState(() {
                                                          selectedIndex = idx;
                                                        });
                                                      },
                                                    ));
                                              }),
                                          height: 464.5,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 30,
                                              margin: EdgeInsets.fromLTRB(
                                                  12, 12, 0, 1),
                                              child: Text(
                                                '' +
                                                    listbrand[selectedIndex]
                                                        .title,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans-Bold',
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(ColorConsts
                                                        .blackColor)),
                                              ),
                                            ),
                                            Container(
                                              width: 255,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount:
                                                      listbrand[selectedIndex]
                                                          .lst
                                                          .length,
                                                  itemBuilder:
                                                      (context, int idx) {
                                                    return Stack(children: <
                                                        Widget>[
                                                      Align(
                                                          child: Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                45, 9, 0, 9),
                                                        child: Text(
                                                          listbrand[
                                                                  selectedIndex]
                                                              .lst[idx],
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'OpenSans',
                                                              fontSize: 18,
                                                              color: Color(
                                                                  ColorConsts
                                                                      .grayColor)),
                                                        ),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                      )),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  12, 9, 12, 9),
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Color(
                                                                      ColorConsts
                                                                          .whiteColor)),
                                                              child:
                                                                  Image.asset(
                                                                (idx == 0)
                                                                    ? 'assets/icons/unselected.png'
                                                                    : 'assets/icons/selectedIcon.png',
                                                                width: 20,
                                                                height: 20,
                                                              )),
                                                        ),
                                                      ),
                                                    ]);
                                                  }),
                                              height: 470,
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Material(
                                    elevation: 4,
                                    child: Container(
                                        margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Color(ColorConsts.whiteColor),
                                        height: 59,
                                        child: Stack(
                                          children: [
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: RichText(
                                                  text: new TextSpan(
                                                    // Note: Styles for TextSpans must be explicitly defined.
                                                    // Child text spans will inherit styles from parent
                                                    style: new TextStyle(
                                                      fontSize: 17.0,
                                                      color: Colors.grey,
                                                    ),
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                        text: '  8795+ ',
                                                        style: new TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Color(
                                                                ColorConsts
                                                                    .blackColor)),
                                                      ),
                                                      new TextSpan(
                                                          text: 'Product Found',
                                                          style: new TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ],
                                                  ),
                                                )),
                                            Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: InkResponse(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    width: 120,
                                                    height: 38,
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.fromLTRB(
                                                        4, 2, 12, 2),
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
                                                    child: Text(
                                                      'Apply Now',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans-Bold',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                          color: Color(
                                                              ColorConsts
                                                                  .whiteColor)),
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        )),
                                  ),
                                )
                              ],
                            )),
                      );
          });
        });
  }

  List<ModelHomePage> set() {
    List<ModelHomePage> list = [
      ModelHomePage("Top hits", [
        Data('T-shirt', 'assets/images/tshirt.png'),
        Data('shirt', 'assets/images/wristWatch.png'),
        Data('shoe', 'assets/images/shoeReview.png'),
        Data('shoes', 'assets/images/shoe.png'),
        Data('Girl', 'assets/images/girlscat.png'),
        Data('Kids', 'assets/images/kids.png'),
        Data('Mens Wear', 'assets/images/boycat.png'),
        Data('kitchen', 'assets/images/kitchenCat.png'),
        Data('Beautiful', 'assets/images/beauticat.png'),
      ]),
      ModelHomePage("sale", [
        Data('Boy/man', 'assets/images/sale2.png'),
        Data('Boy/man', 'assets/images/sale1.png'),
        Data('Boy/man', 'assets/images/sale3.png'),
        Data('Boy/man', 'assets/images/sale1.png'),
      ]),
      ModelHomePage("Trending Now", [
        Data('Black T Shirt', 'assets/images/tsht.png'),
        Data('Black T Shirt', 'assets/images/tsht.png'),
        Data('Black T Shirt', 'assets/images/tsht.png'),
        Data('Black T Shirt.', 'assets/images/tsht.png'),
        Data('Black T Shirt', 'assets/images/tsht.png'),
        Data('Black T Shirt', 'assets/images/tsht.png')
      ]),
      ModelHomePage("People Also Viewed", [
        Data('Up to 30% OFF', 'assets/images/brand1.png'),
        Data('Up to 100% OFF', 'assets/images/beautibox.png'),
        Data('Up to 30% OFF', 'assets/images/brand2.png'),
        Data('Up to 30% OFF', 'assets/images/brand1.png'),
        Data('Up to 30% OFF', 'assets/images/brand1.png'),
        Data('Up to 50% OFF', 'assets/images/beautibox.png'),
        Data('Up to 30% OFF', 'assets/images/brand2.png'),
        Data('Up to 30% OFF', 'assets/images/brand1.png'),
        Data('Up to 30% OFF', 'assets/images/beautibox.png'),
      ]),
      ModelHomePage("Trending Now", [
        Data('Kindle Paperwhite 911thgen)- with Built-..',
            'assets/images/kindlepad.png'),
        Data('Handbag Tote Bag', 'assets/images/bag.png'),
        Data('Kitchen Aid Mixer..', 'assets/images/mixture.png'),
        Data('DayZ Cargo Pants..', 'assets/images/pant.png'),
        Data('Kids', 'assets/images/kids.png'),
        Data('Kids', 'assets/images/kids.png')
      ]),
    ];

    return list;
  }

  bool _switchValue = true;

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
                          margin: EdgeInsets.fromLTRB(38, 0, 95, 0),
                          child: Text(nameItem + "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(ColorConsts.whiteColor))),
                        ),
                      ),
                      Container(
                        width: 55,
                        child: InkResponse(
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
                          width: 50,
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: InkResponse(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return Search();
                                    },
                                  ));
                                },
                                child: Container(
                                  child: Image.asset(
                                    'assets/icons/SearchIcon.png',
                                    width: 21,
                                    height: 20,
                                    color: Color(ColorConsts.whiteColor),
                                  ),
                                ),
                              )),
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 50,
                            margin: EdgeInsets.fromLTRB(0, 6, 49, 6),
                            child: InkResponse(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return Notifications();
                                  },
                                ));
                              },
                              child: Stack(
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
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 1, 16),
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
                          )),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 50,
                            margin: EdgeInsets.fromLTRB(0, 6, 2, 6),
                            child: InkResponse(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return MyCart();
                                  },
                                ));
                              },
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 6, 12.5, 6),
                                      child: Image.asset(
                                        'assets/icons/cart.png',
                                        width: 21,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                  if (int.parse(cartLength) >= 1)
                                    Align(
                                        alignment: Alignment.centerRight,
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
                            ),
                          ))
                    ],
                  )),
              Container(
                margin: EdgeInsets.fromLTRB(0, 70, 0, 0),
                child: CustomScrollView(
                  slivers: [
                    /*  SliverToBoxAdapter(
                    child: SizedBox(
                    child: Stack(
                    children: [
                    Container(
                    margin: EdgeInsets.fromLTRB(12, 0, 8, 0),
                    height: 35,
                    child: Text(
                      Resource
                          .of(context, tag!)
                          .strings
                          .NotificationFromThisCollection,
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 15.5,
                          fontWeight: FontWeight.w500,
                          color: Color(ColorConsts.grayColor)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        height: 23,
                        width: 39,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/icons/NotificationButton.png'),
                            fit: BoxFit.fill,
                            alignment:
                            Alignment.topCenter,
                          ),
                        ),
                        margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Transform.scale(
                          transformHitTests: false,
                          scale: .55,
                          child: CupertinoSwitch(

                            value: _switchValue,
                            thumbColor: _switchValue ? Color(
                                ColorConsts.primaryColor) : Color(
                                ColorConsts.barColor),
                            activeColor: Color(0xcdcaca),
                            trackColor: Color(0xcdcaca),
                            onChanged: (value) {
                              setState(() {
                                _switchValue = value;
                              });
                            },
                          ),
                        )
                    ),
                  ),
                ],
              )
                    )
                    ),*/
                    /*SliverToBoxAdapter(
                        child: SizedBox(
                            child: Container(
                                height: 43,
                                margin: EdgeInsets.fromLTRB(12, 0, 8, 8),
                                padding: EdgeInsets.fromLTRB(3, 0, 6, 0),
                                decoration: new BoxDecoration(
                                    border: Border.all(
                                        color:
                                            Color(ColorConsts.lightGrayColor),
                                        width: 0.6),
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkResponse(
                                      onTap: () {
                                        slideSheet('sort');
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Image.asset(
                                            'assets/icons/sort.png',
                                            width: 16,
                                            height: 16,
                                            color: Color(ColorConsts.textColor),
                                          ),
                                          Text(
                                            ' ' +
                                                Resource.of(context, tag!)
                                                    .strings
                                                    .Sort,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans-Bold',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color(
                                                    ColorConsts.textColor)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 43,
                                      width: 1,
                                      color: Color(ColorConsts.lightGrayColor),
                                    ),
                                    InkResponse(
                                      onTap: () {
                                        slideSheet('cate');
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            Resource.of(context, tag!)
                                                    .strings
                                                    .Category +
                                                ' ',
                                            style: TextStyle(
                                                fontFamily: 'OpenSans-Bold',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color(
                                                    ColorConsts.textColor)),
                                          ),
                                          Image.asset(
                                            'assets/icons/Downarrow.png',
                                            width: 13,
                                            height: 14,
                                            color: Color(ColorConsts.textColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 43,
                                      width: 1,
                                      color: Color(ColorConsts.lightGrayColor),
                                    ),
                                    InkResponse(
                                        onTap: () {
                                          slideSheet('filter');
                                        },
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/icons/filter.png',
                                              width: 16,
                                              height: 16,
                                              color:
                                                  Color(ColorConsts.textColor),
                                            ),
                                            Text(
                                              ' ' +
                                                  Resource.of(context, tag!)
                                                      .strings
                                                      .Filters,
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans-Bold',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(
                                                      ColorConsts.textColor)),
                                            ),
                                          ],
                                        ))
                                  ],
                                )))),*/
                    SliverToBoxAdapter(
                        child: SizedBox(
                      child: FutureBuilder(
                        future: hasData
                            ? Future.wait(
                                [mainItems, brandsList, bannerItems])
                            : null,
                        builder:
                            (context, AsyncSnapshot<List<dynamic>> snapshot) {

                          if (snapshot.hasData) {

                            ModelProduct data = snapshot.data![0]; //bar
                            ModelBrand bData = snapshot.data![1]; //foo
                            ModelProBanners pbData = snapshot.data![2]; //foo
                 //foo

                            return Container(
                                margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                child: Column(
                                  children: [
                                    (data.data.length==0)?  Column(children: [

                                      Container(
                                          margin: EdgeInsets.fromLTRB(0, 32, 0, 14),
                                          child: Image.asset(
                                            'assets/images/noDataFound.png',
                                            height: 160,
                                          )),
                            Container(
                                      margin: EdgeInsets.fromLTRB(0, 12, 0, 55),
                                      child: Text(
                                        'No Products found under ' +
                                            nameItem +
                                            "!",
                                        style: TextStyle(
                                            fontFamily: 'OpenSans-Bold',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Color(ColorConsts.textColor)),
                                      ),
                                    )]):GridView.builder(
                                        scrollDirection: Axis.vertical,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: data.data.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisExtent: 265,
                                        ),
                                        itemBuilder:
                                            (BuildContext context, int idx) {
                                          if (data.data[idx].isLiked
                                              .toString()
                                              .contains("1")) {
                                            _counter.like(data.data[idx].variant_id);
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child:
                                                            FancyShimmerImage(
                                                          imageUrl: data
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
                                                              '',
                                                              data.data[idx].id,
                                                              data.data[idx].variant_id);
                                                        },
                                                      )).then((value) {
                                                        debugPrint(value);
                                                        _reload();
                                                      });
                                                    },
                                                  ),
//not available changes
                                                  if (data.data[idx]
                                                          .prod_quantity ==
                                                      0)
                                                    Container(
                                                      height: 175,
                                                      margin: (idx % 2 == 0)
                                                          ? EdgeInsets.fromLTRB(
                                                              0, 8, 6, 8)
                                                          : EdgeInsets.fromLTRB(
                                                              6, 8, 0, 8),
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
                                                      margin: (idx % 2 == 0)
                                                          ? EdgeInsets.fromLTRB(
                                                              10, 16, 16, 0)
                                                          : EdgeInsets.fromLTRB(
                                                              10, 16, 10, 0),
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: InkResponse(
                                                          onTap: () {
                                                            print(' --  ' +
                                                                _counter
                                                                    .likedIndex
                                                                    .length
                                                                    .toString());
                                                            dpProLikeDisLike(
                                                                "" +
                                                                    data
                                                                        .data[
                                                                            idx]
                                                                        .variant_id);
                                                            if (_counter
                                                                .likedIndex
                                                                .contains(data
                                                                    .data[idx]
                                                                    .variant_id)) {
                                                              _counter.disliked(
                                                                  data.data[idx]
                                                                      .variant_id);
                                                            } else {
                                                              _counter.like(data
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
                                                                builder: (_) => (!_counter
                                                                        .likedIndex
                                                                        .contains("" +
                                                                            data.data[idx].variant_id))
                                                                    ? Image.asset(
                                                                        'assets/icons/dislike.png',
                                                                        width:
                                                                            14,
                                                                        height:
                                                                            14,
                                                                      )
                                                                    : Image.asset(
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
                                                    3, 2, 0, 0),
                                                child: Text(

                                                  data.data[idx].pro_subtitle,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'OpenSans-Bold',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15,
                                                      color: (data.data[idx]
                                                                  .prod_quantity ==
                                                              0)
                                                          ? Color(ColorConsts
                                                              .grayColor)
                                                          : Color(ColorConsts
                                                              .blackColor)),
                                                ),

                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    3, 0, 0, 2.5),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '$currSym ' +
                                                          data.data[idx].prod_unitprice.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '') +
                                                          " ",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontSize: 13,
                                                          color: (idx == 5)
                                                              ? Color(ColorConsts
                                                                  .grayColor)
                                                              : Color(ColorConsts
                                                                  .textColor)),
                                                    ),

                                                    if (double.parse((data.data[idx].prod_discount).toString()) > 0)Text(
                                                        data.data[idx].prod_strikeout_price.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), ''),
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
                                                    if (double.parse((data.data[idx].prod_discount).toString()) > 0)
                                                      (data.data[idx]
                                                              .prod_discount_type
                                                              .contains("flat"))
                                                          ? Flexible(child: Text(
                                                              " " +
                                                                  data.data[idx]
                                                                      .prod_discount
                                                                      .toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '') +
                                                                  ' Flat Off',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'OpenSans',
                                                                  fontSize:
                                                                      12.5,
                                                                  color: (data.data[idx].prod_quantity ==
                                                                          0)
                                                                      ? Color(
                                                                          0x9AB446FF)
                                                                      : Color(ColorConsts
                                                                          .primaryColor)),
                                                            )
                                                      )
                                                          : Flexible(child: Text(
                                                              "  " +
                                                                  data.data[idx]
                                                                      .prod_discount
                                                                      .toString() +
                                                                  '% Off',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'OpenSans',
                                                                  fontSize:
                                                                      12.5,
                                                                  color: (data.data[idx].prod_quantity ==
                                                                          0)
                                                                      ? Color(
                                                                          0x9AB446FF)
                                                                      : Color(ColorConsts
                                                                          .primaryColor)),
                                                            )
                                                      )
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  if(data.data[idx].rating_user_count > 0)Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            6, 3, 7, 3),
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.fromLTRB(
                                                        4, 2, 0, 0),
                                                    decoration: BoxDecoration(
                                                        color: (data.data[idx]
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
                                                              data.data[idx]
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
                                                  if(data.data[idx].rating_user_count > 0)Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            6, 1, 6, 1),
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.fromLTRB(
                                                        2, 2, 0, 0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          data.data[idx]
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
                                        }),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            Resource.of(context, tag!)
                                                    .strings
                                                    .brandsYouLove +
                                                " ",
                                            style: TextStyle(
                                                fontFamily: 'OpenSans-Bold',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Color(
                                                    ColorConsts.textColor)),
                                          ),
                                          Image.asset(
                                            'assets/icons/like.png',
                                            width: 17,
                                            height: 14,
                                          )
                                        ],
                                      ),
                                      margin:
                                          EdgeInsets.fromLTRB(10, 12, 8, 14),
                                    ),
                                    GridView.builder(
                                        scrollDirection: Axis.vertical,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: bData.data.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 2.0,
                                                mainAxisExtent: 150,
                                                mainAxisSpacing: 2.0),
                                        itemBuilder:
                                            (BuildContext context, int ind) {
                                          return Column(children: [
                                            InkResponse(onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return InsideSubCategory(
                                                          "" +
                                                              bData.data[ind].brand_name,
                                                          "",
                                                          "",""+bData.data[ind].id);
                                                    },
                                                  )).then((value) {

                                                _reload();
                                              });
                                            },child :Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 4),
                                              width: 107,
                                              height: 85,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: FancyShimmerImage(
                                                  imageUrl: '' +
                                                      bData.data[ind]
                                                          .brand_image,
                                                  boxFit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            ),
                                            Text(
                                              bData.data[ind].brand_name,
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans-Bold',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  color: Color(
                                                      ColorConsts.textColor)),
                                            ),
                                          ]);
                                        }),
                                    if(pbData.data.length > 0)Container(
                                        margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 140,
                                        child: Stack(
                                          children: <Widget>[
                                            PageView.builder(
                                              controller: controller,
                                              itemCount: pbData.data.length,
                                              itemBuilder: (_, index) {
                                                return InkResponse(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadiusDirectional
                                                              .circular(7.0),
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              pbData.data[index]
                                                                  .banner_image),
                                                          alignment: Alignment
                                                              .topCenter,
                                                          fit: BoxFit.fill),
                                                    ),
                                                    height: 140,
                                                    margin: EdgeInsets.fromLTRB(
                                                        1, 0, 7, 0),
                                                  ),
                                                  onTap: () async {

                                                    await launch(pbData
                                                        .data[index]
                                                        .banner_link);
                                                  },
                                                );
                                              },
                                            ),
                                            Align(
                                              child: Container(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  height: 88,
                                                  child: SmoothPageIndicator(
                                                    controller: controller,
                                                    count: pbData.data.length,
                                                    axisDirection:
                                                        Axis.horizontal,
                                                    effect: ExpandingDotsEffect(
                                                        spacing: 8.0,
                                                        radius: 4.0,
                                                        dotWidth: 7.0,
                                                        dotHeight: 4.8,
                                                        paintStyle:
                                                            PaintingStyle.fill,
                                                        strokeWidth: 1,
                                                        dotColor:
                                                            Color(0xffd9d7d7),
                                                        activeDotColor:
                                                            Color(0xffFFFFFF)),
                                                  )),
                                            ),
                                          ],
                                        )),

                                  ],
                                ));
                          } else {
                            if(snapshot.hasError){
                              return Material(child:  Column(children: [

                              Container(
                              margin: EdgeInsets.fromLTRB(0, 65, 0, 14),
                                  child: Image.asset(
                                    'assets/images/noDataFound.png',
                                    height: 160,
                                  )), Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(8),
                                  child: Text(
                                    'Something went wrong!\nTry again ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(
                                            ColorConsts.blackColor),
                                        fontFamily: 'OpenSans-Bold',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  )),
                                        ])
                                        );
                            }
                            return Material(
                                type: MaterialType.transparency,
                                child: Container(
                                    height: 700,
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
                                                    ColorConsts
                                                        .primaryColorLyt),
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
                        },
                      ),
                    )),


                    SliverToBoxAdapter(
                      child: SizedBox(
                        child: FutureBuilder<dynamic>(
                            future: hasData
                                ? SoldItemPresenter()
                                .getMostSoldProductList(_userLoginModel.data.token,1000)
                                : null,
                            builder: (context, projectSnap) {
                              if (projectSnap.hasData) {


                                return  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,children: [
                                if(projectSnap.data!.data.length > 0)Container(
                                  child:
                                  Text(
                                    Resource.of(context, tag!).strings.MostSoldItems +
                                        " ",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans-Bold',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Color(ColorConsts.textColor)),
                                  ),
                                  margin: EdgeInsets.fromLTRB(10, 12, 8, 14),
                                ),
                              Container(
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
                                                      image: (projectSnap.data!.data[idx].prod_image.length >0)?DecorationImage(
                                                        image: NetworkImage(projectSnap.data!.data[idx].prod_image[0]),
                                                        fit: BoxFit.cover,
                                                        alignment:
                                                        Alignment.topCenter,
                                                      ): null,
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
                                                        if(projectSnap.data!.data[idx].rating_user_count>0)Container(
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
                                                        if(projectSnap.data!.data[idx].rating_user_count>0)Container(
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
                                                    width: 190,
                                                    alignment: Alignment.centerLeft,
                                                    child: Row(crossAxisAlignment: CrossAxisAlignment.start,

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
                                                              fontSize: 13,
                                                              color: Color(
                                                                  ColorConsts.grayColor)),
                                                        ),
                                                        if(double.parse((projectSnap.data!.data[idx].prod_discount).toString()) > 0)(projectSnap.data!.data[idx].prod_discount_type.contains("flat"))?
                                          Flexible(child: Text(
                                                          " "+projectSnap.data!.data[idx].prod_discount.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '')+' Flat Off',
                                                          style: TextStyle(
                                                              fontFamily: 'OpenSans',
                                                              fontSize: 12.5,
                                                              color: (projectSnap.data!.data[idx].prod_quantity ==0)
                                                                  ? Color(0x9AB446FF)
                                                                  : Color(ColorConsts
                                                                  .primaryColor)),
                                                        )
                                          ):Text(
                                                          "  "+projectSnap.data!.data[idx].prod_discount.toString()+'% Off',
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
                                                    return SingleItemScreen('',projectSnap.data!.data[idx].id,projectSnap.data!.data[idx].variant_id);
                                                  },)).then((value) {
                                              debugPrint(value);

                                            });
                                          },
                                          );


                                        })
                                )]
                              );
                              }else{
                                if(projectSnap.hasError) {
                                  return Material(
                                      type: MaterialType.transparency,
                                      child: Container(
                                        height: 100,
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                                        alignment: Alignment.center,
                                      ));
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
                                                          ColorConsts
                                                              .primaryColorLyt),
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
                            }
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
