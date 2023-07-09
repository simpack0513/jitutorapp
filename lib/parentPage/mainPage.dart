import 'package:flutter/material.dart';
import 'package:jitutorapp/DataStore/MainpageStore.dart';
import 'package:jitutorapp/parentPage/setting.dart';
import 'package:provider/provider.dart';

//여기는 파일 import
import '../DataStore/ADStore.dart';
import '../DataStore/UserStore.dart';
import 'home.dart';
import 'calendar.dart';
import 'photo.dart';
import 'messenger.dart';
import 'mainPageTheme.dart';
import '../DataStore/ClassStore.dart';
import '../DataStore/ClasschildStore.dart';


//위젯 시작
class mainPageP extends StatefulWidget {
  const mainPageP({Key? key}) : super(key: key);

  @override
  State<mainPageP> createState() => _mainPagePState();
}

class _mainPagePState extends State<mainPageP> {
  // 이곳은 변수, 함수
  var bodyList = [Home(), Photo(), Calendar(), Messenger()];
  // 변수, 함수 끝

  @override
  void initState() {
   // 메인 페이지 초기 설정 : 유저의 Class 정보 가져오기
    init();
    super.initState();
  }
  // 초기함수 따로 빼둠(async를 써야해서..)
  void init() async{
    await context.read<ClassStore>().parentGetClassFromFirebase(context.read<UserStore>().userUID);
    context.read<UserStore>().updateDB_FCMToken();
    context.read<ADStore>().getMainBanner();
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
          title: Text(context.read<UserStore>().name+' 학부모님' , style: mainTheme.textTheme.headline1,),
          actions: [
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));
            }, icon: Icon(Icons.people_alt)),
          ],
        ),

        body: bodyList[context.watch<MainpageStore>().tap],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: context.watch<MainpageStore>().tap,
          onTap: (i){
            context.read<MainpageStore>().setTap(i);
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.collections), label: '갤러리'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: '캘린더'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: '메신저'),
          ],
        ),

      ),
    );
  }
}
