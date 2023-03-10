// 일정 변경할 때 데이터, 함수 관리
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final firestore = FirebaseFirestore.instance;

class ScheduleStore extends ChangeNotifier {
  // 변수
  var doc; // 일정 변경 현재 상태를 담는 문서 - 초기에 받아옴
  int count = 2; // 후보 카운터
  late String currentName;
  late String currentDate;
  late String currentStartTime;
  late String currentEndTime;

  late String listName;
  List listDate = [];
  List listStartTime = [];
  List listEndTime = [];

  //

  //함수시작
  Future<void> setDoc(var document) async{
    doc = document;
    currentName = doc['name'];
    currentDate = doc['date'];
    currentStartTime = doc['startTime'];
    currentEndTime = doc['endTime'];
    count = 2;
    listDate = []; listEndTime = []; listStartTime = [];
    listName = currentName; listDate.add(currentDate);
    listStartTime.add(currentStartTime); listEndTime.add(currentEndTime);
    notifyListeners();
  }

  // 시간 바꾸기 startTime
  void setListStartTime(String text, int i) {
    listStartTime[i] = text;
    notifyListeners();
  }
  // 시간 바꾸기 endTiem
  void setListEndTime(String text, int i) {
    listEndTime[i] = text;
    notifyListeners();
  }
  // 변경 후보 추가 기능
  void addSchedule() {
    listDate.add(currentDate);
    listStartTime.add(currentStartTime); listEndTime.add(currentEndTime);
    count += 1;
    notifyListeners();
  }
  // 변경 후보 삭제 기능
  void deleteSchedule(int i) {
    listDate.removeAt(i); listStartTime.removeAt(i); listEndTime.removeAt(i);
    count -= 1;
    notifyListeners();
  }


}