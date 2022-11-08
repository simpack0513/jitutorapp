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
  }
  popName() {
    name = '';
  }
  popPhone() {
    phone = '';
  }
  popSmsCode() {
    smsCode = '';
  }
  popEmail() {
    email = '';
  }
  popPassword() {
    password = '';
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