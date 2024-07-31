import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_com/utils/Resource.dart';
import '../utils/SharedPref.dart';
import '../utils/color_const.dart';
import 'Search.dart';

class ReturnAndRefunds extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return state();
  }
}
class LanguageDetails {
  const LanguageDetails({required this.title, required this.i});

  final String title;
  final String i;
}

List<LanguageDetails> listItem = [
  LanguageDetails(
      title: 'Red & Black Sports Shoes…', i: 'assets/images/shoeReview.png'),
  LanguageDetails(title: 'Girls Wear', i: 'assets/images/girlscat.png'),
  LanguageDetails(title: 'Gym', i: 'assets/images/boycat.png'),

];


List<LanguageDetails> listItemFaq = [
  LanguageDetails(
      title: 'How Do I Return My Order?', i: 'assets/images/shoeReview.png'),
  LanguageDetails(title: 'How Do I Return My Refunds?', i: 'assets/images/girlscat.png'),
];

class state extends State<ReturnAndRefunds> {
  String isSelected='';

  SharedPref sharePrefs = SharedPref();
  String? tag='';

  Future<void> getValue() async {
    tag= await sharePrefs.getLanguage();

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
                                  child: Text('Returns & Refunds',
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
                          )),  Container(
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
                            );
                          },
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
                                      )
                                  )),
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
                        margin: EdgeInsets.fromLTRB(12, 140, 12, 5),
                        child: CustomScrollView(
                            slivers: [
                            SliverToBoxAdapter(
                              child: Text(
                                "Select an item to Returns & Refunds",
                                maxLines: 1,
                                style: TextStyle(

                                    fontFamily: 'OpenSans-Bold',
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500,
                                    color: Color(ColorConsts.blackColor)),
                              ) ,
                        ),
                    SliverToBoxAdapter(
                        child:ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: listItem.length,
                            itemBuilder: (context, index) {
                              return InkResponse(
                                onTap: () {},
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.fromLTRB(2, 10, 0, 6),
                                  child: Column(children: [
                                    Stack(children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Color(0xffffb2b9), Color(0xffffb2b9)],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius:
                                            BorderRadiusDirectional.circular(6.0),
                                            image: DecorationImage(
                                              image: AssetImage(listItem[index].i),
                                              fit: BoxFit.fill,
                                              alignment: Alignment.topCenter,
                                            ),
                                          ),
                                          width: 80,
                                          height: 80,
                                          margin: EdgeInsets.fromLTRB(0, 0, 12, 8),
                                        ),
                                        Column(

                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(

                                              padding: EdgeInsets.fromLTRB(0, 0, 0, 4),child: Text(
                                              listItem[index].title,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: 'OpenSans-Bold',
                                                fontSize: 18.5,
                                                color: Color(ColorConsts.blackColor),
                                              ),
                                            ) ,)
                                            ,
                                            Row(
                                              children: [
                                                Text(
                                                  '\$399 ',
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontFamily: 'OpenSans-Bold',
                                                    fontSize: 19.5,
                                                    color: Color(ColorConsts.blackColor),
                                                  ),
                                                ),
                                                Text(
                                                  '499',
                                                  style: TextStyle(
                                                      decoration: TextDecoration.lineThrough,
                                                      decorationThickness: 2.2,
                                                      fontFamily: 'OpenSans',
                                                      decorationStyle:
                                                      TextDecorationStyle.solid,
                                                      decorationColor: Colors.black54,
                                                      fontSize: 16,
                                                      color: Color(ColorConsts.grayColor)),
                                                ),
                                                Text(
                                                  ' 20% Off',
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontFamily: 'OpenSans-Bold',
                                                    fontSize: 16,
                                                    color: Color(ColorConsts.primaryColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              'Delivered',
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: 'OpenSans-Bold',
                                                fontSize: 16,
                                                color: Color(ColorConsts.green),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ]),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            height: 80,
alignment: Alignment.centerRight,
                                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),

                                            child:Image.asset(
                                              'assets/icons/DownIcon.png',width: 7,color:(Color(ColorConsts.grayColor)
                              )
                                            )

                                          ),

                                        )

                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 6, 0, 3),
                                      color: Color(ColorConsts.grayColor),
                                      height: 0.2,
                                    )
                                  ]),
                                ),
                              );
                            })
                    ),  SliverToBoxAdapter(
                                child: Text(
                                  "\nFAQs",
                                  maxLines: 2,
                                  style: TextStyle(

                                      fontFamily: 'OpenSans-Bold',
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                      color: Color(ColorConsts.blackColor)),
                                ) ,
                              ),SliverToBoxAdapter(
                                child: ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    scrollDirection: Axis.vertical,
    itemCount: listItemFaq.length,
    itemBuilder: (context, index) {
    return Container(

        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
        margin: EdgeInsets.fromLTRB(0, 14, 0, 0),
        decoration: BoxDecoration(
          gradient: (isSelected.contains( Resource.of(context,tag!).strings.ReturnsRefunds))?LinearGradient(
            colors: [
              Color(ColorConsts.primaryColor),
              Color(ColorConsts.secondaryColor)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ):null,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
              color: Color(ColorConsts.lightGrayColor), width: 0.5),
        ),
        child:InkResponse(
          onTap: () {
            isSelected= Resource.of(context,tag!)
                .strings.ReturnsRefunds;
            setState(() {

            });
           /* Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ReturnAndRefunds();
            },));*/

          },
          child: Stack(

              children: [

                Container(
                  margin: EdgeInsets.fromLTRB(2, 0, 0, 0),

                  child: Column(
                    children: [
                      Container(

                        alignment: Alignment.centerLeft,
                        child: Text(
                          listItemFaq[index].title,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'OpenSans-Bold',
                            fontSize: 17,

                            color: (isSelected.contains( Resource.of(context,tag!)
                                .strings
                                .ReturnsRefunds))? Color(ColorConsts.whiteColor):Color(ColorConsts.blackColor), ),
                        ),
                      ),
                     if(index==0)Container(

                        alignment: Alignment.centerLeft,
                       margin: EdgeInsets.fromLTRB(0, 3, 9, 0),
                        child: Text(
                          'Amet minim mollit non deserunt ullamco est sit'
                              ' aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',

                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 17,

                            color: (Color(ColorConsts.grayColor ))
                          )
                        ),
                      ),

                    ],
                  ),
                )

                ,

                Align(
                  alignment: Alignment.topRight,
                  child: Container(

                    margin: EdgeInsets.fromLTRB(0, 2, 12, 0),

                    child:Image.asset(
                        (index==0)?'assets/icons/Downarrow.png':'assets/icons/DownIcon.png',width:     (index==0)?11:7,color:(isSelected.contains( Resource.of(context,tag!)
                        .strings
                        .ReturnsRefunds))? Color(ColorConsts.whiteColor):Color(ColorConsts.grayColor),),

                  ),

                )
              ]
          ),
        )
    );


    }
                              ),
                              )
                   ]
                        )
                )
                    ]),



                ))));
  }
}
