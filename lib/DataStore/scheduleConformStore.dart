// 일정 변경할 때 데이터, 함수 관리
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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
  int selectedOption = -1;

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
      selectedOption = -1;

      doc = await firestore.collection('Schedule').doc(docUID).get();
      count = doc["listDate"].length;
      currentClassName = doc["name"];
      currentClassDate = doc["currentDate"] + dateToS(doc["currentDate"]);
      currentClassStarttime = doc["currentStartTime"];
      currentClassEndtime = doc["currentEndTime"];
      for(int i=0; i<count; i++) {
        optionClassDate.add(doc["listDate"][i] + dateToS(doc["listDate"][i]));
        optionClassStarttime.add(doc["listStartTime"][i]);
        optionClassEndtime.add(doc["listEndTime"][i]);
      }

      notifyListeners();
    }
    catch (e){
      ToastService.toastMsg('이미 만료된 일정 변경 요청입니다.');
      Navigator.pop(context);
    }
  }

  String dateToS(String currentDate) {
    DateTime currentDatetime = DateTime.parse(currentDate);
    int difference = currentDatetime.difference(DateTime.now()).inDays;
    int todayWeekend = DateTime.now().weekday;
    DateFormat dateformat = DateFormat.EEEE('ko');
    String week = "";
    if (difference + todayWeekend <= 7) {
      week = " (이번주 ";
      week += dateformat.format(currentDatetime);
      week += ")";
    }
    else if (difference + todayWeekend <= 14) {
      week = " (다음주 ";
      week += dateformat.format(currentDatetime);
      week += ")";
    }
    else {
      week = "";
    }
    return week;
  }

  // 후보 선택 함수
  void choiceOption(int num) {
    selectedOption = num;
    notifyListeners();
  }

}