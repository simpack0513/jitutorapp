// 유저 정보 저장하는 곳
import 'package:flutter/material.dart';

class UserStore extends ChangeNotifier {
  String name = '';
  String type = '';
  String userUID = '';
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

  void setPoint(int num) {
    point = num;
    notifyListeners();
  }

  // 포인트 부여 해서 계산
  void givePoint(int num) {
    point -= num;
    notifyListeners();
  }

}