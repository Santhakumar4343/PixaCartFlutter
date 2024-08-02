import 'dart:convert';

import 'package:e_com/localdb/AppDatabase.dart';
import 'package:e_com/localdb/ListEntity.dart';
import 'package:e_com/model/ModelSettings.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/paymentgateway/PayStack.dart';
import 'package:e_com/paymentgateway/Paypal.dart';

import 'package:e_com/paymentgateway/Razorpay.dart';
import 'package:e_com/presenter/Orderpresenter.dart';
import 'package:e_com/presenter/PaymetDetailPresenter.dart';
import 'package:e_com/utils/Resource.dart';
import 'package:e_com/utils/SharedPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../paymentgateway/Stripe.dart';
import '../utils/color_const.dart';
import 'ProfileEdit.dart';
import 'package:fluttertoast/fluttertoast.dart';

String amountToBePaid = '';
String PaymentOption="",prodDetails='',currSym = '\$';

class PaymentMethod extends StatefulWidget {
  PaymentMethod(String amount,String prod_details) {
    amountToBePaid = amount;
    prodDetails=prod_details;
  }

  @override
  State<StatefulWidget> createState() {
    return MyPaymentState();
  }
}

class MyPaymentState extends State {
  bool isPending=true;
  bool hasData = false,processed=false;
  SharedPref sharePrefs = SharedPref();
  String? tag = '';
  late UserLoginModel _userLoginModel;
  late final access;
  late final database;
  late List<ListEntity> cartList;
  String currencySym='';
  late ModelSettings modelSettings;

  Future<void> getValue() async {
    tag = await sharePrefs.getLanguage();
    _userLoginModel = await sharePrefs.getLoginUserData();
    paymentDetailFetch();

  }

  void _reload() {
    getValue();
  }
  Future<void> paymentDetailFetch() async {
    await PaymetDetailPresenter().get(_userLoginModel.data.token);
    String? sett = await sharePrefs.getSettings() ;
    final Map<String, dynamic> parsed = json.decode(sett!);
    modelSettings = ModelSettings.fromJson(parsed);

  currencySym=modelSettings.data.currency_symbol.toString();
    hasData = true;
  currSym=currencySym;
    setState(() {});
  }
  Future<void> initDb() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    access = database.daoaccess;
    cartList = await access.getAll();
  }

  Future<void> orderPlace() async {
   String res =await OrderPresenter().getOrderPlace(_userLoginModel.data.token, _userLoginModel.data.id, amountToBePaid, _userLoginModel.data.address,  _userLoginModel.data.address, 'COD', '2', prodDetails, []);
   if(res.contains("1")){isPending=false;}
   processed=false;
   setState(() {

   });
   if(res.contains("1")){
     for(int i=0;i<cartList.length;i++){
     await access.delete(""+cartList[i].regno.toString());

     }

     slideSheet('s');
   }else{
     slideSheetFailed('s');
   }
  }

  @override
  void initState() {
initDb();
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
            return Container(
              color: Color(0xFF737373),
              child: Container(
                height: 385,
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.white,
                ),
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                    child: Image.asset(
                      'assets/images/Successicon.png',
                      width: 112,
                      height: 112,
                    ),
                  ),
                  Text('Success!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'OpenSans-Bold',
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: Color(ColorConsts.blackColor))),
                  Text(    (PaymentOption.contains("COD"))?"Order placed Successfully":'You Paid $currSym 848 Successfully',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(ColorConsts.grayColor))),
                  Container(
                    height: 0.5,
                    width: MediaQuery.of(context).size.width,
                    color: Color(ColorConsts.grayColor),
                    margin: EdgeInsets.fromLTRB(6, 12, 6, 12),
                  ),
                /*  Container(
                      margin: EdgeInsets.fromLTRB(16, 4, 6, 0),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('  Rate our product',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'OpenSans-Bold',
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                  color: Color(ColorConsts.blackColor))),
                          RatingBar.builder(
                            initialRating: 1,
                            minRating: 0.5,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 45,
                            itemPadding: EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 6),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if(rating==5.0){
                                Fluttertoast.showToast(
                                    msg: 'Excellent !',
                                    toastLength: Toast.LENGTH_SHORT);
                              }

                            },
                          )
                        ],
                      )),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkResponse(onTap: () {
Navigator.pop(context);
                      },child: Container(
                        width: (MediaQuery.of(context).size.width / 2) - 30,
                        height: 45,
                        padding: EdgeInsets.fromLTRB(6, 2, 8, 2),
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(16, 16, 6, 0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(ColorConsts.secondaryColor),
                                width: 0.8),
                            borderRadius: BorderRadius.circular(22.0)),
                        child: Text(
                          'Ok thanks',
                          style: TextStyle(
                              fontFamily: 'OpenSans-Bold',
                              fontSize: 19,
                              color: Color(ColorConsts.grayColor)),
                        ),
                      ),
                      ),
                     /* Container(
                        width: (MediaQuery.of(context).size.width / 2) - 30,
                        height: 45,
                        padding: EdgeInsets.fromLTRB(6, 4, 8, 4),
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(6, 16, 16, 0),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(ColorConsts.primaryColor),
                                Color(ColorConsts.secondaryColor)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(22.0)),
                        child: Text(
                          'Rate!',
                          style: TextStyle(
                              fontFamily: 'OpenSans-Bold',
                              fontSize: 19,
                              color: Color(ColorConsts.whiteColor)),
                        ),
                      ),*/
                    ],
                  )
                ]),
              ),
            );
          });
        });
  }

  void slideSheetFailed(String s) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              color: Color(0xFF737373),
              child: Container(
                height: 385,
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.white,
                ),
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                    child: Image.asset(
                      'assets/images/alert.png',
                      width: 112,
                      height: 122,
                    ),
                  ),
                  Text('Transaction failed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'OpenSans-Bold',
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: Color(ColorConsts.blackColor))),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                    child: Text(' Please try again',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(ColorConsts.grayColor))),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width / 2) - 30,
                        height: 45,
                        padding: EdgeInsets.fromLTRB(6, 2, 8, 2),
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(6, 20, 16, 0),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(ColorConsts.primaryColor),
                                Color(ColorConsts.secondaryColor)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(22.0)),
                        child: Text(
                          'Go Back',
                          style: TextStyle(
                              fontFamily: 'OpenSans-Bold',
                              fontSize: 16,
                              color: Color(ColorConsts.whiteColor)),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(6, 24, 6, 0),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text('Need Help? Contact Our Customer Support',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 15,
                                  color: Color(ColorConsts.primaryColor))),
                        ],
                      )),
                ]),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(children: [
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
                      child: Text('Payment Methods',
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
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(12, 16, 12, 0),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(9),
                    decoration: new BoxDecoration(
                        border: Border.all(
                            color: Color(ColorConsts.grayColor), width: 0.5),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
                                child: Text(
                                  'Delivery Point',
                                  style: TextStyle(
                                      fontFamily: 'OpenSans-Bold',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Color(ColorConsts.blackColor)),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
                                    child: InkResponse(
                                      child: Text(
                                        'Change',
                                        style: TextStyle(
                                            fontFamily: 'OpenSans-Bold',
                                            fontSize: 18,
                                            color: Color(
                                                ColorConsts.primaryColor)),
                                      ),
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) {
                                            return ProfileEdit();
                                          },
                                        )).then((value) {
                                          _reload();
                                        });
                                      },
                                    )),
                              )
                            ],
                          ),
                          if (hasData)
                            Container(
                              margin: EdgeInsets.fromLTRB(12, 13, 12, 0),
                              child: Text(
                                _userLoginModel.data.fullname,
                                style: TextStyle(
                                    fontFamily: 'OpenSans-Bold',
                                    fontSize: 18,
                                    color: Color(ColorConsts.blackColor)),
                              ),
                            ),
                          if (hasData)
                            Container(
                              margin: EdgeInsets.fromLTRB(12, 5, 12, 8),
                              child: Text(
                                _userLoginModel.data.address,
                                style: TextStyle(
                                    fontFamily: 'OpenSans-Bold',
                                    fontSize: 18,
                                    color: Color(ColorConsts.grayColor)),
                              ),
                            ),
                        ])),
                Container(
                  padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                  margin: EdgeInsets.fromLTRB(12, 16, 12, 6),
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
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (isPending)?' Total Amount' + '':"Paid Amount",
                          style: TextStyle(
                              fontFamily: 'OpenSans-Bold',
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(ColorConsts.whiteColor)),
                        ),
                        Text(
                          currencySym+'' + amountToBePaid,
                          style: TextStyle(
                              fontFamily: 'OpenSans-Bold',
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(ColorConsts.whiteColor)),
                        ),
                      ]),
                ),

                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(12, 22, 0, 0),
                  child: Text(
                      (hasData)?'Select option to place a order :':'Loading Please Wait..',
                    style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 18,

                        color: Color(ColorConsts.grayColor)),
                  ),
                ),
                if(hasData)if(modelSettings.data.cod_status.contains("1"))InkResponse(child: Container(
                  margin: EdgeInsets.fromLTRB(12, 20, 12, 0),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: new BoxDecoration(
                      border: Border.all(
                          color: Color(ColorConsts.grayColor), width: 0.5),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                              child: Text(
                                'Cash On Delivery',
                                style: TextStyle(
                                    fontFamily: 'OpenSans-Bold',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,

                                    color: Color(ColorConsts.blackColor)),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(

                                 child: Image.asset("assets/icons/Phonepeicon.png",width: 22,height: 22,),
                              ),
                            )
                            ,
                            if(PaymentOption.contains("COD"))Align(
                              alignment: Alignment.centerRight,
                              child: Container(

                                child: Image.asset("assets/icons/check.png",width: 25,height: 22,),
                              ),
                            )
                          ],
                        ),
                      ]),
                ),
                  onTap: () {
                    PaymentOption="COD";
                    setState(() {
                      
                    });
                    
                  },
                ),
               if(hasData)if(modelSettings.data.RAZORPAY_DETAILS.status.contains("1"))InkResponse(child: Container(
                  margin: EdgeInsets.fromLTRB(12, 18, 12, 0),
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(9, 4, 10,4),
                  decoration: new BoxDecoration(
                      border: Border.all(
                          color: Color(ColorConsts.grayColor), width: 0.5),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(

                                child: Image.asset("assets/icons/raz.png",width: 70,height: 30,),
                              ),
                            ) ,
                            if(PaymentOption.contains("Razorpay"))Align(
                              alignment: Alignment.centerRight,
                              child: Container(

                                child: Image.asset("assets/icons/check.png",width: 25,height: 22,),
                              ),
                            )
                          ],
                        ),
                      ]),
                ),
                  onTap: () {
                    PaymentOption="Razorpay";
                    setState(() {

                    });
                  },
                ),
                if(hasData)if(modelSettings.data.PAYSTACK_DETAILS.PAYSTACK_STATUS.contains("1"))InkResponse(child: Container(
                  margin: EdgeInsets.fromLTRB(12, 18, 12, 0),
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(9, 4, 10, 4),
                  decoration: new BoxDecoration(
                      border: Border.all(
                          color: Color(ColorConsts.grayColor), width: 0.5),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(

                                child: Image.asset("assets/icons/Paystack.png",width: 75,height: 30,),
                              ),
                            ) ,
                            if(PaymentOption.contains("PayStack"))Align(
                              alignment: Alignment.centerRight,
                              child: Container(

                                child: Image.asset("assets/icons/check.png",width: 25,height: 25,),
                              ),
                            )
                          ],
                        ),
                      ]),
                ),
                  onTap: () {
                    PaymentOption="PayStack";
                    setState(() {

                    });
                  },
                ),
                if(hasData)if(modelSettings.data.STRIPE_DETAILS.STRIPE_STATUS.contains("1"))InkResponse(child: Container(
                  margin: EdgeInsets.fromLTRB(12, 18, 12, 0),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: new BoxDecoration(
                      border: Border.all(
                          color: Color(ColorConsts.grayColor), width: 0.5),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(

                                child: Image.asset("assets/icons/Stripe.png",width: 50,height: 17,),
                              ),
                            ) ,
                            if(PaymentOption.contains("Stripe"))Align(
                              alignment: Alignment.centerRight,
                              child: Container(

                                child: Image.asset("assets/icons/check.png",width: 25,height: 22,),
                              ),
                            )
                          ],
                        ),
                      ]),
                ),
                  onTap: () {
                    PaymentOption="Stripe";
                    setState(() {
                      
                    });
                  },
                ),
                if(hasData)if(modelSettings.data.PAYPAL_DETAILS.PAYPAL_STATUS.contains("1"))InkResponse(child: Container(
                  margin: EdgeInsets.fromLTRB(12, 18, 12, 0),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: new BoxDecoration(
                      border: Border.all(
                          color: Color(ColorConsts.grayColor), width: 0.5),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(

                                child: Image.asset("assets/images/paypal.png",width: 69,height: 19,),
                              ),
                            ) ,
                            if(PaymentOption.contains("paypal"))Align(
                              alignment: Alignment.centerRight,
                              child: Container(

                                child: Image.asset("assets/icons/check.png",width: 25,height: 22,),
                              ),
                            )
                          ],
                        ),
                      ]),
                ),
                  onTap: () {
                    PaymentOption="paypal";
                    setState(() {

                    });



                  },
                ),
                if(processed)Container(
                    alignment: Alignment.center,
                    child: Container(
                        alignment: Alignment.center,
                        height: 56,
                        margin: EdgeInsets.all(14),
                        width:  MediaQuery.of(context).size.width-45,
                        color: Color(ColorConsts.whiteColorTrans),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <
                              Widget>[
                            SizedBox(height: 20,width: 20,child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(ColorConsts.pinkLytColor)), backgroundColor: Color(ColorConsts.primaryColor), strokeWidth: 4.0)),
                            Container(
                                margin: EdgeInsets.all(5),
                                child: Text(
                                  Resource.of(context, tag!).strings.loadingPleaseWait,
                                  style: TextStyle(color: Color(ColorConsts.primaryColor), fontFamily: 'OpenSans-Bold', fontWeight: FontWeight.w500, fontSize: 18),
                                )),
                          ],
                        ))

                ),

                if(isPending)InkResponse(
                  onTap: () {

    if(_userLoginModel.data.address.isEmpty){
    Fluttertoast.showToast(
    msg: 'Complete address required for shipping!',
    toastLength: Toast.LENGTH_SHORT);
    }else{
    if(PaymentOption.isNotEmpty) {
    if(PaymentOption.contains("COD")){
    processed=true;
    setState(() {
    });
    orderPlace();
    }else {


    String paymentType=PaymentOption;
    if(paymentType=="Razorpay") {
    Navigator.pushReplacement(
    context,
    new MaterialPageRoute(
    builder: (context) =>
    Razorpayment(amountToBePaid, prodDetails),
    ),
    );
    }else{

    if(paymentType=="PayStack") {
    Navigator.pushReplacement(
    context,
    new MaterialPageRoute(
    builder: (context) =>
    PayStack(amountToBePaid, prodDetails),
    ),
    );
    }else{
    if(paymentType=="paypal"){
    if(_userLoginModel.data.postal_code.isEmpty || _userLoginModel.data.state.isEmpty || _userLoginModel.data.city.isEmpty || _userLoginModel.data.country.isEmpty){
    Fluttertoast.showToast(
    msg: 'Complete address field !',
    toastLength: Toast.LENGTH_SHORT);

    }else {
    Navigator.pushReplacement(
    context,
    new MaterialPageRoute(
    builder: (context) =>
    Paypal(amountToBePaid, prodDetails),
    ),
    );
    }
    }else {
    Navigator.pushReplacement(
    context,
    new MaterialPageRoute(
    builder: (context) =>
    StripePay(amountToBePaid, prodDetails),
    ),
    );
    }
    }
    }

    }
    }else{
    Fluttertoast.showToast(
    msg: 'Choose option for pay!',
    toastLength: Toast.LENGTH_SHORT);
    }

    }

                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
                    margin: EdgeInsets.fromLTRB(16,36, 16, 12),
                    height: 44,
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
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Text(
                      'Proceed Now',
                      style: TextStyle(
                          fontFamily: 'OpenSans-Bold',
                          fontWeight: FontWeight.w500,
                          fontSize: 15.5,
                          color: Color(ColorConsts.whiteColor)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    ));
  }
}
