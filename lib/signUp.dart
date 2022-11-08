import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  var type = '';
  var name = '';
  var phone = '';
  popType() {
    type = '';
  }
  popName() {
    name = '';
  }
  popPhone() {
    phone = '';
  }
  changeType(String s) {
    type = s;
    notifyListeners();
    print(type);
  }
  changeName(String s) {
    name = s;
    notifyListeners();
  }
  changePhone(String s){
    phone = s;
    notifyListeners();
  }
}

//회원가입 메인 페이지
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

// 이름 기입 페이지
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
          leading: IconButton(onPressed: (){context.read<InfoStore>().popName(); Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Colors.black,)),
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
              var str = context.read<InfoStore>().name.toString();
              if(str != '') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PhoneInfoPage()));
                print(str);
              }
              else {}
            },
            child: Text('다음', style: TextStyle(
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
class PhoneInfoPage extends StatefulWidget {
  const PhoneInfoPage({Key? key}) : super(key: key);

  @override
  State<PhoneInfoPage> createState() => _PhoneInfoPageState();
}

class _PhoneInfoPageState extends State<PhoneInfoPage> {
  bool IsClickButton = false;
  String verificationId = '';
  // 휴대폰 계정 생성
  void sendMessage() async{
    await auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 60),
        phoneNumber: '+82'+context.read<InfoStore>().phone.toString().replaceFirst('0', ' ').trim(),
        verificationCompleted: (verificationCompleted) async{
          print("인증코드 발송 성공");
        },
        verificationFailed: (verificationFailed) async {
          print("코드발송실패\n");
          print(verificationFailed);
          setState(() {
            IsClickButton = false;
          });
        },
        codeSent: (verificationId, resendingToken) async{
          print("코드 보냄");
          Fluttertoast.showToast(
            msg: context.read<InfoStore>().phone+' 로 인증코드를 발송하였습니다.',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            fontSize: 12
          );
          setState(() {
            this.verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) async{
          print(verificationId);
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: InfoPagetheme,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(onPressed: (){context.read<InfoStore>().popPhone(); Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Colors.black,)),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(5),
                child: Text('전화번호를 입력하세요', style: TextStyle(fontSize: 30, fontFamily: 'Pretedard'),)),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                enabled: !IsClickButton?true:false,
                onChanged: (text){context.read<InfoStore>().changePhone(text);},
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.all(5),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: (context.watch<InfoStore>().phone!='')&&(!IsClickButton)?Colors.blue:Colors.grey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                ),
                child: Text('인증하기', style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 17,
                  color: Colors.white,
                ),),
                onPressed: (){
                  if(context.read<InfoStore>().phone!='' && !IsClickButton) {
                    setState(() {IsClickButton = true;});
                    sendMessage();
                  }
                },
              ),
            ),

            IsClickButton? Padding(
                padding: const EdgeInsets.fromLTRB(5, 30, 5, 5),
                child: Text('인증번호를 입력하세요', style: TextStyle(fontSize: 30, fontFamily: 'Pretedard'),)):Container(),
            IsClickButton? Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(),
            ):Container(),
            IsClickButton? Container(
              height: 50,
              padding: EdgeInsets.all(5),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                ),
                child: Text('다음', style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 17,
                    color: Colors.white,
                )),
                onPressed: (){
                },
              ),
            ):Container(),

          ],
        ),

      ),
    );
  }
}

