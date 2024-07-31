import 'dart:convert';
import 'package:e_com/model/ModelOrder.dart';
import 'package:e_com/model/ModelSettings.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/presenter/Orderpresenter.dart';
import 'package:e_com/ui/MyOrder.dart';
import 'package:e_com/utils/ConnectionCheck.dart';
import 'package:e_com/utils/Resource.dart';
import 'package:e_com/utils/SharedPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/color_const.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'Search.dart';

class OrderList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return state();
  }
}




class state extends State<OrderList> {

  String currSym = '\$';
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late UserLoginModel _userLoginModel;
  bool hasData = false, hasConnection = true;
  SharedPref sharePrefs = SharedPref();

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 100));
    setState(() {});
    _refreshController.refreshCompleted();
  }
  Future<ModelOrder> getMyOrderList() async{
    ModelOrder modelOrder= await OrderPresenter().getOrderList(
      _userLoginModel.data.token,
      _userLoginModel.data.id);

    return modelOrder;
}
  Future<bool> getValue() async {
    bool check = await ConnectionCheck().checkConnection();
    if (!check) {
      hasConnection = false;
    } else {
      hasConnection = true;
    }
    _userLoginModel = await sharePrefs.getLoginUserData();
    String? sett = await sharePrefs.getSettings() ;
    final Map<String, dynamic> parsed = json.decode(sett!);
    ModelSettings  modelSettings = ModelSettings.fromJson(parsed);
    currSym=modelSettings.data.currency_symbol.toString();
    hasData = true;
    setState(() {});
    return true;
  }
  List<orderData> removeDuplicates(List<orderData> people) {
    //create one list to store the distinct models
    List<orderData> distinct;
    List<orderData> dummy = people;

    for(int i = 0; i < people.length; i++) {
      for (int j = 1; j < dummy.length; j++) {
        if (people[i].id == dummy[j].id) {
          dummy.removeAt(j);
        }
      }
    }
    distinct = dummy;

    return distinct.map((e) => e).toList();
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
                            child: Text('All Orders',
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
                        new MaterialPageRoute(builder: (context) => Search()),
                      );
                    },
                    child: Stack(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 4.5, 0),
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
                ),
                Align(
                  child: Container(
                    height: 43,
                    width: 43,
                    margin: EdgeInsets.fromLTRB(12, 79, 12, 8),
                    decoration: new BoxDecoration(
                        border: Border.all(
                            color: Color(ColorConsts.primaryColor), width: 0.8),
                        borderRadius: BorderRadius.circular(4.0)),
                    child: InkResponse(onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) => Search()),
                      );
                    },child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Image(
                          image: AssetImage('assets/icons/mic.png'),
                        ),
                      ),
                    ),
                    )
                  ),
                  alignment: Alignment.topRight,
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(12, 137, 12, 0),
                    child: CustomScrollView(slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Text('Choose Product',
                              style: TextStyle(
                                  fontFamily: 'OpenSans-Bold',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(ColorConsts.blackColor))),
                        ),
                      ),
                      SliverToBoxAdapter(
                          child: SizedBox(
                        height: (MediaQuery.of(context).size.height - 155),
                        child: FutureBuilder<ModelOrder>(
                            future: hasData
                                ? getMyOrderList()
                                : null,
                            builder: (context, projectSnap) {


                              if (projectSnap.hasData) {
                                if (projectSnap.data!.data.length == 0) {
                                  return Column(children: [
                                    Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 124, 0, 4),
                                        child: Image.asset(
                                          'assets/images/noDataFound.png',
                                          height: 160,
                                        )),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 9, 0, 24),
                                      child: Text(
                                        'No Results found ! ',
                                        style: TextStyle(
                                            fontFamily: 'OpenSans-Bold',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color:
                                                Color(ColorConsts.textColor)),
                                      ),
                                    )
                                  ]);
                                }
                              //  List<orderData> listData=   removeDuplicates(projectSnap.data!.data);
                                return Container(
                                    padding: EdgeInsets.all(1.0),
                                    margin: EdgeInsets.fromLTRB(8, 6, 8, 25),
                                    child: SmartRefresher(
                                        enablePullDown: true,
                                        enablePullUp: false,
                                        controller: _refreshController,
                                        onRefresh: _onRefresh,
                                        physics: BouncingScrollPhysics(),
                                        header: ClassicHeader(
                                          refreshingIcon: Icon(Icons.refresh,
                                              color: Color(
                                                  ColorConsts.primaryColor)),
                                          refreshingText: '',
                                        ),
                                        child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            itemCount:
                                                projectSnap.data!.data.length,
                                            itemBuilder: (context, index) {
                                              return InkResponse(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                    builder: (context) {
                                                      return MyOrder(
                                                          projectSnap.data!.data[index]);
                                                    },
                                                  ));
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding: EdgeInsets.fromLTRB(
                                                      2, 10, 0, 6),
                                                  child: Column(children: [
                                                    Stack(
                                                      children: [
                                                        Row(
                                                             mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                      0xffffb2b9),
                                                                  Color(
                                                                      0xffffb2b9)
                                                                ],
                                                                begin: Alignment
                                                                    .centerLeft,
                                                                end: Alignment
                                                                    .centerRight,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadiusDirectional
                                                                      .circular(
                                                                          6.0),
                                                              image:
                                                                  DecorationImage(
                                                                image: NetworkImage(
                                                                    projectSnap
                                                                        .data!
                                                                        .data[
                                                                            index]
                                                                        .prod_image[0]),
                                                                fit:
                                                                    BoxFit.cover,
                                                                alignment:
                                                                    Alignment
                                                                        .topCenter,
                                                              ),
                                                            ),
                                                            width: 80,
                                                            height: 80,
                                                            margin: EdgeInsets
                                                                .fromLTRB(0, 0,
                                                                    12, 12),
                                                          ),
                                                      Flexible(child: Column(
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
                                                                        .fromLTRB(
                                                                            0,
                                                                            0,
                                                                            19,
                                                                            4),
                                                                child: Text(
                                                                  projectSnap
                                                                      .data!
                                                                      .data[
                                                                  index].pro_subtitle+" ("+projectSnap
                                                                      .data!
                                                                      .data[
                                                                          index].prod_name+")",
                                                                  maxLines: 2,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'OpenSans-Bold',
                                                                    fontSize:
                                                                        16,
                                                                    color: Color(
                                                                        ColorConsts
                                                                            .blackColor),
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    '$currSym ' +
                                                                        projectSnap
                                                                            .data!
                                                                            .data[index]
                                                                            .prod_unitprice
                                                                            .toString() +
                                                                        " ",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'OpenSans',
                                                                        fontSize:
                                                                            13,
                                                                        color: (index ==
                                                                                5)
                                                                            ? Color(ColorConsts.grayColor)
                                                                            : Color(ColorConsts.textColor)),
                                                                  ),
                                                                  if (double.parse((projectSnap.data!.data[index].prod_discount).toString()) > 0)if (double.parse(projectSnap
                                                                          .data!
                                                                          .data[
                                                                              index]
                                                                          .prod_strikeout_price) >=
                                                                      1.0)
                                                                    Text(
                                                                      '' +
                                                                          projectSnap
                                                                              .data!
                                                                              .data[index]
                                                                              .prod_strikeout_price
                                                                              .toString(),
                                                                      style: TextStyle(
                                                                          decoration: TextDecoration
                                                                              .lineThrough,
                                                                          decorationThickness:
                                                                              2.2,
                                                                          fontFamily:
                                                                              'OpenSans',
                                                                          decorationStyle: TextDecorationStyle
                                                                              .solid,
                                                                          decorationColor: Colors
                                                                              .black54,
                                                                          fontSize:
                                                                              13,
                                                                          color:
                                                                              Color(ColorConsts.grayColor)),
                                                                    ),
                                                                  if (double.parse((projectSnap
                                                                              .data!
                                                                              .data[
                                                                                  index]
                                                                              .prod_discount)
                                                                          .toString()) >
                                                                      0)
                                                                    (projectSnap
                                                                            .data!
                                                                            .data[index]
                                                                            .prod_discount_type
                                                                            .contains("flat"))
                                                                        ? Text(
                                                                            " " +
                                                                                projectSnap.data!.data[index].prod_discount.toString() +
                                                                                ' Flat Off',
                                                                            style: TextStyle(
                                                                                fontFamily: 'OpenSans',
                                                                                fontSize: 12.5,
                                                                                color: (projectSnap.data!.data[index].prod_quantity == 0) ? Color(0x9AB446FF) : Color(ColorConsts.primaryColor)),
                                                                          )
                                                                        : Text(
                                                                            "  " +
                                                                                projectSnap.data!.data[index].prod_discount.toString() +
                                                                                '% Off',
                                                                            style: TextStyle(
                                                                                fontFamily: 'OpenSans',
                                                                                fontSize: 12.5,
                                                                                color: (projectSnap.data!.data[index].prod_quantity == 0) ? Color(0x9AB446FF) : Color(ColorConsts.primaryColor)),
                                                                          ),
                                                                ],
                                                              ),
                                                              (projectSnap.data!.data[
                                                              index].order_status == 3 || projectSnap.data!.data[
                                                              index].order_status == 4) ?Container(margin: EdgeInsets.fromLTRB(0, 2, 0, 1),child: Text(
                                              (projectSnap.data!.data[
                                              index].order_status == 4)?'Ready To dispatch':"Confirmed",
                                                                maxLines:
                                                                1,
                                                                style:
                                                                TextStyle(
                                                                  fontFamily:
                                                                  'OpenSans-Bold',
                                                                  fontSize:
                                                                  16,
                                                                  fontWeight:
                                                                  FontWeight.w400,
                                                                  color: Color(
                                                                      ColorConsts.green),
                                                                ),
                                                              )
                                                              ):(projectSnap.data!.data[
                                                                              index].order_status == 1)
                                                                  ? Container(margin: EdgeInsets.fromLTRB(0, 2, 0, 1),child: Text(
                                                                      "Delivered",
                                                                      maxLines:
                                                                          1,
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'OpenSans-Bold',
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color: Color(
                                                                            ColorConsts.green),
                                                                      ),
                                                                    )
                                                              )
                                                                  :(projectSnap.data!.data[
                                                              index].order_status == 7 || projectSnap.data!.data[
                                                              index].order_status == 8)? Container(margin: EdgeInsets.fromLTRB(0, 2, 0, 1),child:Text(
                                                             'Return and Refund'
                                                                   ,
                                                                maxLines:
                                                                1,
                                                                style:
                                                                TextStyle(
                                                                  fontFamily:
                                                                  'OpenSans-Bold',
                                                                  fontSize:
                                                                  16,
                                                                  color: Color(ColorConsts.barColor)

                                                                ),
                                                              ),
                                                              ): Container(margin: EdgeInsets.fromLTRB(0, 2, 0, 1),child:Text(
                                                                      (projectSnap.data!.data[index].order_status ==
                                                                              2)
                                                                          ? 'Pending':(projectSnap.data!.data[index].order_status ==
                                                                          5)
                                                                          ?'Dispatched'
                                                                          : (projectSnap.data!.data[index].order_status ==
                                                                          6)
                                                                          ?'Cancelled ':"Cancelled",
                                                                      maxLines:
                                                                          1,
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'OpenSans-Bold',
                                                                        fontSize:
                                                                            16,
                                                                        color: (projectSnap.data!.data[index].order_status ==
                                                                                2 || projectSnap.data!.data[index].order_status ==
                                                                            5)
                                                                            ? Color(ColorConsts.barColor)
                                                                            : Color(ColorConsts.redColor),
                                                                      ),
                                                                    ),
                                                              )
                                                            ],
                                                          ),
                                                      )
                                                        ]),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Container(
                                                              height: 80,
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              margin: EdgeInsets
                                                                  .fromLTRB(0,
                                                                      0, 4, 0),
                                                              child: Image.asset(
                                                                  'assets/icons/DownIcon.png',
                                                                  width: 7,
                                                                  color: (Color(
                                                                      ColorConsts
                                                                          .grayColor)))),
                                                        )
                                                      ],
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 6, 0, 4),
                                                      color: Color(ColorConsts
                                                          .grayColor),
                                                      height: 0.2,
                                                    )
                                                  ]),
                                                ),
                                              );
                                            })));
                              } else {
                                return Material(
                                    type: MaterialType.transparency,
                                    child: Container(
                                        alignment: Alignment.center,
                                        height:
                                            MediaQuery.of(context).size.height -
                                                170,
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
                                                  Resource.of(context, "en")
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
                            }),
                      )),
                    ]))
              ]),
            ))));
  }
}
