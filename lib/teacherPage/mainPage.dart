import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//여기는 파일 import
import '../DataStore/UserStore.dart';
import 'home.dart';
import 'calendar.dart';
import 'photo.dart';
import 'messenger.dart';
import 'mainPageTheme.dart';


//위젯 시작
class mainPage extends StatefulWidget {
  const mainPage({Key? key}) : super(key: key);

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  // 이곳은 변수, 함수
  var tap = 0;
  var bodyList = [Home(), Photo(), Calendar(), Messenger()];
  // 변수, 함수 끝

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mainTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text(context.read<UserStore>().name+' 선생님' , style: mainTheme.textTheme.headline1,),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.people_alt)),
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
            BottomNavigationBarItem(icon: Icon(Icons.collections), label: '갤러리'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: '캘린더'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: '메신저'),
          ],
        ),

      ),
    );
  }
}
