// 수업 생성 때 사용하는 클래스
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

final firestore = FirebaseFirestore.instance;

class RegisterClassStore extends ChangeNotifier{
  String className = "";
  int number = 1;

  void init() {
    className = "";
    number = 1;
  }

  void setFirstPage(String studentName, String subject, String teacherName) {
    className = studentName + " " + subject + " 수업 - " + teacherName + " 선생님";
    notifyListeners();
  }
  void setNumber(int num) {
    number = num;
    notifyListeners();
  }

}