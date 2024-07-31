import 'ModelSettings.dart';
import 'ModelSettings.dart';

class ModelSettings {
  int status;
  String message;
  ModelSettingsData data;
  ModelSettings(this.status, this.message ,this.data);


  factory ModelSettings.fromJson(Map<dynamic, dynamic> json) {

    return ModelSettings(json['status'], json['message'],new ModelSettingsData.fromJson(json['data']));
  }

}

class ModelSettingsData {


  String RAZORPAY_KEY ="";
  String RAZORPAY_SECRET ="";
  String currency_code ="";
  String currency_symbol ="";
  int notifications_count ;
  int wishlist_count;
  int myorder_count;
  String privacy_policy_page;
  String support_contact_number;
  String cod_status="";
  STRIPEDETAILS STRIPE_DETAILS;
  PAYSTACKDETAILS PAYSTACK_DETAILS;
  RAZORPAYDETAILS RAZORPAY_DETAILS;
  PAYPALDETAILS PAYPAL_DETAILS;


  ModelSettingsData(this.RAZORPAY_KEY, this.RAZORPAY_SECRET, this.currency_code,
      this.currency_symbol,this.notifications_count,this.wishlist_count,this.myorder_count,this.privacy_policy_page,this.support_contact_number
      ,this.cod_status,this.STRIPE_DETAILS,this.PAYSTACK_DETAILS,this.RAZORPAY_DETAILS,this.PAYPAL_DETAILS);

  factory ModelSettingsData.fromJson(Map<String, dynamic> json) {
    return ModelSettingsData(json['RAZORPAY_KEY'],json['RAZORPAY_SECRET'],json['currency_code']
        ,json['currency_symbol']
        ,json['notifications_count']
        ,json['wishlist_count']
        ,json['myorder_count']
        ,json['privacy_policy_page'] ?? ''
        ,json['support_contact_number'] ?? ''
        ,json['cod_status'] ?? ''
        ,new STRIPEDETAILS.fromJson(json['STRIPE_DETAILS'])
        ,new PAYSTACKDETAILS.fromJson(json['PAYSTACK_DETAILS']),new RAZORPAYDETAILS.fromJson(json["RAZORPAY_DETAILS"])
        ,new PAYPALDETAILS.fromJson(json['PAYPAL_DETAILS'])

    );
  }

}
class PAYSTACKDETAILS{
  String PAYSTACK_STATUS='';
  String PUBLIC_KEY='';
  String SECRET_KEY='';

  PAYSTACKDETAILS(this.PAYSTACK_STATUS, this.PUBLIC_KEY, this.SECRET_KEY);
  factory PAYSTACKDETAILS.fromJson(Map<String,dynamic> json){
    return PAYSTACKDETAILS(json['PAYSTACK_STATUS'] ?? '', json['PUBLIC_KEY'] ?? '', json['SECRET_KEY'] ?? '');
  }

}

class PAYPALDETAILS{
  String PAYPAL_STATUS='';
  String CLIENT_ID='';
  String SECRET_KEY='';

  PAYPALDETAILS(this.PAYPAL_STATUS, this.CLIENT_ID, this.SECRET_KEY);
  factory PAYPALDETAILS.fromJson(Map<String,dynamic> json){
    return PAYPALDETAILS(json['PAYPAL_STATUS'] ?? '', json['CLIENT_ID'] ?? '', json['SECRET_KEY'] ?? '');
  }

}
class RAZORPAYDETAILS{
  String status='';
  String RAZORPAY_KEY='';
  String RAZORPAY_SECRET='';

  RAZORPAYDETAILS(this.status, this.RAZORPAY_KEY, this.RAZORPAY_SECRET);
  factory RAZORPAYDETAILS.fromJson(Map<String,dynamic> json){
    return RAZORPAYDETAILS(json['status'] ?? '', json['RAZORPAY_KEY'] ?? '', json['RAZORPAY_SECRET'] ?? '');
  }
}
class STRIPEDETAILS {
  String STRIPE_STATUS='';
  String PUBLIC_KEY='';
  String SECRET_KEY='';
  String MERCHANT_NAME='';
  String MERCHANT_COUNTRY_CODE='';
  String MERCHANT_IDENTIFIER='';

  STRIPEDETAILS(this.STRIPE_STATUS, this.PUBLIC_KEY, this.SECRET_KEY,
      this.MERCHANT_NAME, this.MERCHANT_COUNTRY_CODE,this.MERCHANT_IDENTIFIER);
  factory STRIPEDETAILS.fromJson(Map<String,dynamic> json){
    return STRIPEDETAILS(
      json['STRIPE_STATUS'] ?? '',
      json['PUBLIC_KEY'] ?? '',
      json['SECRET_KEY'] ?? '',
      json['MERCHANT_NAME'] ?? '',
      json['MERCHANT_COUNTRY_CODE'] ?? '',
      json['MERCHANT_IDENTIFIER'] ?? ''

    ) ;

  }

}



