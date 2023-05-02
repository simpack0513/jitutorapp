import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jitutorapp/parentPage/mainPage.dart';
import 'package:jitutorapp/signUp.dart';
import 'package:jitutorapp/studentPage/mainPage.dart';
import 'package:jitutorapp/teacherPage/mainPage.dart';
import 'package:provider/provider.dart';

import 'DataStore/UserStore.dart';
final firestore = FirebaseFirestore.instance;

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  void checkLoginInfo() async{
    sleep(Duration(seconds: 1));
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

    String? idValue = await storage.read(key: 'id');
    String? passwordValue = await storage.read(key: 'password');

    if (idValue == null || passwordValue == null) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => signUp()));
    }
    else {
      try {
        final credential = await auth.signInWithEmailAndPassword(
            email: idValue, password: passwordValue);
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
        context.read<UserStore>().setFCMToken(userdoc['FCMToken']);

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
        else {
          Fluttertoast.showToast(
              msg: '자동 로그인에 실패하였습니다. 다시 로그인을 진행해주세요.',
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              fontSize: 12
          );
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => signUp()));
        }

      } on FirebaseAuthException catch(e) {
        Fluttertoast.showToast(
            msg: '자동 로그인에 실패하였습니다. 다시 로그인을 진행해주세요.',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            fontSize: 12
        );
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => signUp()));
      }
    }

  }


  @override
  void initState() {
    checkLoginInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Image.asset('assets/loading.jpg', fit: BoxFit.fill,),
    );
  }
}

