import 'package:e_com/model/ModelTicketsReply.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/presenter/TicketPresenter.dart';
import 'package:e_com/utils/Resource.dart';
import 'package:e_com/utils/SharedPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/color_const.dart';

String ticket_id = "",seller_id="";

class ChatSupport extends StatefulWidget {
  ChatSupport(String tckId,sellerId) {
    ticket_id = tckId;
    seller_id=sellerId;
  }

  @override
  State<StatefulWidget> createState() {
    return chatState();
  }
}





class chatState extends State {
  late UserLoginModel _userLoginModel;
  bool hasData = false;
  SharedPref sharePrefs = SharedPref();

  TextEditingController controllerReply = TextEditingController();
  Future<void> getValue() async {
    _userLoginModel = await sharePrefs.getLoginUserData();
    hasData = true;
    setState(() {});
  }
  Future<void> sendAPI() async {

   await TicketPresenter().sendTicketReply(_userLoginModel.data.token,ticket_id,_userLoginModel.data.id,seller_id,controllerReply.text);
    controllerReply.text="";
    setState(() {});

  }


  @override
  void initState() {
    getValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                                  child: Text('My Chats',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color(ColorConsts.whiteColor))),
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

                      Container(
                          margin: EdgeInsets.fromLTRB(6, 90, 6, 70),
                          child: CustomScrollView(slivers: [
                            SliverToBoxAdapter(
                                child: FutureBuilder<ModelTicketsReply>(
                                    future: hasData
                                        ? TicketPresenter().getTicketReply(
                                            _userLoginModel.data.token,
                                            ticket_id)
                                        : null,
                                    builder: (context, projectSnap) {
                                      if (projectSnap.hasData) {
                                        if(projectSnap.data!.data.length == 0){
                                          return Align(alignment: Alignment.center,
                                              child:Container(
                                                margin: EdgeInsets.fromLTRB(40, 50, 40, 0),
                                                alignment: Alignment.center,
                                                child:Column(
                                                  mainAxisAlignment:MainAxisAlignment.center,children: [
                                                  Image.asset('assets/images/noDataFound.png') ,
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                    child: Text('No Reply',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily: 'OpenSans-Bold',
                                                            fontSize: 18,

                                                            color: Color(ColorConsts.blackColor))),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
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

                                        return ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: projectSnap.data!.data.length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, int idx) {
                                              if (projectSnap.data!.data[idx].sender_id == _userLoginModel.data.id) {
                                                return Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        60, 5, 1, 5),
                                                    padding: EdgeInsets.all(2),
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              12),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  decoration:
                                                                      new BoxDecoration(
                                                                          gradient:
                                                                              LinearGradient(
                                                                            begin:
                                                                                Alignment.centerLeft,
                                                                            end:
                                                                                Alignment.centerRight,
                                                                            colors: [
                                                                              Color(ColorConsts.primaryColor),
                                                                              Color(ColorConsts.secondaryColor)
                                                                            ],
                                                                          ),
                                                                          borderRadius: BorderRadius.only(
                                                                              bottomLeft: Radius.circular(8),
                                                                              bottomRight: Radius.circular(8),
                                                                              topLeft: Radius.circular(8),
                                                                              topRight: Radius.zero)),
                                                                  child: Text(
                                                                      projectSnap.data!.data[idx]
                                                                          .message,
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'OpenSans',
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color:
                                                                              Color(ColorConsts.whiteColor))),
                                                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0.5),
                                                                ),
                                                                Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Image.asset(
                                                                          'assets/icons/watch.png',
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              13),
                                                                      Text(
                                                                          projectSnap.data!.data[idx]
                                                                              .createdAt,
                                                                          style: TextStyle(
                                                                              fontFamily: 'OpenSans',
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Color(ColorConsts.grayColor)))
                                                                    ])
                                                              ]),
                                                        )
                                                      ],
                                                    ));
                                              } else {
                                                return Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        2, 5, 60, 5),
                                                    padding: EdgeInsets.all(2),
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              12),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  decoration:
                                                                      new BoxDecoration(
                                                                          gradient:
                                                                              LinearGradient(
                                                                            begin:
                                                                                Alignment.centerLeft,
                                                                            end:
                                                                                Alignment.centerRight,
                                                                            colors: [
                                                                              Color(ColorConsts.secondaryBtnColor),
                                                                              Color(ColorConsts.secondaryBtnColor)
                                                                            ],
                                                                          ),
                                                                          borderRadius: BorderRadius.only(
                                                                              bottomLeft: Radius.circular(7),
                                                                              bottomRight: Radius.circular(7),
                                                                              topLeft: Radius.circular(0),
                                                                              topRight: Radius.circular(7))),
                                                                  child: Text(
                                                                      projectSnap.data!.data[idx]
                                                                          .message,
                                                                      textAlign: TextAlign.start,
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'OpenSans',
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color:
                                                                              Color(ColorConsts.whiteColor))),
                                                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0.5),
                                                                ),
                                                                Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Image.asset(
                                                                          'assets/icons/watch.png',
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              13),
                                                                      Text(
                                                                          projectSnap.data!.data[idx]
                                                                              .createdAt,
                                                                          style: TextStyle(
                                                                              fontFamily: 'OpenSans',
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Color(ColorConsts.grayColor)))
                                                                    ])
                                                              ]),
                                                        )
                                                      ],
                                                    ));
                                              }
                                            });
                                      }

                                      return Material(
                                          type: MaterialType.transparency,
                                          child: Container(
                                              height: 400,
                                              margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                                              alignment: Alignment.center,
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
                                                                  .primaryColorLyt),
                                                          strokeWidth: 4.0)),
                                                  Container(
                                                      margin: EdgeInsets.all(6),
                                                      child: Text(
                                                        Resource.of(context, "en")
                                                            .strings
                                                            .loadingPleaseWait,
                                                        style: TextStyle(
                                                            color: Color(ColorConsts
                                                                .primaryColor),
                                                            fontFamily: 'OpenSans-Bold',
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 18),
                                                      )),
                                                ],
                                              )));
                                    }))
                          ])),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.fromLTRB(10, 5, 70, 12),
                          decoration: new BoxDecoration(
                              border: Border.all(
                                  color: Color(ColorConsts.lightGrayColor),
                                  width: 0.5),
                              borderRadius: BorderRadius.circular(26.0)),
                          child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      margin: EdgeInsets.fromLTRB(12, 0, 40, 0),
                                      child: TextField(
                                          minLines: 1,
                                          maxLines: 3,
                                          controller: controllerReply,
                                          decoration: InputDecoration(
                                              hintText:
                                                  'Write a message here..',
                                              hintStyle: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 16.5,
                                                  color: Color(ColorConsts
                                                      .lightGrayColor)),
                                              border: InputBorder.none),
                                          style: TextStyle(
                                              color:
                                                  Color(ColorConsts.blackColor),
                                              fontSize: 16.0,
                                              fontFamily: 'OpenSans')))),

                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: 50,
                          width: 50,
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 12),
                          padding: EdgeInsets.fromLTRB(13, 8, 12, 8),
                          decoration: new BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(ColorConsts.primaryColor),
                                  Color(ColorConsts.secondaryColor)
                                ],
                              ),
                              border: Border.all(
                                  color: Color(ColorConsts.lightGrayColor),
                                  width: 0.1),
                              borderRadius: BorderRadius.circular(36.0)),
                          child: InkResponse(onTap: () {
                            if(controllerReply.text.isNotEmpty){
                              sendAPI();
                            }else{
                              Fluttertoast.showToast(
                                  msg: 'Write before continue..',
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Color(ColorConsts.whiteColor),
                                  fontSize: 14.0);}
                          },child: Image(
                            image: AssetImage('assets/icons/sent.png'),
                            color: Color(ColorConsts.whiteColor),
                            width: 12,
                          ),
                        ),
                      )
                      )
                    ])))));
  }
}
