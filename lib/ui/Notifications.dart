import 'package:e_com/model/ModelNoti.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/presenter/NotiPresenter.dart';
import 'package:e_com/presenter/PaymetDetailPresenter.dart';
import 'package:e_com/utils/ConnectionCheck.dart';
import 'package:e_com/utils/Resource.dart';
import 'package:e_com/utils/SharedPref.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return NotifiState();
  }

}

class NotifiState extends State{
  late UserLoginModel _userLoginModel;
  bool hasData = false, hasConnection = true;
  SharedPref sharePrefs = SharedPref();

  Future<bool> getValue() async {
    bool check = await ConnectionCheck().checkConnection();
    if (!check) {
      hasConnection = false;
    } else {
      hasConnection = true;
    }
    _userLoginModel = await sharePrefs.getLoginUserData();
    await PaymetDetailPresenter().get(_userLoginModel.data.token);
    hasData = true;
    setState(() {});
    return true;
  }
  @override
  void initState() {
    getValue();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
 return SafeArea(
     child:Scaffold(

 resizeToAvoidBottomInset: true,
 body: Material(

     child: Container(
       height: MediaQuery.of(context).size.height,
       width: MediaQuery.of(context).size.width,
       color: Color(ColorConsts.whiteColor),
    child: Stack(children: [
      Container(
          height: 58,
          padding: EdgeInsets.all(0),
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
                  child: Text('Notifications',
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
     FutureBuilder<ModelNoti>(
     future: hasData
     ? NotiPresenter().getList(
     _userLoginModel.data.token,
     _userLoginModel.data.id)
        : null,
    builder: (context, projectSnap) {
if(projectSnap.hasData){
  if(projectSnap.data!.data.length <1){
    return Align(alignment: Alignment.center,
        child:Container(
          margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment:MainAxisAlignment.center,children: [
            Image.asset('assets/images/noDataFound.png') ,
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text('No Notifications Received',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'OpenSans-Bold',
                      fontSize: 18,

                      color: Color(ColorConsts.blackColor))),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
              child: Text('We\'ll Notify You When Something Arrives',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 17,

                      color: Color(ColorConsts.grayColor))),
            ),

          ],) ,)
    );
  }
  return    Container(
      margin: EdgeInsets.fromLTRB(4, 65, 4, 0),child:  ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: projectSnap.data!.data.length,
      itemBuilder: (context, int idx) {
        return Container(
          margin: EdgeInsets.fromLTRB(9, 8, 9, 5),
          padding: EdgeInsets.all(11.5),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(ColorConsts.noticeColor),
                  Color(ColorConsts.noticeColor)
                ],
              ),
              borderRadius: BorderRadius.circular(8.0))
          ,child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment:CrossAxisAlignment.start,children: [

          Text(''+projectSnap.data!.data[idx].noti_msg,

              style: TextStyle(
                  fontFamily: 'OpenSans-Bold',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color(ColorConsts.blackColor))),
          Container(margin: EdgeInsets.fromLTRB(0, 5, 0, 1),child: Stack(children: [
            Align(alignment: Alignment.centerLeft,
                child: RichText(
                  text: new TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: new TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                    ),
                    children: <TextSpan>[
                      new TextSpan(
                        text:(projectSnap.data!.data[idx].ticket_id.isNotEmpty)? 'Ticket ID: ':"Order ID: ",
                        style: new TextStyle(
                            fontWeight:
                            FontWeight
                                .normal,
                            color: Color(
                                ColorConsts
                                    .blackColor)),
                      ),
                      new TextSpan(
                        text:(projectSnap.data!.data[idx].ticket_id.isNotEmpty)? projectSnap.data!.data[idx].ticket_id:projectSnap.data!.data[idx].order_id,
                        style: new TextStyle(
                            fontWeight:
                            FontWeight
                                .normal,color: Color(ColorConsts.primaryColor)),),
                    ],
                  ),
                )),
            Align(alignment: Alignment.centerRight,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerRight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment:MainAxisAlignment.end,children: [
                      Image.asset('assets/icons/watch.png',width: 15,height: 12) ,
                      Text(projectSnap.data!.data[idx].noti_date,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 13,

                              color: Color(ColorConsts.grayColor))),
                    ],
                    )
                )

            )
          ]
          )
          )
          ,
        ]),
        );
      }
  )
  );
}else {
  return Material(
      type: MaterialType.transparency,
      child: Container(
          alignment: Alignment.center,
          height:
          MediaQuery
              .of(context)
              .size
              .height -
              169,
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation(
                          Color(ColorConsts
                              .primaryColor)),
                      backgroundColor: Color(
                          ColorConsts
                              .pinkLytColor),
                      strokeWidth: 4.0)),
              Container(
                  margin: EdgeInsets.all(6),
                  child: Text(
                    Resource
                        .of(context, "en")
                        .strings
                        .loadingPleaseWait,
                    style: TextStyle(
                        color: Color(ColorConsts
                            .primaryColor),
                        fontFamily:
                        'OpenSans-Bold',
                        fontWeight:
                        FontWeight.w500,
                        fontSize: 18),
                  )),
            ],
          )));
}
    }
     ),


    ],)

 ),
    )
 )
   );
  }

}