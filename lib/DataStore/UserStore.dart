// 유저 정보 저장하는 곳
import 'package:flutter/material.dart';

class UserStore extends ChangeNotifier {
  String name = '';
  String type = '';
  String userUID = '';


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

}