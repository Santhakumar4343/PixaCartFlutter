import 'package:e_com/presenter/ForgotPassPresenter.dart';
import 'package:e_com/utils/Resource.dart';
import 'package:e_com/utils/AppConstant.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/SharedPref.dart';
import 'Login.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool monVal = false,isvalidate=false;
  bool _passwordVisible = false;
  String version = '';
  String buildNumber = '';




  SharedPref sharePrefs = SharedPref();

  String? tag='';

  Future<void> getValue() async {
    tag= await sharePrefs.getLanguage();
    setState(() {
    });
  }


Future<void> forgotAPICall() async {
 String res=await ForgotPassPresenter().getForgPass(context, emailController.text,passwordController.text);
 isvalidate=true;
if(!res.isEmpty){
  if(!res.contains("The account Found")) {
    isvalidate = false;
    emailController.text = '';
    passwordController.text = '';
  }
setState(() {

});
}
  }

  @override
  void initState() {
    getValue();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage("assets/images/background.jpg"),
    fit: BoxFit.cover),
    ),
            padding: EdgeInsets.fromLTRB(2, 20, 2, 0),
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(padding: EdgeInsets.all(9)
              ,child: Image.asset('assets/images/logo.png',width: 40,height: 45,),),
            Text(AppConstant.appName  , style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color:Color(ColorConsts.whiteColor)
            ),
            )
            ],)

          ,
                Container(
                  margin: EdgeInsets.fromLTRB(6, 12, 6, 6),
                  child: Text(
                    Resource.of(context,tag!).strings.forgotPasswordQ,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
letterSpacing: 1.0,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Color(ColorConsts.whiteColor)
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(6, 0, 6, 12),
                  child: Text(
                    '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 23,
                        color: Color(ColorConsts.whiteColor)
                    ),
                  ),
                ),
           Stack(

             children: [
             Container(
               padding: EdgeInsets.fromLTRB(16, 12, 16, 56),
               margin: EdgeInsets.fromLTRB(30, 22, 30, 0),
               decoration: new BoxDecoration(
                   gradient: LinearGradient(
                     colors: [
                       Color(0x32FFFFFF),
                       Color(0x32FFFFFF)
                     ],
                     begin: Alignment.centerLeft,
                     end: Alignment.centerRight,
                   ),
                   borderRadius: BorderRadius.circular(15.0)),),


             Container(

                 padding: EdgeInsets.fromLTRB(16, 12, 16, 80),
                 margin: EdgeInsets.fromLTRB(15, 35, 15, 36),
                 decoration: new BoxDecoration(
                     gradient: LinearGradient(
                       colors: [
                         Color(ColorConsts.whiteColor),
                         Color(ColorConsts.whiteColor)
                       ],
                       begin: Alignment.centerLeft,
                       end: Alignment.centerRight,
                     ),
                     borderRadius: BorderRadius.circular(15.0)),
                 child: Column(

                   children: [
                 Container(
                 margin: EdgeInsets.fromLTRB(15, 22, 15, 20),child:  Text(
                 (isvalidate)?'Enter new password below that associate with account '+emailController.text: Resource.of(context,tag!).strings.chnagePassDesc,
                       style: TextStyle(
                           fontFamily: 'OpenSans',
                           fontSize: 17,
                           color: Color(ColorConsts.grayColor)),
                     ),
                 ),

                     if(!isvalidate)Container(
                       margin: EdgeInsets.fromLTRB(15, 22, 15, 0),
                       alignment: Alignment.centerLeft,child: Text(Resource.of(context,tag!).strings.emailPhone,textAlign: TextAlign.left,
                         style: TextStyle(
                             fontFamily: 'OpenSans.ttf',
                             fontSize: 17,
                             color: Color(ColorConsts.grayColor))),) ,
                     if(!isvalidate) Container(
                       height: 40,

                       margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                       decoration: new BoxDecoration(
                           gradient: LinearGradient(
                             colors: [
                               Color(ColorConsts.whiteColor),
                               Color(ColorConsts.whiteColor)
                             ],
                             begin: Alignment.centerLeft,
                             end: Alignment.centerRight,
                           ),
                           borderRadius: BorderRadius.circular(30.0)),
                       child: new TextField(
                         keyboardType: TextInputType.emailAddress,

                         style: TextStyle(
                             color: Color(ColorConsts.blackColor),
                             fontSize: 17.0,
                             fontFamily: 'OpenSans'),
                         controller: emailController,
                         decoration: new InputDecoration(
                           suffixIcon: Image.asset(
                             'assets/icons/mail.png',
                             height: 5.0,
                             width: 5.0,
                           ),
                           suffixIconConstraints:
                           BoxConstraints(minHeight: 18, minWidth: 19),
                           hintText:
                           Resource.of(context,tag!).strings.enterEmailPhoneHere,
                           hintStyle: TextStyle(
                               fontFamily: 'OpenSans',
                               fontSize: 16.0,
                               color: Color(ColorConsts.lightGrayColor)),
border: InputBorder.none
                         ),
                       ),
                     ),
                     if(!isvalidate)Container(
                       margin: EdgeInsets.fromLTRB(15, 0, 15, 4),
                       height: 0.5,
                       color: Color(ColorConsts.lightGrayColor),
                     ),

                     if(isvalidate) Container(
                       margin: EdgeInsets.fromLTRB(15, 22, 14, 0),
                       alignment: Alignment.centerLeft,
                       child: Text(
                           "New Password",
                           textAlign: TextAlign.left,
                           style: TextStyle(
                               fontFamily: 'OpenSans.ttf',
                               fontSize: 17,
                               color: Color(ColorConsts.grayColor))),
                     ),
                     if(isvalidate) Stack(
                       children: [
                         Container(
                           height: 40,
                           margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                           child: TextField(
                             obscureText: !_passwordVisible,
                             controller: passwordController,
                             style: TextStyle(
                                 color: Color(ColorConsts.blackColor),
                                 fontSize: 17.0,
                                 fontFamily: 'OpenSans'),
                             decoration: new InputDecoration(
                               hintText: 'Enter new password here',
                               hintStyle: TextStyle(
                                   fontFamily: 'OpenSans',
                                   fontSize: 15.5,
                                   color: Color(
                                       ColorConsts.lightGrayColor)),
                               suffixIcon: IconButton(
                                   icon: _passwordVisible
                                       ? Image.asset(
                                     'assets/icons/eyeicon.png',
                                     width: 19,
                                     height: 19,
                                   )
                                       : Image.asset(
                                     'assets/icons/eyeshow.png',
                                     width: 19,
                                     height: 19,
                                   ),
                                   onPressed: () {
                                     // Update the state i.e. toogle the state of passwordVisible variable
                                     if (_passwordVisible) {
                                       _passwordVisible = false;
                                     } else {
                                       _passwordVisible = true;
                                     }
                                     setState(() {});
                                   }),
                               border: InputBorder.none,
                             ),
                           ),
                         ),

                       ],
                     ),
                     if(isvalidate) Container(
                       margin: EdgeInsets.fromLTRB(15, 0, 15, 4),
                       height: 0.5,
                       color: Color(ColorConsts.lightGrayColor),
                     ),



                     Container(
                       width: MediaQuery.of(context).size.width,
                       margin: EdgeInsets.fromLTRB(10, 22, 10, 20),
                       decoration: BoxDecoration(
                           gradient: LinearGradient(
                             colors: [
                               Color(ColorConsts.primaryColor),
                               Color(ColorConsts.secondaryColor)
                             ],
                             begin: Alignment.centerLeft,
                             end: Alignment.centerRight,
                           ),
                           borderRadius: BorderRadius.circular(30.0)),
                       child: TextButton(

                           child: Text(
                             Resource.of(context,tag!).strings.resetMyPass,
                             style: TextStyle(
                                 fontFamily: 'OpenSans',
                                 fontSize: 18,
                                 fontWeight: FontWeight.w600,
                                 color: Color(0xffffffff)),
                           ),
                           onPressed: () => {

                             if (emailController.text.isEmpty)
                               {
                                 Fluttertoast.showToast(
                                     msg:  Resource.of(context,tag!).strings.enterUserEmailContinue,
                                     toastLength: Toast.LENGTH_SHORT,
                                     timeInSecForIosWeb: 1,
                                     backgroundColor: Colors.grey,
                                     textColor: Color(ColorConsts.whiteColor),
                                     fontSize: 14.0),
                               }
                             else
                               {

forgotAPICall(),


                               }}
                       ),
                     ),
                     Container(

                         margin: EdgeInsets.fromLTRB(15, 11, 15, 10),
                         child:



                             Align(alignment: Alignment.center, child:  InkResponse(
                               onTap: () {
                                 Navigator.of(context).pushReplacement(
                                     MaterialPageRoute(builder: (BuildContext context) => Login()));
                               },

                               child:Container(
                               height: 45,
                               alignment: Alignment.center,
                               margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.center,children: [
                                 Image.asset('assets/icons/Arrow.png',width: 15,height: 14,color:Color(ColorConsts.primaryColor) ,),
                                 Text('  Back to Login page',
                                       style: TextStyle(
                                           fontFamily: 'OpenSans',
                                           fontSize: 16,
                                           fontWeight: FontWeight.w500,
                                           color: Color(ColorConsts.primaryColor))),

                               ],)
                               ),
                             )
                               ,)




                         ),







                   ],)
             ),
           ],)




              ],
            )));
  }
}


