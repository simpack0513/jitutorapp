// 일정 변경할 때 데이터, 함수 관리
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jitutorapp/ToastService.dart';

final firestore = FirebaseFirestore.instance;

class ScheduleConformStore extends ChangeNotifier {
  // 변수
  late DocumentSnapshot doc; // Classchild 정보임. 일정 변경 현재 상태를 담는 문서 - 초기에 받아옴
  int count = 0; // 후보 카운터
  List optionClassDate = [];
  List optionClassStarttime = [];
  List optionClassEndtime = [];
  String currentClassName = "";
  String currentClassDate = "";
  String currentClassStarttime = "";
  String currentClassEndtime = "";

  // 함수시작
  Future<void> setDoc(String docUID, var context) async{
    try {
      count = 0; // 후보 카운터
      optionClassDate = [];
      optionClassStarttime = [];
      optionClassEndtime = [];
      currentClassName = "";
      currentClassDate = "";
      currentClassStarttime = "";
      currentClassEndtime = "";

      doc = await firestore.collection('Schedule').doc(docUID).get();
      count = doc["listDate"].length;
      optionClassDate = doc["listDate"];
      optionClassStarttime = doc["listStartTime"];
      optionClassEndtime = doc["listEndTime"];
      currentClassName = doc["name"];
      currentClassDate = doc["currentDate"];
      currentClassStarttime = doc["currentStartTime"];
      currentClassEndtime = doc["currentEndTime"];

      notifyListeners();
    }
    catch (e){
      ToastService.toastMsg('이미 만료된 일정 변경 요청입니다.');
      Navigator.pop(context);
    }
  }
}