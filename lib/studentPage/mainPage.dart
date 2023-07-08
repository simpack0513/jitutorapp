import 'package:flutter/material.dart';
import 'package:jitutorapp/DataStore/MarketStore.dart';
import 'package:jitutorapp/DataStore/OrderStore.dart';
import 'package:jitutorapp/studentPage/market.dart';
import 'package:jitutorapp/studentPage/setting.dart';
import 'package:provider/provider.dart';

//여기는 파일 import
import '../DataStore/UserStore.dart';
import 'home.dart';
import 'calendar.dart';
import 'messenger.dart';
import 'mainPageTheme.dart';
import '../DataStore/ClassStore.dart';
import '../DataStore/ClasschildStore.dart';


//위젯 시작
class mainPageS extends StatefulWidget {
  const mainPageS({Key? key}) : super(key: key);

  @override
  State<mainPageS> createState() => _mainPageSState();
}

class _mainPageSState extends State<mainPageS> {
  // 이곳은 변수, 함수
  var tap = 0;
  var bodyList = [Home(), Market(), Calendar(), Messenger()];
  // 변수, 함수 끝

  @override
  void initState() {
   // 메인 페이지 초기 설정 : 유저의 Class 정보 가져오기
    init();
    super.initState();
  }
  // 초기함수 따로 빼둠(async를 써야해서..)
  void init() async{
    await context.read<ClassStore>().studentGetClassFromFirebase(context.read<UserStore>().userUID);
    context.read<UserStore>().updateDB_FCMToken();
    context.read<MarketStore>().getMarketItem();
    context.read<OrderStore>().initOrderList(context.read<UserStore>().userUID);
    context.read<ClasschildStore>().generateClassChild(context.read<ClassStore>().userClassList);
    context.read<ClasschildStore>().getComingClassList(context.read<ClassStore>().userClassUIDList);
    await context.read<ClasschildStore>().getEventAllday(context.read<ClassStore>().userClassUIDList);
    context.read<ClassStore>().makeHomeList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mainTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text(context.read<UserStore>().name+' 학생' , style: mainTheme.textTheme.headline1,),
          actions: [
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));
            }, icon: Icon(Icons.people_alt)),
          ],
        ),

        body: bodyList[tap],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: tap,
          onTap: (i){
            setState(() {
              tap = i;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.storefront), label: '마켓'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: '캘린더'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: '메신저'),
          ],
        ),

      ),
    );
  }
}
