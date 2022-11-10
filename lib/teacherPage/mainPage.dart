import 'package:flutter/material.dart';


//여기는 파일 import
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
          title: Text('OOO 선생님', style: mainTheme.textTheme.headline1,),
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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.motion_photos_on), label: 'photo'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'calendar'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'messenger'),
          ],
        ),

      ),
    );
  }
}
