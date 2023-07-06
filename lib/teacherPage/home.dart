import 'package:flutter/material.dart';
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
  var bodytextStyle = TextStyle(
    fontFamily: 'LINESeedKR',
    color: Colors.black,
    fontSize: 14,
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
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              height: MediaQuery.of(context).size.height / 8,
            ),

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
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 7,
              itemBuilder: (context, i) {
                return Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: MediaQuery.of(context).size.height / 8,
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
