// 유저 정보 저장하는 곳
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final firestore = FirebaseFirestore.instance;

class UserStore extends ChangeNotifier {
  String name = '';
  String type = '';
  String userUID = '';
  String FCMToken = '';
  int point = 0;


  void setUserUID(String s) {
    userUID = s;
    notifyListeners();
  }

  void setName(String s) {
    name = s;
    notifyListeners();
  }

  void setType(String s) {
    type = s;
    notifyListeners();
  }

  void setFCMToken(String s) {
    FCMToken = s;
    notifyListeners();
  }

  void setPoint(int num) {
    point = num;
    notifyListeners();
  }

  // 포인트 부여 해서 계산
  void givePoint(int num) {
    point -= num;
    notifyListeners();
  }

  // 현재 기기의 토큰이 데이터베이스에 정상적으로 등록되었는 지 확인, 다르면 업데이트
  void updateDB_FCMToken() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? newtoken= await messaging.getToken();
    try{
      if (FCMToken != newtoken) {
        DocumentReference documentReference = firestore.collection('Person').doc(userUID);
        documentReference.update({
          "FCMToken" : newtoken,
        });
        setFCMToken(newtoken.toString());
      }
      notifyListeners();
    } catch(e) {}

  }

}