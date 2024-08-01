import 'dart:convert';

import 'package:e_com/localdb/AppDatabase.dart';
import 'package:e_com/localdb/ListEntity.dart';

import 'package:e_com/model/ModelOrder.dart';
import 'package:e_com/model/ModelOrderDetails.dart';
import 'package:e_com/model/ModelReviews.dart';
import 'package:e_com/model/ModelSettings.dart';
import 'package:e_com/model/ModelTicketCategory.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/presenter/Orderpresenter.dart';
import 'package:e_com/presenter/ReviewPresenter.dart';
import 'package:e_com/presenter/TicketPresenter.dart';
import 'package:e_com/ui/CancelOrder.dart';

import 'package:e_com/utils/SharedPref.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'MyCart.dart';
import 'Notifications.dart';
import 'Search.dart';
import 'package:e_com/utils/Resource.dart';
import 'package:fluttertoast/fluttertoast.dart';


late orderData dataOrder ;
String statusOfOrder='';
class MyOrder extends StatefulWidget {
  MyOrder(orderData data) {
    dataOrder = data;
  }

  @override
  State<StatefulWidget> createState() {
    return MyOrderState();
  }
}

class MyOrderState extends State {
  String currSym = '\$';
  String isSelected="";
  SharedPref sharePrefs = SharedPref();
  String cartLength="0",color_name='',size_fab='';
  String? tag='';
  late final access;
  late final database;
  late UserLoginModel _userLoginModel;
  late ModelOrderDetails details;
  bool hasData=false,hasRev=false;
   int rate=0,minRate=0;
  TextEditingController writeController = TextEditingController();
  TextEditingController ticketContro = TextEditingController();
  TextEditingController refunController = TextEditingController();
  late ModelSettings  modelSettings ;


  Future<void> getValue() async {
    tag= await sharePrefs.getLanguage();
    _userLoginModel = await sharePrefs.getLoginUserData();
    String? sett = await sharePrefs.getSettings() ;
    final Map<String, dynamic> parsed = json.decode(sett!);
    modelSettings = ModelSettings.fromJson(parsed);
    currSym=modelSettings.data.currency_symbol.toString();
    getOrderDetails();
    initDb();
  }

  Future<void> initDb() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    access = database.daoaccess;
    List<ListEntity> listdata = await access.getAll();
    cartLength=listdata.length.toString();
    setState(() {
    });
  }

  getOrderDetails() async {
 details=await OrderPresenter().getOrderDetails(_userLoginModel.data.token, _userLoginModel.data.id, dataOrder.order_id);


getReview();

  }
  refundAPI() async {
    String res = await  OrderPresenter().getOrderCancel(_userLoginModel.data.token, dataOrder.sub_orderid, refunController.text,'8');
    if(res.contains("1")){
      refunController.text="";

    }
  }

  Future<void> getReview() async {
    ModelReviews reviews= await ReviewPresenter().getListWithProId(_userLoginModel.data.token,dataOrder.id,_userLoginModel.data.id);
    hasData=true;
    if(reviews.data.length != 0){
    writeController.text=reviews.data[0].review;
    minRate=reviews.data[0].rating;

    hasRev=true;}
    rate=minRate;
    setState(() {

    });
  }
  void doReview(){
    ReviewPresenter().doReview(_userLoginModel.data.token, _userLoginModel.data.id, dataOrder.id, ""+rate.toString(), ""+writeController.text);
  }


  Future<bool> Dialog(BuildContext context) async {

    String idCate='';
ModelTicketCategory category=  await  TicketPresenter().getTicketCategory(_userLoginModel.data.token);
if(category.data.length==0){

  Fluttertoast
      .showToast(
      msg: 'Subject of Ticket Not added by admin!',
      toastLength: Toast
          .LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors
          .grey,
      textColor:
      Color(ColorConsts
          .whiteColor),
      fontSize: 14.0);
  return false;
}else {
  return (await showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            elevation: 5,
            contentPadding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))
            ),
            content: StatefulBuilder( // You need this, notice the parameters below:
                builder: (BuildContext context, StateSetter setState) {
                  return Container(height: 285,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
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
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Stack(
                          children: [

                            Align(alignment: Alignment.center,
                              child: Container(

                                margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                                child:
                                Align(child: Container(

                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width - 120,
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Column(

                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [Text('Generate Ticket ',
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontFamily: 'OpenSans-Bold',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 19
                                            ,
                                            color: Color(
                                                ColorConsts.blackColor)),),

                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 10, 1, 1),
                                          child: Text(
                                            'Select Subject of Ticket *',
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16
                                                ,
                                                color: Color(
                                                    ColorConsts.grayColor)),),
                                        ),
                                        Container(height: 32,
                                          margin: EdgeInsets.fromLTRB(
                                              1, 2, 1, 14),
                                          child:
                                          ListView.builder(
                                              scrollDirection: Axis.horizontal,


                                              itemCount: category.data.length,
                                              itemBuilder: (context, int idx) {
                                                return InkResponse(onTap: () {
                                                  print("before $idCate");
                                                  print("after");
                                                  idCate =
                                                      category.data[idx].id;
                                                  print("after $idCate");
                                                  setState(() {

                                                  });
                                                },
                                                    child: Container(
                                                        margin: EdgeInsets
                                                            .fromLTRB(
                                                            0, 4, 3, 3),
                                                        padding: EdgeInsets.all(
                                                            2),
                                                        alignment: Alignment
                                                            .center,
                                                        decoration: new BoxDecoration(
                                                            color: (
                                                                idCate.contains(
                                                                    category
                                                                        .data[idx]
                                                                        .id))
                                                                ? Color(
                                                                ColorConsts
                                                                    .primaryColor)
                                                                : Color(
                                                                ColorConsts
                                                                    .whiteColor),
                                                            border: Border.all(
                                                                color: (idCate
                                                                    .contains(
                                                                    category
                                                                        .data[idx]
                                                                        .id))
                                                                    ? Color(
                                                                    ColorConsts
                                                                        .primaryColor)
                                                                    : Color(
                                                                    ColorConsts
                                                                        .grayColor),
                                                                width: 0.5),
                                                            borderRadius: BorderRadius
                                                                .circular(4.0)),
                                                        child: Text(' ' +
                                                            category.data[idx]
                                                                .sp_catename +
                                                            " ",
                                                          style: TextStyle(
                                                              color: (idCate
                                                                  .contains(
                                                                  category
                                                                      .data[idx]
                                                                      .id))
                                                                  ? Color(
                                                                  ColorConsts
                                                                      .whiteColor)
                                                                  : Color(
                                                                  ColorConsts
                                                                      .grayColor)),)
                                                    ));
                                              }),
                                        ),


                                        Column(children: [
                                          Container(alignment: Alignment.center,

                                              padding: EdgeInsets.fromLTRB(
                                                  8, 0, 8, 0),
                                              decoration: new BoxDecoration(

                                                  border: Border.all(
                                                      color: Color(
                                                          ColorConsts
                                                              .grayColor),
                                                      width: 0.5),
                                                  borderRadius: BorderRadius
                                                      .circular(
                                                      8.0)),
                                              child: TextField(
                                                  minLines: 4,
                                                  maxLines: 4,
                                                  controller: ticketContro,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                      'Enter your issues here...',
                                                      hintStyle: TextStyle(
                                                          fontFamily: 'OpenSans',
                                                          fontSize: 15,
                                                          color: Color(
                                                              ColorConsts
                                                                  .lightGrayColor)),
                                                      border: InputBorder.none
                                                  ),
                                                  style: TextStyle(
                                                      color: Color(
                                                          ColorConsts
                                                              .blackColor),
                                                      fontSize: 15.0,
                                                      fontFamily: 'OpenSans')
                                              )
                                          ),
                                          Align(alignment: Alignment.centerLeft,
                                            child: InkResponse(
                                              onTap: () async {
                                                if (ticketContro.text
                                                    .isNotEmpty) {

                                                  if(idCate.isEmpty){
                                                    Fluttertoast
                                                        .showToast(
                                                        msg: 'Choose subject of ticket!',
                                                        toastLength: Toast
                                                            .LENGTH_SHORT,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors
                                                            .grey,
                                                        textColor:
                                                        Color(ColorConsts
                                                            .whiteColor),
                                                        fontSize: 14.0);
                                                  }else{
                                                    Fluttertoast
                                                        .showToast(
                                                        msg: 'Wait..',
                                                        toastLength: Toast
                                                            .LENGTH_SHORT,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors
                                                            .grey,
                                                        textColor:
                                                        Color(ColorConsts
                                                            .whiteColor),
                                                        fontSize: 14.0);
                                                    print('asfdskdjfnksdhfjkshdjf------------- '+idCate);
                                                  await TicketPresenter()
                                                      .addTicket(
                                                      _userLoginModel.data
                                                          .token,
                                                      dataOrder.id,
                                                      _userLoginModel.data.id
                                                      , ticketContro.text,
                                                      idCate,
                                                      dataOrder.prod_sellerid);
                                                  ticketContro.text = "";
                                                  Navigator.pop(context, false);}
                                                } else {
                                                  Fluttertoast
                                                      .showToast(
                                                      msg: 'Enter issue to continue!',
                                                      toastLength: Toast
                                                          .LENGTH_SHORT,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Colors
                                                          .grey,
                                                      textColor:
                                                      Color(ColorConsts
                                                          .whiteColor),
                                                      fontSize: 14.0);
                                                }
                                              }, // passing true
                                              child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 14, 0, 0),
                                                  padding: EdgeInsets.fromLTRB(
                                                      21, 8, 21, 8),
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
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
                                                      borderRadius: BorderRadius
                                                          .circular(20.0)),
                                                  child: Text(
                                                    Resource
                                                        .of(context, tag!)
                                                        .strings
                                                        .SubmitNow,
                                                    style: TextStyle(
                                                        fontFamily: 'OpenSans-Bold',
                                                        fontSize: 14.0,
                                                        color: Color(
                                                            ColorConsts
                                                                .whiteColor)
                                                    ),
                                                  )),
                                            ),),

                                        ],)


                                      ],)
                                ),),

                              ),
                            ),

                            Align(alignment: Alignment.topRight,
                                child: InkResponse(
                                  child: Container(
                                    width: 24,
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                        Icons.clear,
                                        color: Color(ColorConsts.blackColor),
                                        size: 20),
                                  ), onTap: () {
                                  Navigator.pop(context, false);
                                },)
                            )

                          ],)
                    ),);
                }
            )


        ),
  )) ??
      false;
}

  }

  @override
  void initState() {
    getValue();
    switch (dataOrder.order_status){
      case 0:
        statusOfOrder="Delivered";
          break;
      case 1:
        statusOfOrder="Delivered";
        break;
      case 2:
        statusOfOrder="Pending";
        break;
      case 3:
        statusOfOrder="Confirmed";
        break;
      case 4:
        statusOfOrder="Ready To Dispatch";
        break;
      case 5:
        statusOfOrder="Dispatched";
        break;
      case 6:
        statusOfOrder="Cancelled";
        break;
      case 7:
        statusOfOrder="Return requested";
        break;
      case 8:
        statusOfOrder="Refund requested";
        break;

    }


    color_name=dataOrder.prod_attributes;
    Map<String,dynamic>  parsed = json.decode(color_name);
    color_name=parsed["Colorname"];
    if(parsed.keys.contains("size")){
    size_fab=parsed["Size"];}

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
        resizeToAvoidBottomInset: true,
        body:Material(
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
                      child: Stack(children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(38, 0, 0, 0),
                            child: Text('My Order',
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
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 6, 84, 6),
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
                                    if(int.parse(cartLength) >= 1) Align(
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
                      ])),
                  Container(
                    margin: EdgeInsets.fromLTRB(12, 60, 12, 40),
                    child: CustomScrollView(slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 6),
                            alignment: Alignment.center,
                            child: Column(
                                    children: [
                                      Row(
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
                                                      image: NetworkImage(dataOrder.prod_image[0]),
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          Alignment.topCenter,
                                                    ),
                                                  ),
                                                  height: 151,
                                                  width: 140,
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 6, 10, 0),
                                                ),
                                                onTap: () {},
                                              )
                                            ],
                                          ),
                                         Flexible(child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 2, 0, 0),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  dataOrder.pro_subtitle+ " ("+ dataOrder.prod_name+")",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'OpenSans-Bold',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 17,
                                                      color: Color(ColorConsts
                                                          .blackColor)),
                                                  maxLines: 2,
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 2.5),

                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '$currSym' +
                                                          dataOrder
                                                              .prod_unitprice
                                                              .toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '') +
                                                          " ",
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'OpenSans',
                                                          fontSize:
                                                          13,
                                                          color:
                                                              Color(ColorConsts.textColor)),
                                                    ),
                                                    if (double.parse((dataOrder.prod_discount)
                                                        .toString()) >
                                                        0)if (double.parse(dataOrder.prod_strikeout_price) >=
                                                        1.0)
                                                      Text(
                                                        '' +
                                                            dataOrder.prod_strikeout_price.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), ''),
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
                                                    if (double.parse((dataOrder.prod_discount)
                                                        .toString()) >
                                                        0)
                                                      (dataOrder.prod_discount_type
                                                          .contains("flat"))
                                                          ? Text(
                                                        " " +
                                                            dataOrder.prod_discount.toString() +
                                                            ' Flat Off',
                                                        style: TextStyle(
                                                            fontFamily: 'OpenSans',
                                                            fontSize: 12.5,
                                                            color: (dataOrder.prod_quantity == 0) ? Color(0x9AB446FF) : Color(ColorConsts.primaryColor)),
                                                      )
                                                          : Text(
                                                        "  " +
                                                            dataOrder.prod_discount.toString() +
                                                            '% Off',
                                                        style: TextStyle(
                                                            fontFamily: 'OpenSans',
                                                            fontSize: 12.5,
                                                            color: (dataOrder.prod_quantity == 0) ? Color(0x9AB446FF) : Color(ColorConsts.primaryColor)),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 2),

                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Color Name:',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontSize: 14,
                                                          color: Color(
                                                              ColorConsts
                                                                  .grayColor)),
                                                    ),
                                                    Flexible(child: Text(
                                                      ' '+color_name,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.fade,
                                                      softWrap: false,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          decorationStyle:
                                                              TextDecorationStyle
                                                                  .solid,
                                                          decorationColor:
                                                              Colors.black54,
                                                          fontSize: 14,
                                                          color: Color(
                                                              ColorConsts
                                                                  .blackColor)),
                                                    ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              if(size_fab.isNotEmpty)Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 2.5),

                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Size Name:',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontSize: 14,
                                                          color: Color(
                                                              ColorConsts
                                                                  .grayColor)),
                                                    ),
                                                    Text(
                                                      ' '+size_fab,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          decorationStyle:
                                                              TextDecorationStyle
                                                                  .solid,
                                                          decorationColor:
                                                              Colors.black54,
                                                          fontSize: 14,
                                                          color: Color(
                                                              ColorConsts
                                                                  .blackColor)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 2.5),

                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Places On : ',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontSize: 14,
                                                          color: Color(
                                                              ColorConsts
                                                                  .grayColor)),
                                                    ),
                                                    Text(
                                                  dataOrder.order_date,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          decorationStyle:
                                                              TextDecorationStyle
                                                                  .solid,
                                                          decorationColor:
                                                              Colors.black54,
                                                          fontSize: 14,
                                                          color: Color(
                                                              ColorConsts
                                                                  .blackColor)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 2.5),

                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'OrderId : ',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontSize: 14,
                                                          color: Color(
                                                              ColorConsts
                                                                  .grayColor)),
                                                    ),
                                                    Text(
                                                      dataOrder.order_uniqueid,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          decorationStyle:
                                                              TextDecorationStyle
                                                                  .solid,
                                                          decorationColor:
                                                              Colors.black54,
                                                          fontSize: 14,
                                                          color: Color(
                                                              ColorConsts.blackColor)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),

                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Delivery On :',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontSize: 14,
                                                          color: Color(
                                                              ColorConsts
                                                                  .grayColor)),
                                                    ),
                                                    Text(
                                                      (dataOrder.tracking.order_deliver_on.isEmpty)  ?'Not found':" "+dataOrder.tracking.order_deliver_on,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          decorationStyle:
                                                              TextDecorationStyle
                                                                  .solid,
                                                          decorationColor:
                                                              Colors.black54,
                                                          fontSize: 14,
                                                          color: Color(
                                                              ColorConsts
                                                                  .blackColor)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
    )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Selected Option : ',
                                            style: TextStyle(
                                                fontFamily: 'OpenSans-Bold',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                                color: Color(
                                                    ColorConsts.blackColor)),
                                          ),
                                          Container(
                                              height: 40,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  Text(
                                                    dataOrder.order_Option.toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'OpenSans',
                                                        fontSize: 19,
                                                        color: Color(ColorConsts
                                                            .grayColor)),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Quantity : ',
                                            style: TextStyle(
                                                fontFamily: 'OpenSans-Bold',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                                color: Color(
                                                    ColorConsts.blackColor)),
                                          ),
                                          Container(
                                              height: 40,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                   dataOrder.order_qty.toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'OpenSans',
                                                        fontSize: 19,
                                                        color: Color(ColorConsts
                                                            .grayColor)),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                      if(hasData)Container(alignment: Alignment.centerLeft,child: Text(
                                       (!details.data[0].payment_mode.contains("COD"))?'Payment Mode : Paid Online - '+details.data[0].payment_mode:'Payment Mode  : Cash On Delivery',
                                        style: TextStyle(
                                            fontFamily: 'OpenSans-Bold',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Color(
                                                ColorConsts.blackColor)),
                                      ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      )
                                    ],
                                  ),
                              ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(hasData)Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(9),
                                  decoration: new BoxDecoration(
                                      border: Border.all(
                                          color: Color(ColorConsts.grayColor),
                                          width: 0.6),
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              margin: EdgeInsets.fromLTRB(
                                                  12, 12, 12, 0),
                                              child: Text(
                                                'Delivery Point or Shipping Address',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans-Bold',
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(ColorConsts
                                                        .blackColor)),
                                              ),
                                            ),

                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              12, 13, 12, 0),
                                          child: Text(
                                            _userLoginModel.data.fullname+",",
                                            style: TextStyle(
                                                fontFamily: 'OpenSans-Bold',
                                                fontSize: 18,
                                                color: Color(
                                                    ColorConsts.blackColor)),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(12, 5, 12, 8),
                                          child: Text(
                                            ''+details.data[0].shipping_address,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans-Bold',
                                                fontSize: 18,
                                                color: Color(
                                                    ColorConsts.grayColor)),
                                          ),
                                        ),
                                      ])),
                              if (statusOfOrder.contains("Delivered"))
                                Container(
                                    margin: EdgeInsets.fromLTRB(0, 12, 6, 0),
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(hasRev?'Your Review':'Rate our services',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans-Bold',
                                                fontSize: 19,
                                                fontWeight: FontWeight.w500,
                                                color: Color(
                                                    ColorConsts.blackColor))),
                                        if(hasData)RatingBar.builder(
                                          initialRating: double.parse(minRate.toString()),
                                          minRating: 1,
                                          ignoreGestures: hasRev,
                                          direction: Axis.horizontal,
                                          allowHalfRating: false,
                                          itemCount: 5,
                                          itemSize: 42,
                                          itemPadding:
                                              EdgeInsets.fromLTRB(0, 6, 4, 8),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {

                                            rate=int.parse(rating.round().toString());
                                            print(rating.toString());
                                    //  doReview();
                                          },
                                        )
                                      ],
                                    )),
                              if (statusOfOrder.contains("Delivered")) Container(alignment: Alignment.center,

                                  margin: EdgeInsets.fromLTRB(0, 10, 1, 19),
                                  padding: EdgeInsets.fromLTRB(10, 1, 8, 1),
                                  decoration: new BoxDecoration(

                                      border: Border.all(
                                          color: Color(ColorConsts.grayColor), width: 0.5),
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child:TextField(
                                      minLines: 1,
                                      maxLines: 3,
                                      enabled: !hasRev,
                                      controller: writeController,
                                      decoration: InputDecoration(
                                          hintText:
                                          'Write your review Here..',
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
                              if(statusOfOrder.contains("Delivered"))if(!hasRev)InkResponse(onTap: () {
                                doReview();
                              },child: Container(
                                padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
                                margin: EdgeInsets.fromLTRB(0, 6, 0, 12),
                                height: 38,
                                width: 120,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(ColorConsts.primaryColor),
                                        Color(ColorConsts.secondaryColor)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(20.0)),
                                child: Text(
                                  'Rate it!',
                                  style: TextStyle(
                                      fontFamily: 'OpenSans-Bold',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Color(ColorConsts.whiteColor)),
                                ),
                              ),
                              ),
                              if (statusOfOrder.contains("Pending"))
                                InkResponse(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return CancelOrder(dataOrder);
                                      },
                                    ));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
                                    margin: EdgeInsets.fromLTRB(0, 18, 0, 12),
                                    height: 40,
                                    width: 140,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(ColorConsts.primaryColor),
                                            Color(ColorConsts.secondaryColor)
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Text(
                                      'Cancel Order',
                                      style: TextStyle(
                                          fontFamily: 'OpenSans-Bold',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: Color(ColorConsts.whiteColor)),
                                    ),
                                  ),
                                ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 14, 12, 14),
                                child: Text(
                                  'Track Your Order : '+statusOfOrder,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans-Bold',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Color(ColorConsts.blackColor)),
                                ),
                              ),
                              if(statusOfOrder.contains("Cancel"))Container(
                                margin: EdgeInsets.fromLTRB(0, 14, 12, 14),
                                child: Text(
                                  'Cancelled',
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Color(ColorConsts.redColor)),
                                ),
                              ),
                              if(!statusOfOrder.contains("Cancel"))Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: 50,
                                    child: Column(children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(1, 0, 1, 0),
                                        width: 14.5,
                                        height: 14.5,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2.5,
                                              color:
                                              (dataOrder.tracking.orderProcess.isNotEmpty)
                                                  ?Color(ColorConsts.barColor):Color(ColorConsts.grayColor)),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          color: Color(ColorConsts.whiteColor),
                                        ),
                                      ),
                                      Container(
                                        height: 74,
                                        width: 5,
                                        color: (dataOrder.tracking.orderProcess.isNotEmpty)
                                            ?Color(ColorConsts.barColor):Color(ColorConsts.grayColor),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(1, 0, 1, 0),
                                        width: 14.5,
                                        height: 14.5,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2.5,
                                              color:
                                              (dataOrder.tracking.ready_to_ship.isNotEmpty)
                                                  ?Color(ColorConsts.barColor):Color(ColorConsts.grayColor)),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          color: Color(ColorConsts.whiteColor),
                                        ),
                                      ),
                                      Container(
                                        height: 78,
                                        width: 5,
                                        color: (dataOrder.tracking.ready_to_ship.isNotEmpty)
                                            ?Color(ColorConsts.barColor):Color(ColorConsts.grayColor),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(1, 0, 1, 0),
                                        width: 14.5,
                                        height: 14.5,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2.5,
                                              color:
                                              (dataOrder.tracking.local_ware_house.isNotEmpty)
                                                  ?Color(ColorConsts.barColor):Color(ColorConsts.grayColor)),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          color: Color(ColorConsts.whiteColor),
                                        ),
                                      ),
                                      Container(
                                        height: 74,
                                        width: 5,
                                        color: (dataOrder.tracking.local_ware_house.isNotEmpty)
                                            ?Color(ColorConsts.barColor):Color(ColorConsts.grayColor),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(1, 0, 1, 0),
                                        width: 14.5,
                                        height: 14.5,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2.5,
                                              color: (dataOrder.tracking.order_deliver_on.isNotEmpty)
                                                  ?Color(ColorConsts.barColor):Color(ColorConsts.grayColor)
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          color: Color(ColorConsts.whiteColor),
                                        ),
                                      ),
                                    ]),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(1, 12, 1, 15),
                                        padding:
                                            EdgeInsets.fromLTRB(9, 0, 36, 0),
                                        alignment: Alignment.centerLeft,
                                        height: 70,
                                        decoration: new BoxDecoration(
                                            border: Border.all(
                                                color: (dataOrder.tracking.orderProcess.isNotEmpty)
                                                    ? Color(
                                                        ColorConsts.barColor)
                                                    : Color(
                                                        ColorConsts.grayColor),
                                                width: 0.6),
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Order Processed',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans-Bold',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18,
                                                    color: Color(ColorConsts
                                                        .blackColor)),
                                              ),
                                              Row(children: [
                                                Image.asset(
                                                  'assets/icons/watch.png',
                                                  height: 12,
                                                  width: 15,
                                                ),
                                                Text(
                                                  (dataOrder.tracking.orderProcess.isEmpty)?' Not found':" "+dataOrder.tracking.orderProcess,
                                                  style: TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 14,
                                                      color: Color(ColorConsts
                                                          .grayColor)),
                                                ),
                                              ])
                                            ]),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(1, 9, 1, 15),
                                        padding:
                                            EdgeInsets.fromLTRB(9, 0, 36, 0),
                                        alignment: Alignment.centerLeft,
                                        height: 70,
                                        decoration: new BoxDecoration(
                                            border: Border.all(
                                                color: (dataOrder.tracking.ready_to_ship.isNotEmpty)

    ? Color(
                                                        ColorConsts.barColor)
                                                    : Color(
                                                        ColorConsts.grayColor),
                                                width: 0.6),
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Ready to Shiping',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans-Bold',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18,
                                                    color: Color(ColorConsts
                                                        .blackColor)),
                                              ),
                                              Row(children: [
                                                Image.asset(
                                                  'assets/icons/watch.png',
                                                  height: 12,
                                                  width: 15,
                                                ),
                                                Text(
                                                  (dataOrder.tracking.ready_to_ship.isEmpty)?' Not found':" "+dataOrder.tracking.ready_to_ship,
                                                  style: TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 14,
                                                      color: Color(ColorConsts
                                                          .grayColor)),
                                                ),
                                              ])
                                            ]),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(1, 9, 1, 15),
                                        padding:
                                            EdgeInsets.fromLTRB(9, 0, 36, 0),
                                        alignment: Alignment.centerLeft,
                                        height: 70,
                                        decoration: new BoxDecoration(
                                            border: Border.all(
                                                color:(dataOrder.tracking.local_ware_house.isNotEmpty) ? Color(
                                                        ColorConsts.barColor)
                                                    : Color(
                                                        ColorConsts.grayColor),
                                                width: 0.6),
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Dispatched',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans-Bold',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18,
                                                    color: Color(ColorConsts
                                                        .blackColor)),
                                              ),
                                              Row(children: [
                                                Image.asset(
                                                  'assets/icons/watch.png',
                                                  height: 12,
                                                  width: 15,
                                                ),
                                                Text(
                                                  (dataOrder.tracking.local_ware_house.isEmpty)?' Not found':" "+dataOrder.tracking.local_ware_house,
                                                  style: TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 14,
                                                      color: Color(ColorConsts
                                                          .grayColor)),
                                                ),
                                              ])
                                            ]),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(1, 9, 1, 8),
                                        padding:
                                            EdgeInsets.fromLTRB(9, 0, 36, 0),
                                        alignment: Alignment.centerLeft,
                                        height: 70,

                                        decoration: new BoxDecoration(

                                            border: Border.all(
                                                color: (dataOrder.tracking.order_deliver_on.isNotEmpty)
                                                    ?  Color(
                                                        ColorConsts.barColor)
                                                    : Color(
                                                        ColorConsts.grayColor),
                                                width: 0.6),
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Order Delivered',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans-Bold',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18,
                                                    color: Color(ColorConsts
                                                        .blackColor)),
                                              ),
                                              Row(children: [
                                                Image.asset(
                                                  'assets/icons/watch.png',
                                                  height: 12,
                                                  width: 15,
                                                ),
                                                Text(
                                                  (dataOrder.tracking.order_deliver_on.isEmpty)?' Not found':" "+dataOrder.tracking.order_deliver_on,
                                                  style: TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 14,
                                                      color: Color(ColorConsts
                                                          .grayColor)),
                                                ),
                                              ])
                                            ]),
                                      ),
                                      if((statusOfOrder
                                          .contains('Delivered')))Row(children: [
                                        Image.asset(
                                          'assets/icons/check.png',
                                          height: 13,
                                          width: 13,
                                        ),
                                        Text(
                                          '  Your Order Successfully Delivered',
                                          style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              fontSize: 13,
                                              color: Color(ColorConsts.green)),
                                        ),
                                      ])
                                    ],
                                  ),
                                ],
                              ),
                              if((statusOfOrder
                                  .contains('Delivered')))Container(
                                margin: EdgeInsets.fromLTRB(1, 30, 12, 0),
                                child:   Text(
                                  'Returns & Refunds Reason',
                                  style: TextStyle(
                                      fontFamily:
                                      'OpenSans-Bold',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Color(ColorConsts
                                          .blackColor)),


                                ),
                              ),
                             /* if((statusOfOrder
                                  .contains('Delivered'))) Container(
                                  height: 47,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
                                  margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  decoration: BoxDecoration(
                                    gradient: (isSelected.contains( Resource.of(context,tag!).strings.HowCanITrackMyOrder))?LinearGradient(
                                      colors: [
                                        Color(ColorConsts.primaryColor),
                                        Color(ColorConsts.secondaryColor)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ):null,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: Color(ColorConsts.lightGrayColor), width: 0.5),
                                  ),
                                  child:InkResponse(
                                    onTap: () {
                                      isSelected= Resource.of(context,tag!).strings.HowCanITrackMyOrder;
                                      setState(() {

                                      });

                                    },
                                    child: Stack(

                                        children: [

                                          Container(
                                            margin: EdgeInsets.fromLTRB(2, 0, 0, 0),

                                            child: Column(
                                              children: [
                                                Container(

                                                  alignment: Alignment.centerLeft,
                                                  child: Text('You Don\'t Like the Quality?'
                                                    ,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily: 'OpenSans-Bold',
                                                      fontSize: 17,

                                                      color: (isSelected.contains( Resource.of(context,tag!).strings.HowCanITrackMyOrder))? Color(ColorConsts.whiteColor):Color(ColorConsts.blackColor), ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          )

                                          ,

                                          *//*  Align(
                    alignment: Alignment.topRight,
                    child: Container(

                      margin: EdgeInsets.fromLTRB(0, 3.5, 12, 0),

                      child:Image.asset(
                        'assets/icons/DownIcon.png',width: 7,color:(isSelected.contains( Resource.of(context,tag!).strings.HowCanITrackMyOrder
                      ))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

                    ),

                  )*//*
                                        ]
                                    ),
                                  )
                              ),
                              if((statusOfOrder
                                  .contains('Delivered')))Container(
                                  height: 47,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
                                  margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  decoration: BoxDecoration(
                                    gradient: (isSelected.contains( Resource.of(context,tag!).strings.HowCanITrackMyOrder))?LinearGradient(
                                      colors: [
                                        Color(ColorConsts.primaryColor),
                                        Color(ColorConsts.secondaryColor)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ):null,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: Color(ColorConsts.lightGrayColor), width: 0.5),
                                  ),
                                  child:InkResponse(
                                    onTap: () {
                                      isSelected= Resource.of(context,tag!).strings.HowCanITrackMyOrder;
                                      setState(() {

                                      });

                                    },
                                    child: Stack(

                                        children: [

                                          Container(
                                            margin: EdgeInsets.fromLTRB(2, 0, 0, 0),

                                            child: Column(
                                              children: [
                                                Container(

                                                  alignment: Alignment.centerLeft,
                                                  child: Text('You Don\'t Like the Color?'
                                                    ,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily: 'OpenSans-Bold',
                                                      fontSize: 17,

                                                      color: (isSelected.contains( Resource.of(context,tag!).strings.HowCanITrackMyOrder))? Color(ColorConsts.whiteColor):Color(ColorConsts.blackColor), ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          )

                                          ,

                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(

                                              margin: EdgeInsets.fromLTRB(0, 3.5, 12, 0),
                                              alignment: Alignment.centerRight,
                                              child:Image.asset(
                                                'assets/icons/check.png',width: 13,color:(isSelected.contains( Resource.of(context,tag!).strings.HowCanITrackMyOrder
                                              ))? Color(ColorConsts.whiteColor):Color(ColorConsts.green),),

                                            ),

                                          )
                                        ]
                                    ),
                                  )
                              ),*/
                              /*if((statusOfOrder
                                  .contains('Delivered'))) Container(
                                  height: 47,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
                                  margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  decoration: BoxDecoration(
                                    gradient: (isSelected.contains( "other"))?LinearGradient(
                                      colors: [
                                        Color(ColorConsts.primaryColor),
                                        Color(ColorConsts.secondaryColor)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ):null,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: Color(ColorConsts.lightGrayColor), width: 0.5),
                                  ),
                                  child:InkResponse(
                                    onTap: () {
                                      if( isSelected.contains( "other"
                                      )){
                                      isSelected= "";}else{
                                        isSelected= "other";
                                      }
                                      setState(() {

                                      });

                                    },
                                    child: Stack(

                                        children: [

                                          Container(
                                            margin: EdgeInsets.fromLTRB(2, 0, 0, 0),

                                            child: Column(
                                              children: [
                                                Container(

                                                  alignment: Alignment.centerLeft,
                                                  child: Text('Other Issues'
                                                    ,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily: 'OpenSans-Bold',
                                                      fontSize: 17,

                                                      color: (isSelected.contains("other"))? Color(ColorConsts.whiteColor):Color(ColorConsts.blackColor), ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          )

                                          ,

                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              margin: EdgeInsets.fromLTRB(0, 0, 13, 0),

                                              child:Image.asset(
                                                isSelected.contains( "other"
                                                )?'assets/icons/Downarrow.png':'assets/icons/DownIcon.png',width:  isSelected.contains( "other"
                                              )?12:7,color:(isSelected.contains( "other"
                                              ))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

                                            ),

                                          )
                                        ]
                                    ),
                                  )
                              ),*/


                              if((statusOfOrder
                                  .contains('Delivered')))Container(alignment: Alignment.center,

                                  margin: EdgeInsets.fromLTRB(0, 16, 2, 19),
                                  padding: EdgeInsets.fromLTRB(16, 1, 8, 1),
                                  decoration: new BoxDecoration(

                                      border: Border.all(
                                          color: Color(ColorConsts.grayColor), width: 0.5),
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child:TextField(
                                      minLines: 3,
                                      maxLines: 4,
                                      controller: refunController,
                                      decoration: InputDecoration(
                                          hintText:
                                          'Write your reason Here..',
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
                              if((statusOfOrder
                                  .contains('Delivered')))InkResponse(
                                onTap: () {
                                  if(refunController.text.isNotEmpty){

                                  refundAPI();}else{
                                    Fluttertoast
                                        .showToast(
                                        msg: 'Write reason to continue!',
                                        toastLength: Toast
                                            .LENGTH_SHORT,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors
                                            .grey,
                                        textColor:
                                        Color(ColorConsts.whiteColor),
                                        fontSize: 14.0);

                                  }
                                }, child: Container(
                                padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
                                margin: EdgeInsets.fromLTRB(0, 12, 0, 40),
                                height: 40,
                                width: 140,
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
                                        20.0)),
                                child:

                                Text(
                                  'Generate return',
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

                              ),

                              if((!statusOfOrder
                                  .contains('Delivered')))SizedBox(height: 50,)



                            ]),
                      )
                    ]),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: InkResponse(
                        onTap: () {
                          Dialog(context);

                        },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              color: Color(0xffF3F3F3),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/ticket.png',
                                    width: 25,
                                    height: 18,
                                    color: Color(ColorConsts.primaryColor),
                                    alignment: Alignment.center,
                                  ),
                                  Text(
                                    'Generate Ticket',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(ColorConsts.primaryColor)),
                                  ),
                                ],
                              ))))
                ]))
        )
        )
    );
  }
}
