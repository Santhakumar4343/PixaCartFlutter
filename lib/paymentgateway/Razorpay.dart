import 'dart:async';
import 'dart:convert';
import 'package:e_com/localdb/AppDatabase.dart';
import 'package:e_com/localdb/ListEntity.dart';
import 'package:e_com/ui/MyCart.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:e_com/model/ModelSettings.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/presenter/Orderpresenter.dart';
import 'package:e_com/ui/PaymentMethod.dart';
import 'package:e_com/utils/SharedPref.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

String orderid = '', paymentid = '';
double amountPlan = 0, mainAmount = 0, exactPlanAmount = 0;
String CurrencyCode = 'USD', currSym = '\$', tax = '';
String coupon_id = '';
String discount = '', name = '', email = '';
String prod_details='',payment_details="[]";


class Razorpayment extends StatefulWidget {
  Razorpayment(String amountToBePaid, String prodDetails) {
    amountPlan = double.parse(amountToBePaid);
    mainAmount = double.parse(amountToBePaid);
    prod_details=prodDetails;
  }

  @override
  State<StatefulWidget> createState() {
    return MyState();
  }
}

class MyState extends State {
  static const platform = const MethodChannel("razorpay_flutter");
  SharedPref shareprefs = SharedPref();
  late Razorpay _razorpay;
  static String token = '';
  late ModelSettings modelSettings;

  late UserLoginModel _userLoginModel;
  late final access;
  late final database;
  late List<ListEntity> cartList;



  Future<void> orderPlace() async {
    String res =await OrderPresenter().getOrderPlace(_userLoginModel.data.token, _userLoginModel.data.id, amountToBePaid, _userLoginModel.data.address,  _userLoginModel.data.address, 'RAZORPAY', 1, prodDetails, payment_details);
    if(res.contains("1")){
   //   isPending=false;
    }
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    access = database.daoaccess;
    cartList = await access.getAll();

    if(res.contains("1")){

      for(int i=0;i<cartList.length;i++){
      await  access.delete(""+cartList[i].variant_id);
      shareprefs.deleteData(""+cartList[i].variant_id);
      }
      slideSheet('s');
    }else{
      setState(() {

      });
      Fluttertoast.showToast(
          msg: 'Something went wrong at server end !',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Color(ColorConsts.whiteColor),
          fontSize: 14.0);
    }
  }
  void slideSheet(String s) {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
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
                  Text(    (PaymentOption.contains("COD"))?"Order placed Successfully":'You Paid '+currSym+'$amountToBePaid Successfully...'+"\nPayment ID : "+paymentid,
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      InkResponse(onTap: () {
                     Navigator.pop(context);
                    // Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => MyCart(),
                          ),
                        );
                      },child: Container(

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
                          'Continue to shopping ',
                          style: TextStyle(
                              fontFamily: 'OpenSans-Bold',
                              fontSize: 19,
                              color: Color(ColorConsts.whiteColor)),
                        ),
                      ),
                      )
                    ],
                  )
                ]),
              ),
            );
          });
        });
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Color(ColorConsts.whiteColor),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
child: Text(''+paymentid,style: TextStyle(fontSize: 18,color: Color(ColorConsts.blackColor)),),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.fromLTRB(8, 26, 6, 6),
                child: InkResponse(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => PaymentMethod(amountToBePaid.toString(), ""),
                        ),
                      );
                    },
                    child: Image.asset('assets/icons/Arrow.png',
                        width: 19,
                        height: 25,
                        color: Color(ColorConsts.primaryColor))),
              ),
            ),  InkResponse(onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                  builder: (context) => MyCart(),
                ),
              );
            },child: Container(

              height: 45,
              padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(16, 196, 16, 0),
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
                ' Continue to shopping ',
                style: TextStyle(
                    fontFamily: 'OpenSans-Bold',
                    fontSize: 16,
                    color: Color(ColorConsts.whiteColor)),
              ),
            ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getSettings() async {
    CurrencyCode = modelSettings.data.currency_code;
    currSym = modelSettings.data.currency_symbol;
    if (modelSettings.data.RAZORPAY_KEY.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Payment details not set up by admin!!',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Color(ColorConsts.whiteColor),
          fontSize: 14.0);
      Navigator.pop(context);
    } else {
      _razorpay = Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      amountPlan = amountPlan * 100;

      openCheckout("Shop" , '' + amountPlan.round().toString(),
          modelSettings.data.RAZORPAY_KEY);
      setState(() {});
    }
  }

  Future<dynamic> value() async {
    String? sett = await shareprefs.getSettings();
    _userLoginModel = await shareprefs.getLoginUserData();
    final Map<String, dynamic> parsed = json.decode(sett!);
    modelSettings = ModelSettings.fromJson(parsed);
    CurrencyCode = modelSettings.data.currency_code;

    setState(() {});
    getSettings();
    return token;
  }

  @override
  void initState() {
    super.initState();
    value();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(String planName, String amount, String key) async {
    var options = {
      'key': key,
      'amount': amount,
      "currency": CurrencyCode,
      "base_currency": CurrencyCode,
      'name': 'Miraculos',
      'description': planName,
      'image': 'https://razorpay.com/assets/razorpay-glyph.svg',
      'prefill': {
        'contact': _userLoginModel.data.mobile,
        'email': _userLoginModel.data.email
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {}
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    payment_details="{\"payment_id\" : \""+response.paymentId.toString()+"\"}";
    paymentid=response.paymentId.toString();

   orderPlace();

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: 'Cancel Payment!', toastLength: Toast.LENGTH_SHORT);
    Navigator.pop(context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
    Navigator.pop(context);
  }
}
