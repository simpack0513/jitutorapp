// 여기는 연동 페이지
import 'package:jitutorapp/DataStore/UserStore.dart';
import 'package:jitutorapp/ToastService.dart';
import 'package:jitutorapp/parentPage/mainPage.dart';
import 'package:jitutorapp/signUp.dart';

//
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jitutorapp/studentPage/mainPage.dart';
import 'package:jitutorapp/teacherPage/mainPage.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final firestore = FirebaseFirestore.instance;


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //변수, 함수
  var useremail = '';
  var userpassword = '';
  //

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
                  child: Text('이메일(아이디)을 입력하세요', style: TextStyle(fontSize: 30, fontFamily: 'LINESeedKR'),)),
              Padding(
                padding: const EdgeInsets.all(5),
                child: TextField(
                  onChanged: (text){setState(() {
                    useremail = text;
                  });},
                ),
              ),

              Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text('비밀번호를 입력하세요', style: TextStyle(fontSize: 30, fontFamily: 'LINESeedKR'),)),
              Padding(
                padding: const EdgeInsets.all(5),
                child: TextField(
                  onChanged: (text){setState(() {
                    userpassword = text;
                  });},
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => WaitAndRefresh(useremail: useremail, userpassword: userpassword,)));
            },
            child: Text('로그인하기', style: TextStyle(
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


class WaitAndRefresh extends StatefulWidget {
  const WaitAndRefresh({
    Key? key,
    required this.useremail,
    required this.userpassword,
  }) : super(key: key);

  final String useremail;
  final String userpassword;

  @override
  State<WaitAndRefresh> createState() => _WaitAndRefreshState();
}
class _WaitAndRefreshState extends State<WaitAndRefresh> {
  void loginWait() async{
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: widget.useremail, password: widget.userpassword);
      print(credential.user);
      // 만약 휴대폰 인증 전이라면 인증화면으로 이동
      if (credential.user?.phoneNumber == null) {
        ToastService.toastMsg('아직 휴대폰인증 전입니다. 인증페이지로 이동합니다.');
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneInfoPage()));
        return ;
      }

      // 로그인 하는 유저 정보 받아서 로컬 변수에 저장하기
      var result = await firestore.collection('Person').get();
      var userdoc;
      for (var doc in result.docs) {
        if(doc.id == credential.user!.uid) userdoc = doc;
      }
      context.read<UserStore>().setUserUID(credential.user!.uid);
      context.read<UserStore>().setName(userdoc['name']);
      context.read<UserStore>().setPoint(userdoc['point']);
      context.read<UserStore>().setType(userdoc['type']);
      context.read<UserStore>().setFCMToken(userdoc['FCMToken']);
      // 휴대폰 내부 저장소에 아이디, 비번 기록
      final storage = new FlutterSecureStorage();
      await storage.write(key: 'id', value: widget.useremail);
      await storage.write(key: 'password', value: widget.userpassword);

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


    } on FirebaseAuthException catch(e) {
      if (widget.useremail == '') {
        ToastService.toastMsg('아이디를 입력해주세요.');
      }
      else if (widget.userpassword == '') {
        ToastService.toastMsg('비밀번호를 입력해주세요.');
      }
      else if (e.code == 'invalid-email') {
        ToastService.toastMsg('아이디를 올바른 이메일 양식으로 입력해주세요.');
      }
      else if (e.code == 'user-not-found') {
        ToastService.toastMsg('찾을 수 없는 유저의 아이디입니다.');
      }
      else if (e.code == 'network-request-failed') {
        ToastService.toastMsg('인터넷 연결을 확인하세요.');
      }
      else if (e.code == 'wrong-password') {
        ToastService.toastMsg('비밀번호가 잘못되었습니다.');
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
    loginWait();
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
