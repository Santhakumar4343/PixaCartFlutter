import 'dart:convert';

import 'package:e_com/localdb/AppDatabase.dart';
import 'package:e_com/localdb/ListEntity.dart';
import 'package:e_com/model/ModelSettings.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/presenter/Orderpresenter.dart';
import 'package:e_com/ui/BaseBottom.dart';
import 'package:e_com/utils/SharedPref.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

double mainAmount=0.0;
String amountToBePaid='';
String prod_details='',payment_details="[]";
String currencyCode = 'USD', currSym = '\$', tax = '';
class Paypal extends StatefulWidget{
  Paypal(String amount,String proDetails){
    mainAmount = double.parse(amount);
    amountToBePaid=amount;
    prod_details=proDetails;
  }

  @override
  State<StatefulWidget> createState() {
   return paypal();
  }

}
class paypal extends State {
  static String token = '';
  late ModelSettings modelSettings;
  late UserLoginModel _userLoginModel;
  SharedPref shareprefs = SharedPref();
  String clientId="";
  late final access;
  late final database;
  late List<ListEntity> cartList;
  String secretKey="";

  Future<dynamic> getValue() async {
    String? sett = await shareprefs.getSettings();
    _userLoginModel = await shareprefs.getLoginUserData();
    final Map<String, dynamic> parsed = json.decode(sett!);
    modelSettings = ModelSettings.fromJson(parsed);
    currencyCode = modelSettings.data.currency_code;
    clientId=""+modelSettings.data.PAYPAL_DETAILS.CLIENT_ID;
    secretKey=""+modelSettings.data.PAYPAL_DETAILS.SECRET_KEY;
    setState(() {});

    return token;
  }


  @override
  void initState() {
    getValue();
    super.initState();
  }
  Future<void> orderPlace() async {
    String res =await OrderPresenter().getOrderPlace(_userLoginModel.data.token, _userLoginModel.data.id,
        amountToBePaid, _userLoginModel.data.address+", "+_userLoginModel.data.city+", "+_userLoginModel.data.state,  _userLoginModel.data.address, 'PAYPAL', 1, prod_details, payment_details);
    if(res.contains("1")){
      //   isPending=false;
    }
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    access = database.daoaccess;
    cartList = await access.getAll();

    if(res.contains("1")){

      for(int i=0;i<cartList.length;i++){
        await  access.delete(""+cartList[i].variant_id);
      }



      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => Base(),
          ),
              (route) => false);


    }else{
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'Something went wrong at server end! Contact admin.',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Color(ColorConsts.whiteColor),
          fontSize: 14.0);
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
        child:Column(children: [
          InkResponse(child: Container(

      width: MediaQuery.of(context).size.width,
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
          'Pay Now',
          style: TextStyle(
              fontFamily: 'OpenSans-Bold',
              fontWeight: FontWeight.w600,
              fontSize: 15.5,
              color: Color(ColorConsts.whiteColor)),
        ),
    ),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) =>  UsePaypal(
                sandboxMode: true,
                clientId: clientId,
                secretKey:secretKey,
                returnURL: "https://samplesite.com/return",
                cancelURL: "https://samplesite.com/cancel",
                transactions:  [
                  {
                    "amount": {
                      "total": mainAmount,
                      "currency": currencyCode,
                      "details": {
                        "subtotal": mainAmount,
                        "shipping": '0',
                        "shipping_discount": 0
                      }
                    },
                    "description":
                    "Ecommerce app ot store",
                    // "payment_options": {
                    //   "allowed_payment_method":
                    //       "INSTANT_FUNDING_SOURCE"
                    // },
                    "item_list": {
                      "items": [
                        {
                          "name": "Order product",
                          "quantity": 1,
                          "price": mainAmount,
                          "currency": "$currencyCode"
                        }
                      ],

                      // shipping address is not required though
                      "shipping_address": {
                        "recipient_name": ""+_userLoginModel.data.fullname,
                        "line1": ""+_userLoginModel.data.address,
                        "line2": "",
                        "city": ""+_userLoginModel.data.city,
                        "country_code": ""+_userLoginModel.data.country,
                        "postal_code": ""+_userLoginModel.data.postal_code,
                        "phone": "+"+_userLoginModel.data.mobile,
                        "state": ""+_userLoginModel.data.state
                      },
                    }
                  }
                ],
                note: "Contact us for any questions on your order.",
                onSuccess: (Map params) async {
                  print("--onSuccess: $params");
                  print(params["paymentId"]);
                  payment_details="{\"payment_id\" : \""+params["paymentId"].toString()+"\"}";
                  /*{payerID: 33PE7FQHTUF58, paymentId: PAYID-MLQTEGQ0TV03409HA393510G, token: EC-6K763403N0379215L, status: success, data:
                                {id: PAYID-MLQTEGQ0TV03409HA393510G, intent: sale, state: approved, cart: 6K763403N0379215L, payer:
                                {payment_method: paypal, status: VERIFIED, payer_info: {email: sb-egqe37206913@personal.example.com, first_name: John, last_name: Doe, payer_id:
                                33PE7FQHTUF58, shipping_address: {recipient_name: Jane Foster, line1: Travis County, city: Austin, state: Texas, postal_code: 73301, country_code: US},
                                 country_code: US}}, transactions: [{amount: {total: 10.12, currency: USD, details:
                                  {subtotal: 10.12, shipping: 0.00, insurance: 0.00, handling_fee: 0.00, shipping_discount: 0.00, discount: 0.00}}, payee:
                                   {merchant_id: 42M3L2K3BPMJN, email: sb-hznpz3852855@business.example.com}, description: The payment transaction description., item_list:
                                    {items: [{name: A demo product, price: 10.12, currency: USD, tax: 0.00, quantity: 1}],
                                 shipping_address: {recipient_name: Jane Foster, line1: Travis Count*/
                  Fluttertoast.showToast(
                      msg: 'Successfully paid amount..',
                      toastLength: Toast.LENGTH_SHORT);
                  orderPlace();
                },
                onError: (error) {
                  print("onError: $error");
                  Fluttertoast.showToast(
                      msg: 'Error occur in payment !',
                      toastLength: Toast.LENGTH_SHORT);
                  Navigator.pop(context);
                },
                onCancel: (params) {
                  Fluttertoast.showToast(
                      msg: 'Cancelled',
                      toastLength: Toast.LENGTH_SHORT);
                  Navigator.pop(context);
                })
                ));
          },),


          InkResponse(onTap: () {
Navigator.pop(context);
          },
          child:
          Container(

            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
            margin: EdgeInsets.fromLTRB(16,36, 16, 0),
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
              'Cancel',
              style: TextStyle(
                  fontFamily: 'OpenSans-Bold',
                  fontWeight: FontWeight.w600,
                  fontSize: 15.5,
                  color: Color(ColorConsts.whiteColor)),
            ),
          ),)
        ],)
    )
    );

  }

}