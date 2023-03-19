// 회원가입 할 때 변수 저장하는 곳
import 'package:flutter/material.dart';

class InfoStore extends ChangeNotifier {
  var type = '';
  var name = '';
  var phone = '';
  var smsCode = '';
  var email = '';
  var password = '';
  popType() {
    type = '';
    notifyListeners();
  }
  popName() {
    name = '';
    notifyListeners();
  }
  popPhone() {
    phone = '';
    notifyListeners();
  }
  popSmsCode() {
    smsCode = '';
    notifyListeners();
  }
  popEmail() {
    email = '';
    notifyListeners();
  }
  popPassword() {
    password = '';
    notifyListeners();
  }
  void allPop() {
    type = '';
    name = '';
    smsCode = '';
    email = '';
    password = '';
    phone = '';
    notifyListeners();
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
  changeSmsCode(String s) {
    smsCode = s;
    notifyListeners();
  }
  changeEmail(String s) {
    email = s;
    notifyListeners();
  }
  changePassword(String s) {
    password = s;
    notifyListeners();
  }
}