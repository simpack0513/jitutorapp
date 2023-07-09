import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jitutorapp/DataStore/ADStore.dart';
import 'package:jitutorapp/DataStore/ClassStore.dart';
import 'package:provider/provider.dart';

import '../DataStore/ClasschildStore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // 스타일
  var headtextStyle = TextStyle(
    fontFamily: 'LINESeedKR',
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );
  var classtextStyle = TextStyle(
    fontFamily: 'LINESeedKR',
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  var bodytextStyle = TextStyle(
    fontFamily: 'LINESeedKR',
    color: Colors.black,
    fontSize: 14,
  );
  var smalltextStyle = TextStyle(
    fontFamily: 'LINESeedKR',
    color: Colors.black,
    fontSize: 10,
  );
  var bodyBoldtextStyle = TextStyle(
    fontFamily: 'LINESeedKR',
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      color: const Color(0xfff2f1f0),
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  1. top 배너
            (context.watch<ADStore>().mainBanner.isNotEmpty) ? CarouselSlider(
              options: CarouselOptions(
                  height: MediaQuery.of(context).size.height / 8,
                  autoPlay: true,
                  viewportFraction: 1,
                  autoPlayInterval: const Duration(seconds: 5),
              ),
              items: context.watch<ADStore>().mainBanner.map((imageSrc) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        height: MediaQuery.of(context).size.height / 8,
                        width: double.infinity,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(imageSrc, fit: BoxFit.cover,),
                        )
                    );
                  }
                );
              }).toList(),
            ) : Container(height: MediaQuery.of(context).size.height / 8,),
            //  2. 다가오는 수업 메인
            (context.watch<ClasschildStore>().comingClassList.isNotEmpty) ? Container(
                padding: EdgeInsets.fromLTRB(5, 30, 0, 0),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month),
                    SizedBox(width: 10,),
                    Text('다가오는 수업', style: headtextStyle, ),
                  ],
                )
            ) : SizedBox(width: 0, height: 0,),
            (context.watch<ClasschildStore>().comingClassList.isNotEmpty) ? Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: context.watch<ClasschildStore>().comingClassList.length,
                  itemBuilder: (context, i) {
                    return Container(
                      margin: (i != 0) ? EdgeInsets.fromLTRB(0, 5, 0, 0) : EdgeInsets.all(0),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(context.watch<ClasschildStore>().comingClassList[i]["comingDay"], style: bodyBoldtextStyle),
                          SizedBox(width: 10,),
                          Text(context.watch<ClasschildStore>().comingClassList[i]['name']
                              +'  '+context.watch<ClasschildStore>().comingClassList[i]['startTime']
                              +' ~ '+context.watch<ClasschildStore>().comingClassList[i]['endTime'], style: bodytextStyle,),
                        ],
                      ),
                    );
                  }
              ),
            ) : SizedBox(width: 0, height: 0,),

            // 3. 수업 리스트
            Container(
              margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height / 25, 0, 0),
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Row(
                children: [
                  Icon(Icons.menu_book),
                  SizedBox(width: 10,),
                  Text('수업', style: headtextStyle, ),
                ],
              )
            ),
            (context.watch<ClassStore>().userClassListAtHome.length != 0) ? ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: context.watch<ClassStore>().userClassListAtHome.length,
              itemBuilder: (context, i) {
                return Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(children: [
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        child: Image.network(context.watch<ClassStore>().userClassListAtHome[i]['image'],
                        width: MediaQuery.of(context).size.height / 16,
                        height: MediaQuery.of(context).size.height / 16,
                        fit: BoxFit.fill),
                      ),
                      SizedBox(width: 10,),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(context.watch<ClassStore>().userClassListAtHome[i]['className'], style: classtextStyle,),
                        Text('수업 시작일 : ' + context.watch<ClassStore>().userClassListAtHome[i]['startDate'], style: smalltextStyle,)
                      ],),
                    ],),
                    SizedBox(height: 10,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text(context.watch<ClassStore>().userClassListAtHome[i]['classTime'], style: bodytextStyle,),
                    ],)

                  ],),
                );
              }
            ) : Text('현재 속한 수업이 없습니다.'),
          ],
        ),
      ),
    );
  }

}
