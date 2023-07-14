import 'dart:io';
//여기는 일반 파일 import 하는 곳
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jitutorapp/login.dart';
import 'package:jitutorapp/parentPage/mainPage.dart';
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

import 'ToastService.dart';
import 'mainLodding.dart';

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

  void nextPage(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => NameInfoPage()));
  }

  @override
  Widget build(BuildContext context) {
    var mainTextStyle = TextStyle(
      fontFamily: 'LINESeedKR',
      fontSize: MediaQuery.of(context).size.height * 0.055,
    );
    var mainUnderTextStyle = TextStyle(
      fontFamily: 'LINESeedKR',
      fontSize: MediaQuery.of(context).size.height * 0.022,
    );
    var bottomTextStyle = TextStyle(
      fontFamily: 'LINESeedKR',
      fontSize: MediaQuery.of(context).size.height * 0.018,
      color: Colors.black
    );

    return ChangeNotifierProvider(
      create: (c) => InfoStore(),
      child: Scaffold(
        backgroundColor: Color(0xffD6E8F3),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: MediaQuery.of(context).size.height * 0.13,),
            Text('지튜터', style: mainTextStyle,),
            Text('과외 일정 관리 앱', style: mainUnderTextStyle),
            Container(height: MediaQuery.of(context).size.height * 0.01,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: Image.asset('assets/mainImage.png', fit: BoxFit.fitWidth, opacity: const AlwaysStoppedAnimation(.85)),
            ),
            Container(height: MediaQuery.of(context).size.height * 0.05,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 4,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c) => Login()));
                },
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.72,
                  child: Row(
                    children: [
                      Icon(Icons.mail_outline_rounded, color: Colors.black, size: MediaQuery.of(context).size.height * 0.03,),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.72 - MediaQuery.of(context).size.height * 0.05,
                          child: Text('이메일로 로그인하기', style: bottomTextStyle, textAlign: TextAlign.center,)
                      ),
                    ],
                  ),
                )
            ),
            Container(height: MediaQuery.of(context).size.height * 0.015,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 4,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                ),
                onPressed: (){
                  Dialog(context);
                },
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.72,
                  child: Row(
                    children: [
                      Icon(Icons.fiber_new_outlined, color: Colors.black, size: MediaQuery.of(context).size.height * 0.03,),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.72 - MediaQuery.of(context).size.height * 0.05,
                          child: Text('회원가입 하기', style: bottomTextStyle, textAlign: TextAlign.center,)
                      ),
                    ],
                  ),
                )
            ),

          ],
        ),

      ),
    );
  }

  // 회원 가입 유형 선택하는 다이얼로그
  void Dialog(var context) {
    var mainTextStyle = TextStyle(
      fontFamily: 'LINESeedKR',
      fontSize: MediaQuery.of(context).size.height * 0.022,
    );
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.all(10),
            title: Center(
                child: Text('가입 유형을 골라주세요', style: mainTextStyle)),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    Flexible(child: TextButton(onPressed: (){context.read<InfoStore>().changeType('student'); nextPage(context);}, child: Image.asset('assets/studentButtonIcon.png', fit: BoxFit.fitHeight,) ), flex: 1, ),
                    Flexible(child: TextButton(onPressed: (){context.read<InfoStore>().changeType('parent'); nextPage(context); }, child: Image.asset('assets/parentButtonIcon.png', fit: BoxFit.fill,)), flex: 1, ),
                  ],),
                  TextButton(onPressed: (){context.read<InfoStore>().changeType('teacher'); nextPage(context); }, child: Image.asset('assets/teacherButtonIcon.png')),
                ],
              ),
            )
          );
        });
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
          print(verificationFailed.code);
          if (verificationFailed.code == 'invalid-phone-number') {
            ToastService.toastMsg('올바른 전화번호를 입력하세요.');
          }
          else if (verificationFailed.code == 'network-request-failed') {
            ToastService.toastMsg('인터넷 연결을 확인하세요.');
          }
          else {
            ToastService.toastMsg(verificationFailed.code);
          }
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
                  //폰으로 회원가입과 동시에 이메일과 연결
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WaitAndRefresh2(phoneAuthCredential: phoneAuthCredential,)));

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
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => WaitAndRefresh()));
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

// 이메일 회원가입 로딩 페이지
class WaitAndRefresh extends StatefulWidget {
  const WaitAndRefresh({
    Key? key,
  }) : super(key: key);

  @override
  State<WaitAndRefresh> createState() => _WaitAndRefreshState();
}
class _WaitAndRefreshState extends State<WaitAndRefresh> {
  void registerUserWithEmailAndWait() async{
    try {
      final credential = await auth.createUserWithEmailAndPassword(
          email: context.read<InfoStore>().email, password: context.read<InfoStore>().password);
      print(credential.user);

      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>PhoneInfoPage()));

    } on FirebaseAuthException catch(e) {
      if (context.read<InfoStore>().email == '') {
        ToastService.toastMsg('아이디를 입력해주세요.');
      }
      else if (context.read<InfoStore>().password == '') {
        ToastService.toastMsg('비밀번호를 입력해주세요.');
      }
      else if (e.code == 'invalid-email') {
        ToastService.toastMsg('아이디를 올바른 이메일 양식으로 입력해주세요.');
      }
      else if (e.code == 'network-request-failed') {
        ToastService.toastMsg('인터넷 연결을 확인하세요.');
      }
      else if (e.code == 'weak-password') {
        ToastService.toastMsg('비밀번호가 너무 단순합니다.');
      }
      else if (e.code == 'email-already-in-use') {
        context.read<InfoStore>().popEmail();
        context.read<InfoStore>().popPassword();
        context.read<InfoStore>().popName();
        context.read<InfoStore>().popType();
        ToastService.toastMsg('이미 존재하는 회원입니다. 로그인을 진행하세요.');
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => signUp()), (route) => false);
        return ;
      }
      else {
        Fluttertoast.showToast(
            msg: e.code,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            fontSize: 12
        );
      }
      Navigator.pop(context);
    }
  }
  @override
  void initState() {
    registerUserWithEmailAndWait();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

// 휴대폰 인증 로딩페이지
class WaitAndRefresh2 extends StatefulWidget {
  const WaitAndRefresh2({
    Key? key,
    required this.phoneAuthCredential,
  }) : super(key: key);

  final phoneAuthCredential;

  @override
  State<WaitAndRefresh2> createState() => _WaitAndRefresh2State();
}
class _WaitAndRefresh2State extends State<WaitAndRefresh2> {
  // 파이어베이스에 이름, type 등 저장
  Future<dynamic> StoreAtFireStore() async{
    try {
      final user = await FirebaseAuth.instance.currentUser;
      await firestore.collection('Person').doc(user?.uid).
      set({'name' : context.read<InfoStore>().name, 'type' : context.read<InfoStore>().type, 'point' : 50, 'FCMToken' : ""});
      // 유저스토어에 사용자 정보 저장 = 바로 데이터 꺼내쓸 수 있게
      context.read<UserStore>().setName(context.read<InfoStore>().name);
      context.read<UserStore>().setType(context.read<InfoStore>().type);
      context.read<UserStore>().setUserUID(user!.uid);
      context.read<UserStore>().setPoint(50);

    } catch (e) {
      print(e);
    }

  }

  void registerUserWithPhoneAndWait() async{
    try {
      final userCredential = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(widget.phoneAuthCredential);
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
      else if (context.read<UserStore>().type.compareTo('parent') == 0) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => mainPageP()), (route) => false);
      }
      return ;

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
      }
      else if (e.code == 'network-request-failed') {
        ToastService.toastMsg('인터넷 연결을 확인하세요.');
      }
      else if (e.code == 'credential-already-in-use') {
        ToastService.toastMsg('이미 가입된 전화번호 입니다.');
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => signUp()), (route) => false);
        return ;
      }
      else {
        Fluttertoast.showToast(
            msg: e.code,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            fontSize: 12
        );
      }
      Navigator.pop(context);
    }
  }
  @override
  void initState() {
    registerUserWithPhoneAndWait();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}