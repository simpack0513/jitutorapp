import 'dart:io';
//여기는 일반 파일 import 하는 곳
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jitutorapp/login.dart';
import 'package:jitutorapp/studentPage/mainPage.dart';
import 'DataStore/InfoStore.dart';
import './teacherPage/mainPage.dart';
import 'DataStore/UserStore.dart';
//
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//전역변수 - phone credential 이유 : 이메일과 연동하고 싶어서
var authCredential;
final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

var InfoPagetheme = ThemeData(
  fontFamily: 'LINESeedKR',
  inputDecorationTheme: InputDecorationTheme(
    counterStyle: TextStyle(
      fontFamily: 'LINESeedKR',
      fontSize: 30,
    ),
    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))
  ),

);

//회원가입 메인 페이지
class signUp extends StatelessWidget {
  signUp({Key? key}) : super(key: key);
  var mainTextStyle = TextStyle(
    fontFamily: 'LINESeedKR',
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
                Text('아래 버튼을 눌러 회원가입을 진행하십시오.', style: TextStyle(fontSize: 15, fontFamily: 'LINESeedKR')),
                Container(height: 50,),
                Row(children: [
                  Flexible(child: TextButton(onPressed: (){context.read<InfoStore>().changeType('student'); nextPage(context);}, child: Image.asset('assets/studentButtonIcon.png', fit: BoxFit.fitHeight,) ), flex: 1, ),
                  Flexible(child: TextButton(onPressed: (){context.read<InfoStore>().changeType('parent'); nextPage(context); }, child: Image.asset('assets/parentButtonIcon.png', fit: BoxFit.fill,)), flex: 1, ),

                ],),
                TextButton(onPressed: (){context.read<InfoStore>().changeType('teacher'); nextPage(context); }, child: Image.asset('assets/teacherButtonIcon.png')),
                TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (c) => Login()));}, child: Text('회원가입을 하셨나요? 이 곳을 클릭해 로그인하세요', style: TextStyle(fontSize: 15, color: Colors.black),)),

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
                child: Text('이름을 입력하세요', style: TextStyle(fontSize: 30, fontFamily: 'LINESeedKR'),)),
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
                    MaterialPageRoute(builder: (context) => EmailInfoPage()));
                print(str);
              }
              else {}
            },
            child: Text('다음', style: TextStyle(
              fontFamily: 'LINESeedKR',
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
            timeInSecForIosWeb: 2,
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
  // 파이어베이스에 이름, type 등 저장
  Future<dynamic> StoreAtFireStore() async{
    try {
      final user = await FirebaseAuth.instance.currentUser;
      await firestore.collection('Person').doc(user?.uid).
      set({'name' : context.read<InfoStore>().name, 'type' : context.read<InfoStore>().type, 'point' : 50});
      // 유저스토어에 사용자 정보 저장 = 바로 데이터 꺼내쓸 수 있게
      context.read<UserStore>().setName(context.read<InfoStore>().name);
      context.read<UserStore>().setType(context.read<InfoStore>().type);
      context.read<UserStore>().setUserUID(user!.uid);
      context.read<UserStore>().setPoint(50);

    } catch (e) {
      print(e);
    }

  }

  // 이메일과 휴대폰 계정 연결
  Future<dynamic> signWithPhoneLinkEmail(PhoneAuthCredential phoneAuthCredential) async{
    try {
      final userCredential = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(phoneAuthCredential);
      Fluttertoast.showToast(
          msg: '회원가입이 정상적으로 완료되었습니다',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          fontSize: 12
      );
      //파이어스토어에 사용자 정보 등록
      await StoreAtFireStore();

      // 자동 로그인을 위한 사용자 계정 휴대폰 내부에 암호화 저장
      final storage = new FlutterSecureStorage();
      await storage.write(key: 'id', value: context.read<InfoStore>().email);
      await storage.write(key: 'password', value: context.read<InfoStore>().password);

      //메인 페이지로 이동
      if (context.read<UserStore>().type.compareTo('teacher') == 0) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => mainPage()), (route) => false);
      }
      else if (context.read<UserStore>().type.compareTo('student') == 0) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => mainPageS()), (route) => false);
      }

    } on FirebaseAuthException catch (e) {
      setState(() {
        context.read<InfoStore>().popSmsCode();
      });
      print(e);
      if(e.code == 'invalid-verification-code') {
        Fluttertoast.showToast(
            msg: '인증번호가 올바르지 않습니다',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            fontSize: 12
        );
      } else {
        Fluttertoast.showToast(
            msg: e.code,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            fontSize: 12
        );
      }

    }

}
//변수, 함수 끝
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
                child: Text('전화번호를 입력하세요', style: TextStyle(fontSize: 30, fontFamily: 'LINESeedKR'),)),
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
                  fontFamily: 'LINESeedKR',
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
                child: Text('인증번호를 입력하세요', style: TextStyle(fontSize: 30, fontFamily: 'LINESeedKR'),)):Container(),
            IsClickButton? Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                onChanged: (text){
                  context.read<InfoStore>().changeSmsCode(text);
                },
              ),
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
                    fontFamily: 'LINESeedKR',
                    fontSize: 17,
                    color: Colors.white,
                )),
                onPressed: () async{

                  PhoneAuthCredential phoneAuthCredential =
                  PhoneAuthProvider.credential(
                      verificationId: verificationId, smsCode: context.read<InfoStore>().smsCode);
                  await signWithPhoneLinkEmail(phoneAuthCredential); //폰으로 회원가입과 동시에 이메일과 연결


                },
              ),
            ):Container(),

          ],
        ),

      ),
    );
  }
}

// 이메일 및 비밀번호 회원가입 페이지
class EmailInfoPage extends StatefulWidget {
  const EmailInfoPage({Key? key}) : super(key: key);

  @override
  State<EmailInfoPage> createState() => _EmailInfoPageState();
}

class _EmailInfoPageState extends State<EmailInfoPage> {
  //변수, 함수 공간
  final phonecredential = PhoneAuthProvider();


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
                  child: Text('이메일(아이디)을 입력하세요', style: TextStyle(fontSize: 30, fontFamily: 'LINESeedKR'),)),
                 Padding(
                  padding: const EdgeInsets.all(5),
                   child: TextField(
                     onChanged: (text){context.read<InfoStore>().changeEmail(text);},
                    ),
                  ),

                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text('비밀번호를 입력하세요', style: TextStyle(fontSize: 30, fontFamily: 'LINESeedKR'),)),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextField(
                    onChanged: (text){context.read<InfoStore>().changePassword(text);},
                    obscureText: true,
                  ),
                ),

            ]
          ),
        bottomSheet: Container(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 30),
          width: double.infinity,
          height: 90,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
            ),
            onPressed: () async{
              try {
                final credential = await auth.createUserWithEmailAndPassword(
                email: context.read<InfoStore>().email, password: context.read<InfoStore>().password);
                print(credential.user);

                Navigator.push(context, MaterialPageRoute(builder: (context)=>PhoneInfoPage()));

              } on FirebaseAuthException catch(e) {
                Fluttertoast.showToast(
                    msg: e.code,
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.red,
                    fontSize: 12
                );
              }

            },
            child: Text('다음으로', style: TextStyle(
              fontFamily: 'LINESeedKR',
              fontSize: 20,
              color: Colors.white,
            ),),
          ),
        ),


      ),
    );
  }
}


