import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// 앱 토스트알림 띄우는 클래스
class ToastService {
  static void toastMsg(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black,
      fontSize: 12,
    );
  }
}