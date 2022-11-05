import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
final auth = FirebaseAuth.instance;

var InfoPagetheme = ThemeData(
  fontFamily: 'Pretendard',
  inputDecorationTheme: InputDecorationTheme(
    counterStyle: TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 30,
    ),
    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))
  ),

);

class InfoStore extends ChangeNotifier {
  var type = 'NULL';
  var name = '';
  changeType(String s) {
    type = s;
    notifyListeners();
    print(type);
  }
  changeName(String s) {
    name = s;
    notifyListeners();
  }
}


class signUp extends StatelessWidget {
  signUp({Key? key}) : super(key: key);
  var mainTextStyle = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 30,
  );

  void nextPage(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => NameInfoPage()));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) => InfoStore(),
      child: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('지튜터에 오신 것을 환영합니다', style: mainTextStyle,),
                Text('아래 버튼을 눌러 회원가입을 진행하십시오.', style: TextStyle(fontSize: 15, fontFamily: 'Pretendard')),
                Container(height: 50,),
                Row(children: [
                  Flexible(child: TextButton(onPressed: (){context.read<InfoStore>().changeType('student'); nextPage(context);}, child: Image.asset('assets/studentButtonIcon.png', fit: BoxFit.fitHeight,) ), flex: 1, ),
                  Flexible(child: TextButton(onPressed: (){context.read<InfoStore>().changeType('parent'); nextPage(context); }, child: Image.asset('assets/parentButtonIcon.png', fit: BoxFit.fill,)), flex: 1, ),

                ],),
              TextButton(onPressed: (){context.read<InfoStore>().changeType('teacher'); nextPage(context); }, child: Image.asset('assets/teacherButtonIcon.png')),

              ],
            ),
          ),
        ),

      ),
    );
  }
}

class NameInfoPage extends StatefulWidget {
  const NameInfoPage({Key? key}) : super(key: key);

  @override
  State<NameInfoPage> createState() => _NameInfoPageState();
}

class _NameInfoPageState extends State<NameInfoPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: InfoPagetheme,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Colors.black,)),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(5),
                child: Text('이름을 입력하세요', style: TextStyle(fontSize: 30, fontFamily: 'Pretedard'),)),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                onChanged: (text){context.read<InfoStore>().changeName(text);},
              ),
            ),
          ],
        ),
        bottomSheet: Container(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 30),
          width: double.infinity,
          height: 90,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.watch<InfoStore>().name!=''?Colors.blue:Colors.grey,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
            ),
            onPressed: (){
              if(context.watch<InfoStore>().name!='') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PhoneInfoPage()));
              }
              else {}
            },
            child: Text('본인인증 하기', style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 20,
              color: Colors.white,
            ),),
          ),
        ),

      ),
    );
  }
}


// 휴대폰 회원가입 페이지
class PhoneInfoPage extends StatelessWidget {
  const PhoneInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

