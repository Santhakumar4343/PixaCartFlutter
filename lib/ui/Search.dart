import 'dart:io';

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:e_com/model/ModelSearch.dart';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:e_com/presenter/SearchPresenter.dart';
import 'package:e_com/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:e_com/utils/Resource.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../utils/SharedPref.dart';
import 'AllProducts.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Search extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchState();
  }
}

class SearchState extends State<Search> {
  List<SearchData> searchRes = [];
  int countLst=0;
  stt.SpeechToText speech = stt.SpeechToText();
  List<String> selectedCountList = [];
  TextEditingController searchController = TextEditingController();
  bool hasData=false,listning=false;
  late UserLoginModel _userLoginModel;
  SharedPref sharePrefs = SharedPref();
  String? tag='',selected="";
  bool _speechEnabled = false;
  String _lastWords = '';

  Future<void> getValue() async {
    tag= await sharePrefs.getLanguage();
    _userLoginModel = await sharePrefs.getLoginUserData();
    if (Platform.isAndroid) {
      iniSpeech();
      // Android-specific code
    } else if (Platform.isIOS) {
      // iOS-specific code
    }

search();
  }
  Future<void> search() async {
    ModelSearch dataRes= await  SearchPresenter().get(_userLoginModel.data.token, 25, searchController.text);
    searchRes=dataRes.data;
    hasData=true;
    setState(() {
    });
  }



  Widget _buildRow(String c, String type) {
    return InkResponse(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AllProducts(''+c, '', '');
      },));
    },child: Container(
      margin: EdgeInsets.fromLTRB(8, 3, 9, 4.5),
      padding: EdgeInsets.fromLTRB(0,0,0,0),
      child:
    Stack(children: [
      new Column(mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,children: [
         Container(
           margin: EdgeInsets.fromLTRB(28, 0, 0, 0),
           child:  new Text(
           c,style: TextStyle(
           fontFamily: 'OpenSans-Bold',
           color: Color(ColorConsts.blackColor),
           fontSize: 16.0,
         ),
         ),),
        Container(
            margin: EdgeInsets.fromLTRB(28, 0, 0, 0),
            child:new Text(type,style: TextStyle(
            fontFamily: 'OpenSans-Bold',
            color: Color(ColorConsts.secondaryColor),
            fontSize: 12.0,
          ),),
        ),
          Container(
            margin: EdgeInsets.fromLTRB(0,6, 0, 2),color: Color(ColorConsts.grayColor),
            height: 0.1,)
        ]
    ),
      Align(alignment: Alignment.centerRight,
      child:RotationTransition(
        turns: new AlwaysStoppedAnimation(22 / 360),child:  Image.asset(
        'assets/icons/Arrow.png',
        width: 17,
        height: 28,
        color: Color(ColorConsts.lightGrayColor),
      )
      ),)
      ,
      Align(alignment: Alignment.centerLeft,
        child: Image.asset(
          'assets/icons/SearchIcon.png',
          width: 19,
          height: 30,
          color: Color(ColorConsts.lightGrayColor),

        ),)
    ],)
      ,)

    );
  }

  @override
  void initState() {
    getValue();
    super.initState();
    searchController.addListener(() {
      setState(() {
        hasData=false;
        search();
      });
    });

  }

  Future<void> iniSpeech() async {
    if(speech.hasError){
      Fluttertoast.showToast(
          msg: 'Speech recognization disabled!',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Color(ColorConsts.whiteColor),
          fontSize: 14.0);
    }
    _speechEnabled = await speech.initialize();
    if ( _speechEnabled ) {
      print("has speech recognition.");
    }
    else {

    }
    setState(() {});
  }

  void _startListening() async {
if(_speechEnabled) {
  await speech.listen(onResult: (result) {
    _onSpeechResult(result);
  },);
}else{
  listning=false;
  Fluttertoast.showToast(
      msg: 'Speech recognization disabled!',
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Color(ColorConsts.whiteColor),
      fontSize: 14.0);
}

  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    searchController.text=result.recognizedWords;
    listning=false;
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  void _stopListening() async {
    await speech.stop();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Color(ColorConsts.whiteColor),
                child:

                CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(child:  Container(
                          height: 59,
                          padding: EdgeInsets.all(1),
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
                          child: Stack(children: [

                            InkResponse(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  child: Image.asset(
                                    'assets/icons/Arrow.png',
                                    width: 25,
                                    height: 28,
                                    color: Color(ColorConsts.whiteColor),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: 42,
                                width: MediaQuery.of(context).size.width,
                                margin: (Platform.isAndroid) ?EdgeInsets.fromLTRB(38, 0, 54, 0):EdgeInsets.fromLTRB(38, 0, 14, 0),
                                padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                                decoration: new BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(ColorConsts.whiteColor),
                                        Color(ColorConsts.whiteColor)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    border: Border.all(
                                        color: Color(ColorConsts.lightGrayColor),
                                        width: 0.5),
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: InkResponse(
                                  onTap: () {
                                    setState(() {});
                                    /*Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => Search()),
        ).then((value) {
          debugPrint(value);
          _reload();
        });*/
                                    setState(() {});
                                  },
                                  child: Stack(
                                    children: [
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.fromLTRB(7, 0, 25, 1),
                                              child: new TextField(
                                                textAlign: TextAlign.start,
                                                onChanged: (value) {
                                                  setState(() {
                                                    if(value.length > 1){
                                                      countLst=value.length;
                                                    }else{
                                                      countLst=0;
                                                    }
                                                  });
                                                },
                                                style: TextStyle(
                                                    color: Color(ColorConsts.blackColor),
                                                    fontSize: 14.0,
                                                    fontFamily: 'OpenSans'),
                                                controller: searchController,
                                                decoration: new InputDecoration(

                                                    hintText: Resource.of(context,tag!).strings.search,
                                                    hintStyle: TextStyle(
                                                        fontFamily: 'OpenSans',
                                                        fontSize: 14.0,
                                                        color: Color(ColorConsts.lightGrayColor)),
                                                    border: InputBorder.none
                                                ),
                                              ))),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          width: 24,
                                          padding: EdgeInsets.fromLTRB(0, 13, 5, 13),
                                          child: Image(
                                            image: AssetImage(
                                                'assets/icons/SearchIcon.png'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if(_speechEnabled)Align(
                              child: InkResponse(child: Container(
                                height: 43,
                                width: 43,
                                margin: EdgeInsets.fromLTRB(1, 6, 4, 5),
                                decoration: new BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(ColorConsts.whiteColor),
                                        Color(ColorConsts.whiteColor)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    border: Border.all(
                                        color: Color(ColorConsts.grayColor), width: 0.8),
                                    borderRadius: BorderRadius.circular(4.0)
                                ),
                                child:
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(

                                    child: AvatarGlow(
                                      startDelay: Duration(milliseconds: 1000),
                                      glowColor: listning?Color(ColorConsts.primaryColorLyt):Color(ColorConsts.whiteColor),
                                      endRadius: 100.0,
                                      duration: Duration(milliseconds: 2000),
                                      repeat: true,
                                      showTwoGlows: false,
                                      repeatPauseDuration: Duration(milliseconds: 100),
                                      child:Image(
                                        image: AssetImage('assets/icons/mic.png'),height: 16, color: listning?Color(ColorConsts.primaryColor):Color(ColorConsts.grayColor)
                                      )
                                    ),
                                  ),


                                ),
                              ),
                                onTap: () {
                                  listning=true;
                                  setState(() {

                                  });
                                  _startListening();
                                },
                              ),
                              alignment: Alignment.topRight,
                            )
                          ])),),
                      if(searchRes.length!=0)SliverToBoxAdapter(

                        child: SizedBox(height: MediaQuery.of(context).size.height-1,child:ListView.builder(
                            itemCount: searchRes.length,
                            itemBuilder: (BuildContext context, int index) {


                                  return _buildRow(searchRes[index].name,searchRes[index].type);

                            })),


                      ),
                      if(!hasData)SliverToBoxAdapter(child: Container(
                        height: MediaQuery.of(context).size.height-320,
                        alignment: Alignment.center,
                        child: Text('Searching.....',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'OpenSans-Bold',
                                fontSize: 18,

                                color: Color(ColorConsts.primaryColor))),
                      ),
                      ),
                      if(searchRes.length==0)if(hasData)SliverToBoxAdapter(child: Container(
                        height: MediaQuery.of(context).size.height-320,
                        margin: EdgeInsets.fromLTRB(40, 45, 40, 0),
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
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                            child: Text('Search again.....',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 15,

                                    color: Color(ColorConsts.grayColor))),
                          ),

                        ],) ,),
    ),
                  /*    if(searchRes.length!=0)SliverToBoxAdapter(child:  Container(
                        margin: EdgeInsets.fromLTRB(8, 10, 8, 3),
                        child:Text(''+ Resource.of(context,tag!).strings.discoverMore,
                          style: TextStyle(
                            fontFamily: 'OpenSans-Bold',
                            fontWeight: FontWeight.w500,
                            color: Color(ColorConsts.blackColor),
                            fontSize: 19.0,
                          ),
                        )
                        ,),
                      ),*/
                       /*   SliverToBoxAdapter(
                            child: SizedBox(height: 200,child:  Wrap(
                        children: searchRes.map((f) => GestureDetector(
                          child: Container(

                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 9.0),
                            margin: EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 7.0, bottom: 2.0),
                            decoration: BoxDecoration(
                              color:   (selected!.contains(f.name))?Color(ColorConsts.secondaryColor):Color(ColorConsts.whiteColor),
                              border:Border.all(color: (selected!.contains(f.name))?Color(ColorConsts.whiteColor):Color(ColorConsts.secondaryColor), width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) //                 <--- border radius here
                              ),
                            ),
                            child: Text(f.name,
                              style: TextStyle(
                                fontFamily: 'OpenSans-Bold',
                                color: (selected!.contains(f.name))?Color(ColorConsts.whiteColor):Color(ColorConsts.secondaryColor),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          onTap: () {


selected=f.name;
setState(() {

});
Navigator.push(context, MaterialPageRoute(builder: (context) {
  return AllProducts(''+f.name, '', '');
},));
                          },
                        ))
                            .toList(),
                      ),
                            ))*/
                    ]),







            )));
  }
}


