import 'dart:convert';
import 'package:e_com/localdb/AppDatabase.dart';
import 'package:e_com/localdb/ListEntity.dart';
import 'package:e_com/model/ModelSettings.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/presenter/Orderpresenter.dart';
import 'package:e_com/ui/BaseBottom.dart';
import 'package:e_com/utils/SharedPref.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

double mainAmount=0.0;
String amountToBePaid='';
String prod_details='',payment_details="[]";
String CurrencyCode = 'USD', currSym = '\$', tax = '';
class StripePay extends StatefulWidget {
   StripePay(String amount,String proDetails) {
     mainAmount = double.parse(amount);
     amountToBePaid=amount;
     prod_details=proDetails;
   }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<StripePay> {
  late ModelSettings modelSettings;
  late final access;
  late final database;
  SharedPref shareprefs = SharedPref();
  late List<ListEntity> cartList;
  late UserLoginModel _userLoginModel;
  bool hasData=false,payLoading=false;
  String secretKey='';
  Map<String, dynamic>? paymentIntentData;

  getValue() async {
    String? sett = await shareprefs.getSettings();
    _userLoginModel = await shareprefs.getLoginUserData();
    final Map<String, dynamic> parsed = json.decode(sett!);
    modelSettings = ModelSettings.fromJson(parsed);
    CurrencyCode = modelSettings.data.currency_code;
if(amountToBePaid.isNotEmpty){
  double amount=double.parse(amountToBePaid);
  amountToBePaid=amount.round().toString();
}

     secretKey=""+modelSettings.data.STRIPE_DETAILS.SECRET_KEY;
//String secretKey="pk_test_51LD6HPH9ITrLMW64vecBKtdSp8vcnimpVTA9L8iB2e5SgR2skTKPABHvfANXqNfS7JhHiwbdeiEvME9vUMg1zgc100LeTHwtmg";
    WidgetsFlutterBinding.ensureInitialized();
// Stripe.publishableKey = 'pk_test_51Hr0lQId6YLh7uxZp7PTv1S02Al8XFI3G3bDJrPrGZiqB4YMyO0RigMTVSsEfR8pzYyvGiYD1rzwVdwXZeQrdqHU00QQAR8wxK';
    Stripe.publishableKey = ""+modelSettings.data.STRIPE_DETAILS.PUBLIC_KEY;
    Stripe.merchantIdentifier = modelSettings.data.STRIPE_DETAILS.MERCHANT_IDENTIFIER;

    await Stripe.instance.applySettings();

    hasData=true;
    setState(() {});

    await makePayment();
  }



  @override
  void initState() {
    getValue();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: (hasData && payLoading)?InkWell(
          onTap: ()async{
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => Base(),
                ),
                    (route) => false);},
          child: Container(
            height: 50,
            width: 210,
            color: Color(ColorConsts.primaryColor),
            child: Center(
              child: Text('Start Shopping again' , style: TextStyle(color: Colors.white , fontSize: 20),),
            ),
          ),
        ):Container(
          child: CircularProgressIndicator(
              valueColor:
              AlwaysStoppedAnimation(
                  Color(ColorConsts
                      .primaryColor)),
              backgroundColor: Color(
                  ColorConsts
                      .primaryColorLyt),
              strokeWidth: 2.0),

        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {

      paymentIntentData =
      await createPaymentIntent(''+amountToBePaid, ""+CurrencyCode); //json.decode(response.body);

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              style: ThemeMode.dark,
              merchantDisplayName: modelSettings.data.STRIPE_DETAILS.MERCHANT_NAME)).then((value){
      });


      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cancel Payment! Error")));
      Navigator.pop(context);
    }
  }

  displayPaymentSheet() async {

    try {
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
            clientSecret: paymentIntentData!['client_secret'],
            confirmPayment: true,
          )).then((newValue){


        print('payment intent'+paymentIntentData!['id'].toString());
        print('payment intent'+paymentIntentData!['client_secret'].toString());
        print('payment intent'+paymentIntentData!['amount'].toString());
        print('payment intent'+paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("paid successfully")));
        payment_details="{\"payment_id\" : \""+paymentIntentData!['id'].toString()+"\"}";
        orderPlace();
        paymentIntentData = null;

      }).onError((error, stackTrace){
        print('-------------    $error   -------');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cancel Payment!")));
        Navigator.pop(context);
      });


    } on StripeException catch (e) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      print('$e');
    }
  }

  Future<void> orderPlace() async {
    payLoading=true;
    setState(() {

    });
    String res =await OrderPresenter().getOrderPlace(_userLoginModel.data.token, _userLoginModel.data.id,
        amountToBePaid, _userLoginModel.data.address,  _userLoginModel.data.address, 'STRIPE', 1, prod_details, payment_details);
    if(res.contains("1")){
      //   isPending=false;
    }
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    access = database.daoaccess;
    cartList = await access.getAll();

    if(res.contains("1")){
      for(int i=0;i<cartList.length;i++){
        await  access.delete(""+cartList[i].regno.toString());

      }


      payLoading=false;

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



  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(''+amountToBePaid),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer '+secretKey,
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100 ;
    return a.toString();
  }

}
