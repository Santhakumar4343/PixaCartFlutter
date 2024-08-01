import 'dart:convert';
import 'dart:io';
import 'package:e_com/localdb/AppDatabase.dart';
import 'package:e_com/localdb/ListEntity.dart';
import 'package:e_com/presenter/Orderpresenter.dart';
import 'package:e_com/ui/BaseBottom.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_com/model/ModelSettings.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/utils/SharedPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

double mainAmount=0.0;
String amountToBePaid='';
String prod_details='',payment_details="[]";
class PayStack extends StatefulWidget {

  PayStack(String amount, String prodDetails) {

    mainAmount = double.parse(amount);
    amountToBePaid=amount;
    prod_details=prodDetails;
  }



  @override
  _PayStackState createState() => _PayStackState();


}
  class _PayStackState extends State<PayStack> {
    late UserLoginModel _userLoginModel;
    SharedPref shareprefs = SharedPref();
    final plugin = PaystackPlugin();
    String paystackPublicKey = '';
    late ModelSettings modelSettings;
    late final access;
    late final database;
    late List<ListEntity> cartList;

  @override
  Widget build(BuildContext context) {
    return Container();
  }


    @override
    void initState() {
      super.initState();
      value();
    }

    value() async {
      _userLoginModel = await shareprefs.getLoginUserData();
      String? sett = await shareprefs.getSettings();

      final Map<String, dynamic> parsed = json.decode(sett!);

      modelSettings = ModelSettings.fromJson(parsed);
      if (modelSettings.data.PAYSTACK_DETAILS.PUBLIC_KEY.isEmpty) {

        Fluttertoast.showToast(
            msg: 'Payment details not set up by admin!!',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Color(ColorConsts.whiteColor),
            fontSize: 14.0);
      }else {
        paystackPublicKey=""+modelSettings.data.PAYSTACK_DETAILS.PUBLIC_KEY;
        await plugin.initialize(publicKey: paystackPublicKey);
        initPay();
      }
    }



    Future<void> orderPlace() async {
      String res =await OrderPresenter().getOrderPlace(_userLoginModel.data.token, _userLoginModel.data.id,
          amountToBePaid, _userLoginModel.data.address,  _userLoginModel.data.address, 'PAYSTACK', 1, prod_details, payment_details);
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

  initPay() async {

    int amt=int.parse(mainAmount.round().toString());
    amt=amt*100;

    Charge charge = Charge()
      ..amount = amt
      ..reference = _getReference()
    // or ..accessCode = _getAccessCodeFrmInitialization()
      ..email = ''+_userLoginModel.data.email;
    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charge,
    );

    bool status=response.status;
    if(status){

      payment_details="{\"payment_id\" : \""+response.reference.toString()+"\"}";
    //  paymentid=response.paymentId.toString();
      orderPlace();

    }else{
      Navigator.pop(context);

    }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }


  }