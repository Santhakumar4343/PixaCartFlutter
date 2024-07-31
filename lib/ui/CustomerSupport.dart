
import 'package:e_com/model/ModelTickets.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/presenter/TicketPresenter.dart';
import 'package:e_com/utils/SharedPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/color_const.dart';
import 'ChatSupport.dart';
import 'OrderList.dart';
import 'Search.dart';
import 'package:e_com/utils/Resource.dart';

class CustomerSupport extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
  return CustomerSupportState();
  }



}



class CustomerSupportState extends State{

  late UserLoginModel _userLoginModel;
  String isSelected='';
  SharedPref sharePrefs = SharedPref();
  String? tag='';
  bool hasData=false;
  Future<void> getValue() async {
    tag= await sharePrefs.getLanguage();
    _userLoginModel=await sharePrefs.getLoginUserData();
    hasData=true;
    setState(() {

    });
  }

  @override
  void initState() {
    getValue();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
      floatingActionButton: InkResponse(
       onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (context) {
          return OrderList();
         },));
       //  Dialog(context);
       }, child: Container(
        margin: EdgeInsets.all(8),
        height: 55,
        width: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(40),
          ),
          color: Color(ColorConsts.barColor),
        ),
        child: Icon(Icons.add,color:  Color(ColorConsts.whiteColor),),
      ),
      ),

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
                  child: Text('Customer Support',
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
        Container(
          height: 43,
          margin: EdgeInsets.fromLTRB(12, 79, 65, 8),
          padding: EdgeInsets.fromLTRB(5, 0, 6, 0),
          decoration: new BoxDecoration(
              border: Border.all(
                  color: Color(ColorConsts.lightGrayColor), width: 0.5),
              borderRadius: BorderRadius.circular(4.0)),
          child: InkResponse(
            onTap: () {
              setState(() {});
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => Search()),
              );},
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0,4.5, 0),
                        child: Text(
                          " Search..",
                          maxLines: 1,
                          style: TextStyle(

                              fontFamily: 'OpenSans',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(ColorConsts.lightGrayColor)),
                        ))),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 13, 5, 13),
                    child: Image(
                      image: AssetImage('assets/icons/SearchIcon.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),   Align(
          child: Container(
            height: 43,
            width: 43,
            margin: EdgeInsets.fromLTRB(12, 79, 12, 8),
            decoration: new BoxDecoration(
                border: Border.all(
                    color: Color(ColorConsts.primaryColor), width: 0.8),
                borderRadius: BorderRadius.circular(4.0)),
            child:
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: Image(
                  image: AssetImage('assets/icons/mic.png'),
                ),
              ),


            ),
          ),
          alignment: Alignment.topRight,
        ),
    Container(
    margin: EdgeInsets.fromLTRB(12, 140, 12, 0),
    child: CustomScrollView(
    slivers: [
    SliverToBoxAdapter(
child: Column(children: [
Stack(children: [
    Align(alignment: Alignment.centerRight,
     ),Container(
      margin: EdgeInsets.all(2.5),
      alignment: Alignment.centerLeft,
      child: Text('Your Tickets',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18
            ,fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans-Bold',
            color: Color(ColorConsts.textColor),
          )),
    ),

  ],),
        ])

    ),SliverToBoxAdapter(
        child:  FutureBuilder<ModelTickets>(
    future: hasData
    ? TicketPresenter().getTicket(
    _userLoginModel.data.token, _userLoginModel.data.id)
        : null,
    builder: (context, projectSnap) {
    if (projectSnap.hasData) {
if(projectSnap.data!.data.length == 0)
{
  return Container(
    height: MediaQuery.of(context).size.height-320,
    margin: EdgeInsets.fromLTRB(40, 20, 40, 0),
    alignment: Alignment.center,
    child:Column(
      mainAxisAlignment:MainAxisAlignment.center,children: [
      Image.asset('assets/images/noDataFound.png',height: 150,) ,
      Container(
        margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
        child: Text('No Results found!',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'OpenSans-Bold',
                fontSize: 18,

                color: Color(ColorConsts.blackColor))),
      ),


    ],) ,);

}      return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: projectSnap.data!.data.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, int idx) {
            return InkResponse(onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ChatSupport(projectSnap.data!.data[idx].id,projectSnap.data!.data[idx].ticket_sellerid);
                },
              ));
            },child: Container(
              margin: EdgeInsets.fromLTRB(2, 8, 2, 5),
              padding: EdgeInsets.all(11.5),
              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                    color: Color(ColorConsts.secondaryColor), width: 0.6),

              )
              , child: Column(
                mainAxisAlignment:MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,children: [

              Text('' + projectSnap.data!.data[idx].subject,

                  style: TextStyle(
                      fontFamily: 'OpenSans-Bold',
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color(ColorConsts.blackColor))),
              Container(margin: EdgeInsets.fromLTRB(0, 4.7, 0, 1),
                  child: Stack(children: [
                    Align(alignment: Alignment.centerLeft,
                        child: RichText(
                          text: new TextSpan(
                            // Note: Styles for TextSpans must be explicitly defined.
                            // Child text spans will inherit styles from parent
                            style: new TextStyle(
                              fontSize: 19.0,
                              color: Colors.grey,
                            ),
                            children: <TextSpan>[
                              new TextSpan(
                                text: 'Ticket ID: ',
                                style: new TextStyle(
                                    fontWeight:
                                    FontWeight
                                        .normal,
                                    color: Color(
                                        ColorConsts
                                            .blackColor)),
                              ),
                              new TextSpan(
                                text: projectSnap.data!.data[idx].ticket_uniqueid,
                                style: new TextStyle(
                                    fontWeight:
                                    FontWeight.w400,
                                    color: Color(ColorConsts.primaryColor)),),
                            ],
                          ),
                        )),

                  ]
                  )
              )
              ,
              Container(margin: EdgeInsets.fromLTRB(0, 5, 0, 1),
                  child: Stack(children: [
                    Align(alignment: Alignment.centerLeft,
                        child: RichText(
                          text: new TextSpan(
                            // Note: Styles for TextSpans must be explicitly defined.
                            // Child text spans will inherit styles from parent
                            style: new TextStyle(
                              fontSize: 19.0,
                              color: Colors.grey,
                            ),
                            children: <TextSpan>[
                              new TextSpan(
                                text: 'Status : ',
                                style: new TextStyle(
                                    fontWeight:
                                    FontWeight
                                        .normal,
                                    color: Color(
                                        ColorConsts
                                            .blackColor)),
                              ),
                              new TextSpan(
                                text: (projectSnap.data!.data[idx].status==0)?'Open':'Closed',
                                style: new TextStyle(
                                    fontWeight:
                                    FontWeight
                                        .normal,
                                    color: Color(ColorConsts.green)),),
                            ],
                          ),
                        )),
                    Align(alignment: Alignment.centerRight,
                        child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            alignment: Alignment.centerRight,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset('assets/icons/watch.png', width: 20,
                                    height: 13),
                                Text(projectSnap.data!.data[idx].createdAt,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 14,

                                        color: Color(ColorConsts.grayColor))),
                              ],
                            )
                        )

                    )
                  ]
                  )
              )
            ]),
            ));
          }
      );

    }else{
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
    }})
      )
    ]
    )
    )


    ])
    )
    )
    )
    );
  }

}