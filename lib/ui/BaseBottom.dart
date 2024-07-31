import 'dart:io';

import 'package:e_com/ui/Category.dart';
import 'package:e_com/ui/Home.dart';
import 'package:e_com/ui/Menu.dart';
import 'package:e_com/ui/Profile.dart';
import 'package:e_com/utils/Resource.dart';
import 'package:e_com/utils/SharedPref.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';


class Base extends StatelessWidget {
  const Base({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        unselectedWidgetColor: Color(ColorConsts.blackColor), // Your color
      ),
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>  {

  SharedPref sharePrefs = SharedPref();
  String tag='en';
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  String _message = "Not Authorized";
  String err = '';
  bool canCheckBiometrics = false;
  Future<bool> checkingForBioMetrics() async {
    canCheckBiometrics = await _localAuthentication.canCheckBiometrics;

    _authenticateMe();
    return canCheckBiometrics;

  }

  Future<void> _authenticateMe() async {
// 8. this method opens a dialog for fingerprint authentication.
//    we do not need to create a dialog nut it popsup from device natively.
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Authenticate for Testing", // message for dialog
        useErrorDialogs: true, // show error in dialog
        stickyAuth: true, // native process
      );

      setState(() {
        _message = authenticated ? "Authorized" : "Not Authorized";
      });

    } catch (e) {
      err = e.toString().contains(',')
          ? e.toString().split(',')[0].replaceAll('PlatformException(', '') +
          ":" +
          e.toString().split(',')[1]
          : '';

      setState(() {});
    }
    if (!mounted) return;
  }
  Future<void> getValue() async {
    tag= (await sharePrefs.getLanguage())!;

    setState(() {
    });
  }
  @override
  void initState() {
    getValue();
    checkingForBioMetrics();
    super.initState();
  }

  int _selectedIndex = 0;

  static  List<Widget> _widgetOptions = <Widget>[
   new Home(),
   Profile(),
    Category(),
   Menu()

  ];
 /* Future<bool> isUpdate(BuildContext context) async {

    return (await showDialog(
        context: context,
        builder: (context) =>  AlertDialog(
        elevation: 5,
        contentPadding: EdgeInsets.all(0),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0))
    ),
    content:
    UpgradeCard(),

    )
    )
    );
  }*/

  Future<bool> isBack(BuildContext context) async {

    return (await showDialog(
      context: context,
      builder: (context) =>  AlertDialog(
        elevation: 5,
        contentPadding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
        content: Container(
          height: 149,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(ColorConsts.primaryColor),
                  Color(ColorConsts.secondaryColor)

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
         child:  Align(
            alignment: Alignment.centerLeft,
            child: Stack(
              children: [

              Align(alignment: Alignment.center,
                child: Container(

                    margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Container(
                      padding: EdgeInsets.all(2),
                    width: 65,
                    height:100,
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(12, 0, 0, 0),child: Image.asset(
                    'assets/images/logo.png',
                    width: 78,
                    height: 78,

                  ),
                    ),
                    Align(child: Container(
                      width: 165,
                      height:187,
                        margin: EdgeInsets.fromLTRB(16, 12, 7, 0),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child:  Column(
                        children: [Text(Resource.of(context,tag).strings.ExitTheApp,
                        maxLines: 3,style: TextStyle(fontFamily: 'OpenSans-Bold',fontWeight: FontWeight.w500,fontSize:17
                            ,color: Color(ColorConsts.whiteColor)),),

                        Stack(children: [
                          Align(alignment: Alignment.centerLeft,child: InkResponse(
                            onTap : () {

                              if (Platform.isAndroid) {
                                SystemNavigator.pop();
                              } else {
                                exit(0);
                              }
                            }, // passing true
                            child: Container(
                                margin: EdgeInsets.fromLTRB(0, 16, 6, 0),
                                padding: EdgeInsets.fromLTRB(22, 7, 22, 7),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(ColorConsts.whiteColor),
                                        Color(ColorConsts.whiteColor)

                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Text(
                                  Resource.of(context,tag).strings.yes,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans-Bold',
                                      fontSize: 14.0,
                                      color: Color(ColorConsts.primaryColor)
                                  ),
                                )),
                          ),),
                          Align(alignment: Alignment.centerRight,child:   InkResponse(
                            onTap: () =>
                                Navigator.pop(context, false), // passing false
                            child: Container(
                                margin: EdgeInsets.fromLTRB(0, 16,7, 0),
                                padding: EdgeInsets.fromLTRB(22, 7, 22, 7),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [

                                        Color(ColorConsts.secondaryBtnColor),
                                        Color(ColorConsts.secondaryBtnColor),

                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Text(
                                  Resource.of(context,tag).strings.no
                                  ,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans-Bold',
                                      fontSize: 14.0,
                                      color: Color(ColorConsts.whiteColor)),
                                )),
                          ) ,)
                        ],)



                      ],)
                    ),) ,
                  ],)
                ),
              ),

            Align(alignment: Alignment.topRight,child: InkResponse(child:  Container(
                  width: 24,
                  alignment: Alignment.topRight,
                  child: Icon(Icons.clear,color: Color(ColorConsts.whiteColor),size: 20),
                ),onTap:(){
                  Navigator.pop(context, false);
                } ,)
            )

              ],)
        ),),




      ),
    )) ??
        false;

  }

  @override
  void dispose() {


  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black
    ));

    //isUpdate(context);
    return WillPopScope(

        onWillPop: () async {

          return isBack(context);
        }, child:SafeArea(child:Scaffold(


resizeToAvoidBottomInset: true,
      body:  Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      bottomNavigationBar: Material(

        elevation: 7,child: Container(
padding: (Platform.isIOS)?EdgeInsets.fromLTRB(0, 0, 0, 12):EdgeInsets.fromLTRB(0, 0, 0, 0),

        height:60,
        alignment: Alignment.topCenter,

        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
           InkResponse(child: Stack(children: [

             if(_selectedIndex==0)Align(alignment: Alignment.topCenter,child:Container(
               width: 60,
               child: Image.asset('assets/images/drop.png',height: 10,width: 30,),)
               ,) ,
             Align(alignment: Alignment.bottomCenter,child: Container(
               width: 60,
               margin: EdgeInsets.fromLTRB(0, 3, 0, 4.5),
               child:Text(
                   Resource.of(context,"en").strings.Home,textAlign: TextAlign.center,
                   maxLines: 1,
               style: TextStyle(
                   fontFamily: 'OpenSans',
                   fontSize: 13,
                   fontWeight: FontWeight.w500,
                   color: (_selectedIndex==0)?Color(ColorConsts.primaryColor):Color(ColorConsts.grayColor)
               )
               ),


             ),),
             Align(child:Container(
                 margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
               width: 60,
             child: Image.asset('assets/icons/home.png',height: 18,color:(_selectedIndex==0)?Color(ColorConsts.primaryColor):Color(ColorConsts.grayColor))
             )
               ,) ,
           ],) ,
           onTap: () {
             setState(() {
               _selectedIndex=0;
             });

           },),


            InkResponse(child:  Stack(children: [

             if(_selectedIndex==1)Align(alignment: Alignment.topCenter,child:Container(

               width: MediaQuery.of(context).size.width/4,
                child: Image.asset('assets/images/drop.png',height: 10,width: 30,),)
                ,) ,
              Align(alignment: Alignment.bottomCenter,child: Container(
                width: MediaQuery.of(context).size.width/4,
                margin: EdgeInsets.fromLTRB(0, 3, 0, 4.5),
                child:Text(

                    Resource.of(context,tag).strings.profile,
                    maxLines: 1,textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: (_selectedIndex==1)?Color(ColorConsts.primaryColor):Color(ColorConsts.grayColor)
                    )
                ),


              ),),
              Align(child:Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 6.9),
                width: MediaQuery.of(context).size.width/4,
                child: Image.asset('assets/icons/user.png',height: 17, color: (_selectedIndex==1)?Color(ColorConsts.primaryColor):Color(ColorConsts.grayColor)),)
                ,) ,
            ],) ,
               onTap: () {

                 setState(() {
                   _selectedIndex=1;
                 });
               }, ),
            InkResponse(child: Stack(children: [

              if(_selectedIndex==2)Align(alignment: Alignment.topCenter,child:Container(
                width: MediaQuery.of(context).size.width/4,
                child: Image.asset('assets/images/drop.png',height: 10,width: 30,),)
                ,) ,
              Align(alignment: Alignment.bottomCenter,child: Container(
                width: MediaQuery.of(context).size.width/4,
                margin: EdgeInsets.fromLTRB(0, 3, 0, 4.5),
                child:Text(

                    'Categories', maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: (_selectedIndex==2)?Color(ColorConsts.primaryColor):Color(ColorConsts.grayColor)
                    )
                ),


              ),),
              Align(alignment: Alignment.center,child:Container(alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/4,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
                  child: Image.asset('assets/icons/category.png',height: 17,color: (_selectedIndex==2)?Color(ColorConsts.primaryColor):Color(ColorConsts.grayColor)))
                ,) ,
            ],)
              ,
            onTap: () {

              setState(() {
                _selectedIndex=2;
              });
            },),
            InkResponse(
              child: Stack(children: [

              if(_selectedIndex==3)Align(alignment: Alignment.topCenter,child:Container(

                width: 60,
                child: Image.asset('assets/images/drop.png',height: 10,width: 30,),)
                ,) ,
              Align(alignment: Alignment.bottomCenter,child: Container(
                width: 60,
                margin: EdgeInsets.fromLTRB(0, 4, 0, 4.5),
                child:Text(
                    Resource.of(context,tag).strings.Menu,textAlign: TextAlign.center,
                    maxLines: 1,

                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: (_selectedIndex==3)?Color(ColorConsts.primaryColor):Color(ColorConsts.grayColor)
                    )
                ),


              ),),
              Align(alignment: Alignment.center,child:Container(alignment: Alignment.center,
                width: 60,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
                child: Image.asset('assets/icons/Menu.png',height: 15,color: (_selectedIndex==3)?Color(ColorConsts.primaryColor):Color(ColorConsts.grayColor)
                  ,)
              )
                ,) ,
            ],) ,
                onTap: () {

                  setState(() {
                    _selectedIndex=3;
                  });
                },)



        ],)

      )
        ,)
    )
    )
    );
  }
}
