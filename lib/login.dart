// 여기는 연동 페이지
import 'package:jitutorapp/DataStore/UserStore.dart';
import 'package:jitutorapp/signUp.dart';

//
import 'package:flutter/material.dart';
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
                  child: Text('이메일(아이디)을 입력하세요', style: TextStyle(fontSize: 30, fontFamily: 'Pretedard'),)),
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
                  child: Text('비밀번호를 입력하세요', style: TextStyle(fontSize: 30, fontFamily: 'Pretedard'),)),
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
            onPressed: () async{
              try {
                final credential = await auth.signInWithEmailAndPassword(
                    email: useremail, password: userpassword);
                print(credential.user);
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
                //메인 페이지로 이동
                if (context.read<UserStore>().type.compareTo('teacher') == 0) {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) => mainPage()), (route) => false);
                }
                else if (context.read<UserStore>().type.compareTo('student') == 0) {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) => mainPageS()), (route) => false);
                }


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
            child: Text('로그인하기', style: TextStyle(
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
