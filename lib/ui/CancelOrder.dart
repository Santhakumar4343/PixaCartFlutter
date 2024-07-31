import 'dart:convert';

import 'package:e_com/localdb/AppDatabase.dart';
import 'package:e_com/localdb/ListEntity.dart';
import 'package:e_com/model/ModelOrder.dart';
import 'package:e_com/model/ModelSettings.dart';
import 'package:e_com/model/ModelTicketCategory.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/presenter/Orderpresenter.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_com/utils/Resource.dart';
import '../presenter/TicketPresenter.dart';
import '../utils/SharedPref.dart';
import 'MyCart.dart';
import 'Search.dart';
import 'package:fluttertoast/fluttertoast.dart';

late orderData dataItem;
class CancelOrder extends StatefulWidget {
  CancelOrder(orderData dataOrder){
    dataItem=dataOrder;

  }

  @override
  State<StatefulWidget> createState() {
    return MyOrderState();
  }
}

class MyOrderState extends State {
  String currSym = '\$';
  String isSelected='';
  SharedPref sharePrefs = SharedPref();
  String cartLength="0",color_name='',size_fab='';
  late final access;
  late final database;
  String? tag='';
  bool hasData=false;
  late UserLoginModel _userLoginModel;
  TextEditingController ticketContro = TextEditingController();
  TextEditingController writeController = TextEditingController();

  Future<void> getValue() async {
    tag= await sharePrefs.getLanguage();
    _userLoginModel = await sharePrefs.getLoginUserData();

    String? sett = await sharePrefs.getSettings() ;
    final Map<String, dynamic> parsed = json.decode(sett!);
    ModelSettings  modelSettings = ModelSettings.fromJson(parsed);
    currSym=modelSettings.data.currency_symbol.toString();
    hasData=true;
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


  CancelAPI() async {
String res = await  OrderPresenter().getOrderCancel(_userLoginModel.data.token, dataItem.sub_orderid, writeController.text,'6');
if(res.contains("1")){
    Navigator.pop(context);}
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
                                        padding: EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
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
                                                'Select Subject of Ticket',
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16
                                                    ,
                                                    color: Color(
                                                        ColorConsts
                                                            .grayColor)),),
                                            ),
                                            Container(height: 32,
                                              margin: EdgeInsets.fromLTRB(
                                                  1, 2, 1, 14),
                                              child:
                                              ListView.builder(
                                                  scrollDirection: Axis
                                                      .horizontal,


                                                  itemCount: category.data
                                                      .length,
                                                  itemBuilder: (context,
                                                      int idx) {
                                                    return InkResponse(
                                                        onTap: () {


                                                          idCate =
                                                              category.data[idx]
                                                                  .id;

                                                          setState(() {

                                                          });
                                                        },
                                                        child: Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(
                                                                0, 4, 4, 4),
                                                            padding: EdgeInsets
                                                                .all(2),
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: new BoxDecoration(
                                                                color: (
                                                                    idCate
                                                                        .contains(
                                                                        category
                                                                            .data[idx]
                                                                            .id))
                                                                    ? Color(
                                                                    ColorConsts
                                                                        .primaryColor)
                                                                    : Color(
                                                                    ColorConsts
                                                                        .whiteColor),
                                                                border: Border
                                                                    .all(
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
                                                                    .circular(
                                                                    5.0)),
                                                            child: Text(' ' +
                                                                category
                                                                    .data[idx]
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
                                              Container(
                                                  alignment: Alignment.center,

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
                                                          border: InputBorder
                                                              .none
                                                      ),
                                                      style: TextStyle(
                                                          color: Color(
                                                              ColorConsts
                                                                  .blackColor),
                                                          fontSize: 15.0,
                                                          fontFamily: 'OpenSans')
                                                  )
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: InkResponse(
                                                  onTap: () async {
                                                    if (ticketContro.text
                                                        .isNotEmpty) {
                                                      if(idCate.isEmpty) {
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

                                                      }
                                                      else{
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
                                                      await TicketPresenter()
                                                          .addTicket(
                                                      _userLoginModel.data
                                                          .token,
                                                      dataItem.id,
                                                      _userLoginModel.data
                                                          .id
                                                      , ticketContro.text,
                                                      idCate,
                                                      dataItem
                                                          .prod_sellerid);
                                                      ticketContro.text = "";
                                                      Navigator.pop(
                                                      context, false);
                                                      }
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
                                                      margin: EdgeInsets
                                                          .fromLTRB(
                                                          0, 14, 0, 0),
                                                      padding: EdgeInsets
                                                          .fromLTRB(
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
                                            Icons.clear, color: Color(
                                            ColorConsts.blackColor),
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
    color_name=dataItem.prod_attributes;
    Map<String,dynamic>  parsed = json.decode(color_name);

    color_name=parsed["Colorname"];
    if(parsed.keys.contains("size")){
      size_fab=parsed["Size"];}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Scaffold(

        resizeToAvoidBottomInset: true,
        body:  Material(
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
                            child: Text('Cancel Order',
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
                            margin: EdgeInsets.fromLTRB(0, 6, 60, 6),
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
                      ])),
                Container(margin: EdgeInsets.fromLTRB(12, 60,12, 40),child: CustomScrollView(
                slivers: [

                    SliverToBoxAdapter(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 6),
                          alignment: Alignment.center,
                          child: Column(children: [Row(
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
                                                image: NetworkImage(dataItem.prod_image[0]),
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
                                   Flexible(child:  Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(

                                          margin: EdgeInsets.fromLTRB(
                                              0, 4, 0, 0),
                                          child:  Text(
                                            dataItem.prod_name+"",
                                            maxLines: 2,
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans-Bold',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17,
                                                color: Color(ColorConsts
                                                    .blackColor)),

                                          ),


                                        ),

                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 0, 0, 2.5),

                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Text(
                                                '$currSym'+dataItem.prod_unitprice.replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '')+" ",
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 13,
                                                    color: Color(ColorConsts
                                                        .textColor)),
                                              ),
                                              Text(
                                                ''+dataItem.prod_strikeout_price.replaceAll(RegExp(r'([.]*0)(?!.*\d)'), ''),
                                                style: TextStyle(
                                                    decoration:
                                                    TextDecoration
                                                        .lineThrough,
                                                    decorationThickness:
                                                    2.2,
                                                    fontFamily: 'OpenSans',
                                                    decorationStyle:
                                                    TextDecorationStyle
                                                        .solid,
                                                    decorationColor:
                                                    Colors.black54,
                                                    fontSize: 13,
                                                    color: Color(ColorConsts
                                                        .grayColor)),
                                              ),
                                              if (double.parse((dataItem.prod_discount)
                                                  .toString()) >
                                                  0)
                                                (dataItem.prod_discount_type
                                                    .contains("flat"))
                                                    ? Text(
                                                  " " +
                                                      dataItem.prod_discount.toString() +
                                                      ' Flat Off',
                                                  style: TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 12,
                                                      color: (dataItem.prod_quantity == 0) ? Color(0x9AB446FF) : Color(ColorConsts.primaryColor)),
                                                )
                                                    : Text(
                                                  "  " +
                                                      dataItem.prod_discount.toString() +
                                                      '% Off',
                                                  style: TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 12,
                                                      color: (dataItem.prod_quantity == 0) ? Color(0x9AB446FF) : Color(ColorConsts.primaryColor)),
                                                ),
                                            ],
                                          ),
                                        ), Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 0, 0, 2),

                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Text(
                                                'Color Name:',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 14,
                                                    color: Color(ColorConsts
                                                        .grayColor)),
                                              ),
                                          Flexible(child:Text(
                                                ' '+color_name,
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',

                                                    decorationStyle:
                                                    TextDecorationStyle
                                                        .solid,
                                                    decorationColor:
                                                    Colors.black54,
                                                    fontSize: 14,
                                                    color: Color(ColorConsts
                                                        .blackColor)),
                                              ),
                                          )

                                            ],
                                          ),
                                        ), if(size_fab.isNotEmpty)Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 0, 0, 2.5),

                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Text(
                                                'Size :',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 14,
                                                    color: Color(ColorConsts
                                                        .grayColor)),
                                              ),
                                              Text(
                                                ' $size_fab',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    decorationStyle:
                                                    TextDecorationStyle
                                                        .solid,
                                                    decorationColor:
                                                    Colors.black54,
                                                    fontSize: 14,
                                                    color: Color(ColorConsts
                                                        .blackColor)),
                                              ),

                                            ],
                                          ),
                                        ), Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 0, 0, 2.5),

                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Text(
                                                'Places On : ',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 14,
                                                    color: Color(ColorConsts
                                                        .grayColor)),
                                              ),
                                              Text(
                                                dataItem.order_date,
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    decorationStyle:
                                                    TextDecorationStyle
                                                        .solid,
                                                    decorationColor:
                                                    Colors.black54,
                                                    fontSize: 14,
                                                    color: Color(ColorConsts
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
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 14,
                                                    color: Color(ColorConsts
                                                        .grayColor)),
                                              ),
                                              Text(
                                               dataItem.order_uniqueid,
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    decorationStyle:
                                                    TextDecorationStyle
                                                        .solid,
                                                    decorationColor:
                                                    Colors.black54,
                                                    fontSize: 14,
                                                    color: Color(ColorConsts
                                                        .blackColor)),
                                              ),

                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 0, 0, 0),
                                          width: 179,
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Text(
                                                'Delivery On :',
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 15,
                                                    color: Color(ColorConsts
                                                        .grayColor)),
                                              ),
                                              Text(

                                                (dataItem.tracking.order_deliver_on.isEmpty)  ?'Not found': " "+dataItem.tracking.order_deliver_on,
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    decorationStyle:
                                                    TextDecorationStyle
                                                        .solid,
                                                    decorationColor:
                                                    Colors.black54,
                                                    fontSize: 14,
                                                    color: Color(ColorConsts
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
                                        'Quantity : ',
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

                                          child:Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [

                                              Text(
                                                dataItem.order_qty.toString(),
                                                style: TextStyle(
                                                    fontFamily:
                                                    'OpenSans',
                                                    fontSize: 19,
                                                    color: Color(ColorConsts
                                                        .grayColor)),
                                              ),
                                            ],)


                                      ),

                                    ],),
                                  SizedBox(
                                    height: 6,
                                  )
                                ],),
                              ) ,
                    ),
            SliverToBoxAdapter(
child:Column(
crossAxisAlignment: CrossAxisAlignment.start,
    children: [ if(hasData)Container(




                padding: EdgeInsets.all(9),
                decoration: new BoxDecoration(

                    border: Border.all(
                        color: Color(ColorConsts.grayColor), width: 0.6),
                    borderRadius: BorderRadius.circular(8.0)),
                child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,children: [


                  Stack(children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
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

                  ],),

                  Container(
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
                  ),Container(
                    margin: EdgeInsets.fromLTRB(12, 5, 12, 8),
                    child:   Text(
                      _userLoginModel.data.address,
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
            ),

      Container(
        margin: EdgeInsets.fromLTRB(1, 12, 12, 0),
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
      /*Container(
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
      Container(
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
      ),
      Container(
          height: 47,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
          margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
          decoration: BoxDecoration(
            gradient: (isSelected.contains("other"))?LinearGradient(
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

                              color: (isSelected.contains( "other"))? Color(ColorConsts.whiteColor):Color(ColorConsts.blackColor), ),
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


     /* if(isSelected.contains( "other"
      ))*/Container(alignment: Alignment.center,

          margin: EdgeInsets.fromLTRB(0, 16, 2, 19),
          padding: EdgeInsets.fromLTRB(11, 1, 8, 1),
          decoration: new BoxDecoration(

              border: Border.all(
                  color: Color(ColorConsts.grayColor), width: 0.5),
              borderRadius: BorderRadius.circular(8.0)),
          child:TextField(
              minLines: 4,
              maxLines: 5,
              controller: writeController,
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
      InkResponse(
     onTap: () {
       if(writeController.text.isNotEmpty){
CancelAPI();
       }else{

         Fluttertoast
             .showToast(
             msg: 'Enter reason to cancel!',
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
          margin: EdgeInsets.fromLTRB(0, 12, 0, 39),
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
            'Cancel Order',
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



            ]),


            )]
                ),
                ),
Align(alignment: Alignment.bottomCenter,
    child: InkResponse(onTap: () {
      Dialog(context);
      /*Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HelpCenter();
      },));*/
    },child: Container(
width: MediaQuery.of(context).size.width,
height: 45,
      color: Color(0xffF3F3F3),

alignment: Alignment.center,
      child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
        Image.asset(
          'assets/icons/ticket.png',
          width: 25,
          height: 18,
          color: Color(ColorConsts.primaryColor),
          alignment: Alignment.center,
        ),Text(
        'Generate Ticket',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 16,
            color: Color(ColorConsts.primaryColor)),
      ),],)
    )

    )
)

                ])
            )


)


        ));
  }
}
