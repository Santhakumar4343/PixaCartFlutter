import 'dart:convert';

import 'package:e_com/localdb/AppDatabase.dart';
import 'package:e_com/localdb/ListEntity.dart';
import 'package:e_com/model/ModelSettings.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_com/utils/Resource.dart';
import '../utils/SharedPref.dart';
import 'PaymentMethod.dart';
import 'ProfileEdit.dart';


class MyCart extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return cartState();
  }



}
class jsonPro {
  String pid = '';
  String vid = '';
  String seller_id = '';
  String qty = '';
  String price = '';
  String subtotal = '';
  String? selectedSize = ''; // Add this field

  jsonPro(this.pid, this.vid, this.seller_id, this.qty, this.price, this.subtotal, [this.selectedSize]);

  factory jsonPro.fromJson(Map<String, dynamic> json) {
    return jsonPro(
      json['pid'],
      json['vid'],
      json['seller_id'],
      json['qty'],
      json['price'],
      json['subtotal'],
      json['selectedSize'], // Parse selectedSize
    );
  }

  Map<String, dynamic> toJson() => {
    'pid': pid,
    'vid': vid,
    'seller_id': seller_id,
    'qty': qty,
    'price': price,
    'subtotal': subtotal,
    'selectedSize': selectedSize, // Add selectedSize
  };
}

class cartState extends State<MyCart> {
  bool hasData = false;
  SharedPref sharePrefs = SharedPref();
  String? tag = '';
  late UserLoginModel _userLoginModel;
  String currSym = '\$';
  late final access;
  late final database;
  late List<ListEntity> cartList;
  int cartLength = 0;
  double amount = 0.0, strickPrice = 0.0, diffAmount = 0.0;
  String prod_details = '[]';

  // Maps to store selectedPrice and selectedSize for each variant_id
  Map<String, String> selectedPrices = {};
  Map<String, String> selectedSizes = {};
  Map<String, String> selectedProd_Quantites = {};
  Future<void> initDb() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    access = await database.daoaccess;
    fetch(); // Fetch data after initializing the database
  }

  Future<void> fetch() async {
    amount = 0.0;
    strickPrice = 0.0;
    diffAmount = 0.0;
    List<jsonPro> lis = [];
    cartList = await access.getAll();
    cartLength = cartList.length;

    // Clear the maps before populating
    selectedPrices.clear();
    selectedSizes.clear();
selectedProd_Quantites.clear();
    if (cartLength > 0) {
      // Fetch selected prices and sizes for each variant_id directly from the database
      for (int i = 0; i < cartList.length; i++) {
        print("discount :"+cartList[i].prod_discount+"  Strikeout Price :"+cartList[i].prod_strikeout_price+"  discount type :"+cartList[i].prod_discount_type+" ===================");
        String id = cartList[i].regno?.toString() ?? '';
        String variantId = cartList[i].variant_id;
        selectedPrices[id.toString()] = cartList[i].selectedPrice;
        selectedSizes[id.toString()] = cartList[i].selectedSize;
        selectedProd_Quantites[id.toString()]=cartList[i].prod_quantity;
      }
      // Process cart items
      for (int i = 0; i < cartList.length; i++) {
        String? selectedPriceStr = selectedPrices[cartList[i].regno.toString()];

        double selectedPrice = selectedPriceStr != null ? double.parse(selectedPriceStr) : 0.0;
        String? selectedSize = selectedSizes[cartList[i].regno.toString()]; // Fetch selectedSize

        // Calculate amounts based on the selectedPrice
        amount += selectedPrice * double.parse(cartList[i].order_quantity);
        strickPrice += double.parse(cartList[i].prod_strikeout_price);

        if (double.parse(cartList[i].prod_strikeout_price) >= selectedPrice) {
          diffAmount += (double.parse(cartList[i].prod_strikeout_price) - selectedPrice) * double.parse(cartList[i].order_quantity);
        }
        cartList[i].prod_unitprice = selectedPrice.toString();

        // Convert id to String before using it
        String id = cartList[i].regno?.toString() ?? '';


        // Add to the list with updated prod_unitprice and selectedSize
        lis.add(jsonPro(
          cartList[i].id,
          cartList[i].variant_id,
          cartList[i].sellerId,
          cartList[i].order_quantity,
          cartList[i].prod_unitprice, // Use selectedPrice as prod_unitprice
          (selectedPrice * double.parse(cartList[i].order_quantity)).toString(),
          selectedSize, // Add selectedSize
        ));
      }
    }

    // Convert the list to JSON
    var json = jsonEncode(lis.map((e) => e.toJson()).toList());
    prod_details = json;

    setState(() {});
  }


  Future<void> updateData(ListEntity listEntity) async {
    await access.insertInList(listEntity); // Insert with auto-generated ID
    fetch();
  }

  Future<void> getValue() async {
    tag = await sharePrefs.getLanguage();
    _userLoginModel = await sharePrefs.getLoginUserData();
    String? sett = await sharePrefs.getSettings();
    final Map<String, dynamic> parsed = json.decode(sett!);
    ModelSettings modelSettings = ModelSettings.fromJson(parsed);
    currSym = modelSettings.data.currency_symbol.toString();
    hasData = true;
    fetch();
    setState(() {});
  }

  void _reload() {
    initDb();
    getValue();
  }

  @override
  void initState() {
    initDb();
    getValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child:Scaffold(
          resizeToAvoidBottomInset: true,
          body: Material(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Color(ColorConsts.whiteColor),
                  child: Stack(
                      children: [
                        Container(
                            height: 58,
                            padding: EdgeInsets.all(0),
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
                                    child: Text('My Cart',
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



                              ],
                            )),
                        if(cartLength==0)Container(
                            margin: EdgeInsets.fromLTRB(12, 19, 12, 0)
                            ,width: MediaQuery.of(context).size.width
                            ,height: MediaQuery.of(context).size.height
                            , alignment: Alignment.center,
                            child:Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,children: [
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 24, 0, 4),
                                  child: Image.asset(
                                    'assets/images/noDataFound.png',
                                    height: 160,
                                  )),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 16, 0, 24),
                                alignment: Alignment.center,
                                child: Text(
                                  'Empty Cart' +

                                      " !\nStart Shopping Now.. ",textAlign: TextAlign.center,
                                  style: TextStyle(

                                      fontFamily: 'OpenSans-Bold',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Color(ColorConsts.textColor)),
                                ),
                              )
                            ])
                        ),
                        if(cartLength>0)Container(   margin: EdgeInsets.fromLTRB(12, 69, 12, 0),child: CustomScrollView(

                            slivers: [
                              SliverToBoxAdapter(
                                  child: Container(


                                      alignment: Alignment.center,

                                      padding: EdgeInsets.all(9),
                                      decoration: new BoxDecoration(

                                          border: Border.all(
                                              color: Color(ColorConsts.grayColor), width: 0.5),
                                          borderRadius: BorderRadius.circular(8.0)),
                                      child:Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,children: [


                                        Stack(children: [
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
                                          Align(
                                            alignment: Alignment.centerRight,child:Container(
                                              margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
                                              child:  InkResponse(child:  Text(
                                                'Change',

                                                style: TextStyle(
                                                    fontFamily:
                                                    'OpenSans-Bold',
                                                    fontSize: 18,
                                                    color: Color(ColorConsts
                                                        .primaryColor)),


                                              ),onTap: () {
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                  return ProfileEdit();
                                                },)).then((value) {
                                                  _reload();
                                                });
                                              },
                                              )
                                          ),
                                          )
                                        ],),

                                        if(hasData)Container(
                                          margin: EdgeInsets.fromLTRB(12, 13, 12, 0),
                                          child:   Text(
                                            _userLoginModel.data.fullname,
                                            style: TextStyle(
                                                fontFamily:
                                                'OpenSans-Bold',
                                                fontSize: 18,
                                                color: Color(ColorConsts
                                                    .blackColor)),


                                          ),
                                        ),
                                        if(hasData)Container(
                                          margin: EdgeInsets.fromLTRB(12, 5, 12, 8),
                                          child:   Text(
                                            (_userLoginModel.data.address.toString().isEmpty)?'Shipping address not found!':_userLoginModel.data.address,
                                            style: TextStyle(
                                                fontFamily:
                                                'OpenSans-Bold',
                                                fontSize: 18,
                                                color: Color(ColorConsts
                                                    .grayColor)),


                                          ),
                                        ),
                                      ]
                                      )
                                  )
                              ),
                              if(hasData)SliverToBoxAdapter(
                                child:  Container(
                                  padding: EdgeInsets.fromLTRB(6, 12, 6, 12),
                                  margin: EdgeInsets.fromLTRB(6, 16, 6, 6),
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
                                          10.0)),
                                  child:

                                  Text(
                                    (cartLength <= 1 )?'You Have '+cartLength.toString()+' Item in Your List Cart':'You Have '+cartLength.toString()+' Items in Your List Cart',
                                    style: TextStyle(
                                        fontFamily:
                                        'OpenSans-Bold',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: Color(
                                            ColorConsts
                                                .whiteColor)),

                                  ),
                                ),
                              )
                              ,
                              if(hasData)SliverToBoxAdapter(
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.fromLTRB(1, 10, 1, 0),
                                    alignment: Alignment.center,
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: cartLength,
                                        itemBuilder: (context, int idx) {
                                          return Column(children: [Row(
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
                                                            blurRadius: 2,
                                                            color: Color.fromRGBO(
                                                                0, 0, 0, 0.090),
                                                          )
                                                        ],
                                                        borderRadius:
                                                        BorderRadiusDirectional
                                                            .circular(7.0),
                                                        image: DecorationImage(
                                                          image: NetworkImage(cartList[idx].prod_image),
                                                          fit: BoxFit.cover,
                                                          alignment:
                                                          Alignment.topCenter,
                                                        ),
                                                      ),
                                                      height: 128,
                                                      width: 125,
                                                      margin: (idx % 2 == 0)
                                                          ? EdgeInsets.fromLTRB(
                                                          0, 6, 11, 8)
                                                          : EdgeInsets.fromLTRB(
                                                          0, 6, 11, 8),
                                                    ),
                                                    onTap: () {},
                                                  ),
                                                  /*  Container(
                                   height: 90,
                                   width: 115,
                                   margin: EdgeInsets.fromLTRB(
                                       10, 15, 0, 0),
                                   alignment: Alignment.topRight,
                                   child: Container(
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
                                         borderRadius:
                                         BorderRadius.all(
                                           Radius.circular(20),
                                         ),
                                         color: Color(ColorConsts
                                             .whiteColor),
                                       ),
                                       child: (cartList[idx].isLiked==0)
                                           ? Image.asset(
                                         'assets/icons/dislike.png',
                                         width: 14,
                                         height: 14,
                                       )
                                           : Image.asset(
                                         'assets/icons/like.png',
                                         width: 14,
                                         height: 14,
                                       )
                                   )),*/
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        1, 4, 0, 0),
                                                    child: Text(
                                                      cartList[idx].prod_name,
                                                      style: TextStyle(
                                                          fontFamily: 'OpenSans-Bold',
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 16.5,
                                                          color: Color(ColorConsts
                                                              .blackColor)),
                                                    ),
                                                    width: 190,
                                                  ),

                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 2.5),
                                                    width: 194,
                                                    alignment: Alignment.centerLeft,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Container for displaying price
                                                        Container(
                                                          margin: EdgeInsets.only(bottom: 2.0), // Space between price and selected size
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                '$currSym ${cartList[idx].prod_unitprice.replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '')}',
                                                                style: TextStyle(
                                                                  fontFamily: 'OpenSans',
                                                                  fontSize: 13,
                                                                  color: Color(ColorConsts.textColor),
                                                                ),
                                                              ),
                                                              if (double.parse((cartList[idx].prod_discount).toString()) > 0)
                                                                if (double.parse(cartList[idx].prod_strikeout_price) > 0)
                                                                  Text(
                                                                    ' ${cartList[idx].prod_strikeout_price.replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '')}',
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
                                                              if (double.parse((cartList[idx].prod_discount).toString()) > 0)
                                                                (cartList[idx].prod_discount_type.contains("flat"))
                                                                    ? Text(
                                                                  " ${cartList[idx].prod_discount.toString()} Flat Off",
                                                                  style: TextStyle(
                                                                    fontFamily: 'OpenSans',
                                                                    fontSize: 12,
                                                                    color: (cartList[idx].prod_quantity == 0)
                                                                        ? Color(0x9AB446FF)
                                                                        : Color(ColorConsts.primaryColor),
                                                                  ),
                                                                )
                                                                    : Text(
                                                                  " ${cartList[idx].prod_discount.toString()}% Off",
                                                                  style: TextStyle(
                                                                    fontFamily: 'OpenSans',
                                                                    fontSize: 12,
                                                                    color: (cartList[idx].prod_quantity == 0)
                                                                        ? Color(0x9AB446FF)
                                                                        : Color(ColorConsts.primaryColor),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                        // Container for displaying selected size
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                'Size: ${selectedSizes[cartList[idx].regno.toString()] ?? 'N/A'}',
                                                                style: TextStyle(
                                                                  fontFamily: 'OpenSans',
                                                                  fontSize: 13,
                                                                  color: Color(ColorConsts.textColor),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
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

                                                ],
                                              ),
                                            ],
                                          ),
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'Qty: ',
                                                  style: TextStyle(
                                                      fontFamily:
                                                      'OpenSans-Bold',
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 18,
                                                      color: Color(
                                                          ColorConsts
                                                              .blackColor)),

                                                ),Container(
                                          height: 40,
                                          width: 110,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.fromLTRB(3, 12, 3, 8),
                                          decoration: BoxDecoration(
                                          border: Border.all(color: Color(ColorConsts.grayColor), width: 0.5),
                                          borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                          InkResponse(
                                          onTap: () async {
                                          if (int.parse(cartList[idx].order_quantity) > 1) {
                                          int quan = int.parse(cartList[idx].order_quantity);
                                          quan--;
                                          await access.updateList(quan.toString(), cartList[idx].regno.toString());
                                          fetch();
                                          } else {
                                          Fluttertoast.showToast(
                                          msg: 'Quantity must be more than 1',
                                          toastLength: Toast.LENGTH_SHORT,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey,
                                          textColor: Color(ColorConsts.whiteColor),
                                          fontSize: 14.0,
                                          );
                                          }
                                          },
                                          child: Image.asset(
                                          'assets/icons/Minus.png',
                                          height: 30,
                                          width: 17,
                                          ),
                                          ),
                                          Container(
                                          height: 40,
                                          width: 1,
                                          color: Color(ColorConsts.grayColor),
                                          ),
                                          Text(
                                          cartList[idx].order_quantity,
                                          style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontSize: 19,
                                          color: Color(ColorConsts.grayColor),
                                          ),
                                          ),
                                          Container(
                                          height: 40,
                                          width: 1,
                                          color: Color(ColorConsts.grayColor),
                                          ),
                                          InkResponse(
                                          onTap: () async {
                                          if (int.parse(cartList[idx].prod_quantity) > int.parse(cartList[idx].order_quantity)) {
                                          int quan = int.parse(cartList[idx].order_quantity);
                                          quan++;
                                          await access.updateList(quan.toString(), cartList[idx].regno.toString());
                                          fetch();
                                          } else {
                                          Fluttertoast.showToast(
                                          msg: 'No More Items Available..',
                                          toastLength: Toast.LENGTH_SHORT,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey,
                                          textColor: Color(ColorConsts.whiteColor),
                                          fontSize: 14.0,
                                          );
                                          }
                                          },
                                          child: Image.asset(
                                          'assets/icons/Plus.png',
                                          height: 30,
                                          width: 16,
                                          ),
                                          ),
                                          ],
                                          ),
                                          ),

                                          InkResponse(
                                                  onTap: () async {
                                                    await access.delete(''+cartList[idx].regno.toString());

                                                    fetch();

                                                  },child :Container(
                                                  margin: EdgeInsets.fromLTRB(1, 0, 4, 0),
                                                  padding: EdgeInsets.fromLTRB(11, 0, 11, 0),
                                                  height: 40,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      gradient:
                                                      LinearGradient(
                                                        colors: [
                                                          Color(ColorConsts
                                                              .secondaryBtnColor),
                                                          Color(ColorConsts
                                                              .secondaryBtnColor)
                                                        ],
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                      ),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          20.0)),
                                                  child:

                                                  Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        fontFamily:
                                                        'OpenSans-Bold',
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 14.6,
                                                        color: Color(
                                                            ColorConsts
                                                                .whiteColor)),

                                                  ),
                                                ),
                                                ),Container(
                                                  padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
                                                  height: 40,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      gradient:
                                                      LinearGradient(
                                                        colors: [
                                                          Color(ColorConsts
                                                              .whiteColor),
                                                          Color(ColorConsts
                                                              .whiteColor)
                                                        ],
                                                        /* colors: [
                                     Color(ColorConsts
                                         .primaryColor),
                                     Color(ColorConsts
                                         .secondaryColor)
                                   ],*/
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                      ),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          20.0)),
                                                  child:

                                                  Text(
                                                    'Save for Later',
                                                    style: TextStyle(
                                                        fontFamily:
                                                        'OpenSans-Bold',
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 14.6,
                                                        color: Color(
                                                            ColorConsts
                                                                .whiteColor)),

                                                  ),
                                                ),
                                              ],),
                                            SizedBox(
                                              height: 6,
                                            )
                                          ],);
                                        })) ,
                              ),
                              SliverToBoxAdapter(
                                child:Column(mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,children: [

                                    /*  if(cartLength>0)Text(
                 'Voucher Code',
                 style: TextStyle(
                     fontFamily:
                     'OpenSans-Bold',
                     fontWeight: FontWeight.w500,
                     fontSize: 18,
                     color: Color(
                         ColorConsts
                             .blackColor)),

               ),*/
                                    /*if(cartLength>0)Stack(children: [
                   Container(margin: EdgeInsets.fromLTRB(0, 0, 60, 0),child:TextField( decoration: InputDecoration(
                       hintText:
                       'Enter Voucher Code',
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
                       'Apply',

                       style: TextStyle(
                           fontFamily:
                           'OpenSans-Bold',
                           fontSize: 18,
                           color: Color(ColorConsts
                               .primaryColor)),


                     ),
                   ),
                   ),

                 ],),*/
                                    Container(height: 0.1,
                                      margin:EdgeInsets.fromLTRB(0, 0, 0, 12),color: Color(ColorConsts.grayColor),),
                                    if(cartLength>0) Text(
                                      'Price Details',
                                      style: TextStyle(
                                          fontFamily:
                                          'OpenSans-Bold',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Color(
                                              ColorConsts
                                                  .blackColor)),

                                    ),

                                    if(hasData)if(cartLength>0)Container(

                                      margin: EdgeInsets.fromLTRB(0, 12, 0, 12),
                                      padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                                      alignment: Alignment.center,
                                      decoration: new BoxDecoration(
                                          border: Border.all(
                                              color: Color(ColorConsts.grayColor), width: 0.4),
                                          borderRadius: BorderRadius.circular(8.0)),
                                      child:
                                      ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: cartLength,
                                          itemBuilder: (context, int idx) {

                                            return   Column(
                                              children: [
                                                Container(margin: EdgeInsets.fromLTRB(10, 10, 10, 6),child: Align(alignment: Alignment.centerLeft,
                                                  child:Text(
                                                    ''+cartList[idx].prod_name,
                                                    style: TextStyle(
                                                        fontFamily:
                                                        'OpenSans-Bold',
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16,
                                                        color: Color(
                                                            ColorConsts
                                                                .blackColor)
                                                    ),

                                                  ) ,),
                                                ),
                                                if(double.parse(cartList[idx].prod_strikeout_price) > 0)Container(margin: EdgeInsets.fromLTRB(10, 5, 10, 6),child: Stack(children: [
                                                  Align(alignment: Alignment.centerLeft,
                                                    child:Text(
                                                      'Price (Qty x item Price)'+' ',
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'OpenSans-Bold',

                                                          fontSize: 15.5,
                                                          color: Color(
                                                              ColorConsts
                                                                  .grayColor)
                                                      ),

                                                    ) ,),
                                                  Align(alignment: Alignment.centerRight,
                                                    child:Text(
                                                      cartList[idx].order_quantity+ ' X '+cartList[idx].prod_strikeout_price,
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'OpenSans-Bold',

                                                          fontSize: 15.5,
                                                          color: Color(
                                                              ColorConsts
                                                                  .primaryColor)
                                                      ),

                                                    ) ,)
                                                ],),),   if(double.parse(cartList[idx].prod_discount) > 0) Container(margin: EdgeInsets.fromLTRB(10, 2, 10, 6),child: Stack(children: [
                                                  Align(alignment: Alignment.centerLeft,
                                                    child:Text(
                                                      'Discount',
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'OpenSans-Bold',
                                                          fontSize: 15.5,
                                                          color: Color(
                                                              ColorConsts
                                                                  .grayColor)),

                                                    ) ,),
                                                  Align(alignment: Alignment.centerRight,
                                                    child:Text(
                                                      (cartList[idx].prod_discount_type.contains("flat"))?""+cartList[idx].prod_discount+' Off': cartList[idx].prod_discount+"% Off",
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'OpenSans-Bold',

                                                          fontSize: 15.5,
                                                          color: Color(
                                                              ColorConsts
                                                                  .primaryColor)),

                                                    ) ,)
                                                ],),),

                                                if(!cartList[idx].prod_unitprice.contains(cartList[idx].prod_strikeout_price)) Container(margin: EdgeInsets.fromLTRB(10, 2, 10, 6),child: Stack(children: [
                                                  Align(alignment: Alignment.centerLeft,
                                                    child:Text(
                                                      (double.parse(cartList[idx].prod_strikeout_price) > 0)?'Discount Price (Qty x item Price) ':'Price (Qty X item Price)',
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'OpenSans-Bold',

                                                          fontSize: 15.5,
                                                          color: Color(
                                                              ColorConsts
                                                                  .grayColor)
                                                      ),

                                                    ) ,),
                                                  Align(alignment: Alignment.centerRight,
                                                    child:Text(
                                                      cartList[idx].order_quantity+' X '+cartList[idx].prod_unitprice,
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'OpenSans-Bold',

                                                          fontSize: 15.5,
                                                          color: Color(
                                                              ColorConsts
                                                                  .primaryColor)
                                                      ),

                                                    ) ,)
                                                ],),), Container(margin: EdgeInsets.fromLTRB(10, 2, 10, 12),child: Stack(children: [
                                                  Align(alignment: Alignment.centerLeft,
                                                    child:Text(
                                                      'Delivery Charges',
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'OpenSans-Bold',

                                                          fontSize: 15.5,
                                                          color: Color(
                                                              ColorConsts
                                                                  .primaryColor)),

                                                    ) ,),
                                                  Align(alignment: Alignment.centerRight,
                                                    child:Text(
                                                      'Free',
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'OpenSans-Bold',

                                                          fontSize: 15.5,
                                                          color: Color(
                                                              ColorConsts
                                                                  .primaryColor)
                                                      ),

                                                    ) ,)
                                                ],),),
                                                Container(height: 0.2,
                                                  color: Color(ColorConsts.grayColor),),
                                                if(cartList.length-1 ==idx)Container(margin: EdgeInsets.fromLTRB(10, 16, 10, 16),child: Stack(children: [
                                                  Align(alignment: Alignment.centerLeft,
                                                    child:Text(
                                                      'Total Amount',
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'OpenSans-Bold',
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 15.5,
                                                          color: Color(
                                                              ColorConsts
                                                                  .blackColor)),

                                                    ) ,),
                                                  Align(alignment: Alignment.centerRight,
                                                    child:Text(
                                                      '$currSym'+amount.toString(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'OpenSans-Bold',
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 15.5,
                                                          color: Color(
                                                              ColorConsts
                                                                  .blackColor)),

                                                    ) ,)
                                                ],),)
                                              ],
                                            );
                                          }





                                      ),
                                    ),
                                    if(diffAmount>0)Container(
                                      padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
                                      margin: EdgeInsets.fromLTRB(0, 6, 0, 12),
                                      height: 44,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          gradient:
                                          LinearGradient(
                                            colors: [
                                              Color(ColorConsts
                                                  .pinkLytColor),
                                              Color(ColorConsts
                                                  .pinkLytColor)
                                            ],
                                            begin: Alignment
                                                .centerLeft,
                                            end: Alignment
                                                .centerRight,
                                          ),
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              6.0)),
                                      child:

                                      Text(
                                        'You will save $currSym '+(diffAmount).toString()+' on this order',
                                        style: TextStyle(
                                            fontFamily:
                                            'OpenSans-Bold',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.5,
                                            color: Color(ColorConsts
                                                .primaryColor)
                                        ),

                                      ),
                                    ),
                                    if(cartLength>0)InkResponse(child: Container(
                                      padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
                                      margin: EdgeInsets.fromLTRB(16, 6, 16, 27),
                                      height: 44,
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
                                              25.0)),
                                      child:

                                      Text(
                                        'Proceed to Checkout',
                                        style: TextStyle(
                                            fontFamily:
                                            'OpenSans-Bold',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.5,
                                            color: Color(
                                                ColorConsts
                                                    .whiteColor)),

                                      ),
                                    ),onTap: () {
                                      if(_userLoginModel.data.email.isEmpty){
                                        Fluttertoast.showToast(
                                            msg: 'Complete your profile details.',
                                            toastLength: Toast.LENGTH_SHORT,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.grey,
                                            textColor: Color(ColorConsts.whiteColor),
                                            fontSize: 14.0);
                                      }else {
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) {
                                          return PaymentMethod(
                                              "" + amount.toString(), prod_details);
                                        },)).then((value) => _reload());
                                      }
                                    },
                                    )
                                  ],)
                                ,)
                            ]
                        ),
                        )

                      ])

              )
          ),
        )
    );
  }



}