import 'dart:async';
import 'dart:io';
import 'package:e_com/ui/BaseBottom.dart';
import 'package:e_com/ui/Login.dart';
import 'package:e_com/utils/AppConstant.dart';
import 'package:e_com/utils/SharedPref.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';




Future<void> main() async {

  runApp(const MyApp());
}





class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(child:MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:  ThemeData(

    unselectedWidgetColor: Color(ColorConsts.grayColor), // Your color
  ),
builder: (context, child) {
  return MediaQuery(

    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: child!,
  );
},
      home:  MySplash(),
    ));
  }
}
class MySplash extends StatefulWidget {





  @override
  State<StatefulWidget> createState() {
    return SplashScreen();
  }
}
class PushNotification {
  PushNotification({
    this.title,
    this.body,

  });

  String? title;
  String? body;

}
class SplashScreen extends State with TickerProviderStateMixin{
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;
  SharedPref sharePrefs = SharedPref();
  String? tag='';




  @override
  void initState() {
    checkForInitialMessage();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );

      setState(() {
        _notificationInfo = notification;

      });
    });
    super.initState();
    Timer(Duration(seconds: 4), () async {
      if(await sharePrefs.check()){
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => Base()));}else{
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => Login()));
      }

    });

  }


  checkForInitialMessage() async {

    try{

    if (Platform.isIOS)
    {
       await Firebase.initializeApp(options: FirebaseOptions(
       apiKey: "AIzaSyAUXv2qnpVfTZXCz--qI1oB819Q8jWqTck",
       appId: "1:837950643676:ios:36498c940354274ff10319",
       messagingSenderId: "837950643676",
       projectId: "appflutter-54b08")
       );


    }else{
      await Firebase.initializeApp();
    }
    }
    catch(e){
      print('exception   $e');
    }

    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.requestPermission(

      announcement: true,
      carPlay: true,
      criticalAlert: true,
      sound: true,
      alert: true,
      badge: true,
      provisional: false
    );

    if (initialMessage != null) {

      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;

      });
    }
  }

@override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    // Create an animation with value of type "double"


   return Scaffold(
       body: SafeArea(
       child: Container(
         height: MediaQuery.of(context).size.height,
         width: MediaQuery.of(context).size.width,
       decoration: BoxDecoration(
       image: DecorationImage(
       image: AssetImage("assets/images/background.jpg"),
       fit: BoxFit.cover),



    ),
child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.center,
children: [
   Image.asset('assets/images/logo.png',width: 120,height: 120,),/* Your widget here */


SizedBox(height: 20,),
  Text(AppConstant.appName  , style: TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color:Color(ColorConsts.whiteColor)
  )
)
],
),
       )
    )
   );
  }

}





