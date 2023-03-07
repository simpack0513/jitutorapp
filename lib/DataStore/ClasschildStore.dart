// 캘린더 내 수업 관리
import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jitutorapp/DataStore/ClassStore.dart';
final firestore = FirebaseFirestore.instance;


class Event{
  late QueryDocumentSnapshot doc;
  Event(this.doc);
}

class ClasschildStore extends ChangeNotifier{
  var dateClassList= []; // 달력에 선택할 날짜에 수업
  List<Map> comingClassList = [];

  Map<DateTime, List<Event>> events = {}; // 달력에 마커 표시할 map 자료형

  // 클래스 UID에 맞는 포스트 문서를 받는 함수
  void getDateClassList(List ClassUIDList, String date) async{
    var result = await firestore.collection('Classchild').where("classUID", whereIn: ClassUIDList).where("date", isEqualTo: date).orderBy("startTime", descending: false).get();
    dateClassList = [];
    for (var doc in result.docs) {
      dateClassList.add(doc);
    }
    notifyListeners();
  } //

  // 모든 수업을 받아 날짜 별로 맵 형 자료형으로 바꾸는 함수 (캘린터에 마크 달기)
  void getEventAllday(List ClassUIDList) async{
    events = {};
    String date = "";
    List<Event> list = [];
    var result = await firestore.collection('Classchild').where("classUID", whereIn: ClassUIDList).orderBy("date", descending: false).get();
    for (var doc in result.docs) {
      if (doc["date"] != date) {
        if (list.isNotEmpty) {
          int year = int.parse(date.split('-')[0]);
          int month = int.parse(date.split('-')[1]);
          int day = int.parse(date.split('-')[2]);
          events[DateTime.utc(year,month,day)] = list;
        }
        date = doc["date"];
        list = [];
      }
      list.add(Event(doc));
    }
    if (list.isNotEmpty) {
      int year = int.parse(date.split('-')[0]);
      int month = int.parse(date.split('-')[1]);
      int day = int.parse(date.split('-')[2]);
      events[DateTime.utc(year,month,day)] = list;
    }
    notifyListeners();
  } //


  // 다가오는 수업 데이터베이스에서 받는 함수
  void getComingClassList(List ClassUIDList) async{
    String date;
    DateTime today = DateTime.now();
    comingClassList = [];
    for(int i=1; i<=3; i++) {
      date = today.add(Duration(days: i)).toString().split(' ')[0];
      var result = await firestore.collection('Classchild').where("classUID", whereIn: ClassUIDList).where("date", isEqualTo: date).orderBy("startTime", descending: false).get();
      for(var doc in result.docs) {
        Map map = {};
        map.addAll(doc.data());
        map.putIfAbsent("comingDay", () => i.toString());
        comingClassList.add(map);
      }
      if (comingClassList.length > 5) {
        break;
      }
    }
    notifyListeners();
  } //

  // 현재 날짜가 기준날짜(dates) 한 달 이내일 경우 ClassChild 새로 생성
  Future<void> generateClassChild(var userClassList) async{
    CollectionReference Classchild = FirebaseFirestore.instance.collection('Classchild');
    DateTime oneMonthAfter = DateTime.now().add(Duration(days : 30));
    int i = 0;
    print(userClassList);
    for (var Class in userClassList) {
      List dates = [];
      for(int i=0; i<Class['number']; i++) {
        DateTime ClassDate = DateTime.parse(Class['dates'][i]);
        if (oneMonthAfter.compareTo(ClassDate) >= 0) {
          DateTime twoMonthAfter = oneMonthAfter.add(Duration(days: 30));
          while (twoMonthAfter.compareTo(ClassDate) > 0) {
            String name = Class['classname'].split(' ')[0] + '(' + Class['classname'].split(' ')[1] + ')';
            Classchild.add({
              'classUID' :  Class.id.toString(),
              'date' : ClassDate.toString().split(' ')[0],
              'startTime' : Class['time'][i].split('~')[0],
              'endTime' : Class['time'][i].split('~')[1],
              'name' : name
            });
            ClassDate = ClassDate.add(Duration(days: 7));
          } //while 문 끝
        } // if 문 끝
        dates.add(ClassDate.toString().split(' ')[0]);
      } //for문 끝
      Class.reference.update(
        {'dates' : dates}
      );
    }
  } // Classchild generate 함수 끝




  void delete() async{
    var result = await firestore.collection('Classchild').where("startTime", isEqualTo: "16:30").get();
    for (var doc in result.docs) {
      doc.reference.delete();
    }
  }

} // Class 끝