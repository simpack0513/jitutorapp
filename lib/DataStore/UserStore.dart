// 유저 정보 저장하는 곳
import 'package:flutter/material.dart';

class UserStore extends ChangeNotifier {
  String name = '';
  String type = '';

  void setName(String s) {
    name = s;
    notifyListeners();
  }

  void setType(String s) {
    type = s;
    notifyListeners();
  }

}