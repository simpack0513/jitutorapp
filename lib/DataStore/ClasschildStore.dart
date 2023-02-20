// 캘린더 내 수업 관리
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final firestore = FirebaseFirestore.instance;


class ClasschildStore extends ChangeNotifier{
  var dateClassList= []; // 달력에 선택할 날짜에 수업

  // 클래스 UID에 맞는 포스트 문서를 받는 함수
  void getDateClassList(List ClassUIDList, String date) async{
    dateClassList = [];
    var result = await firestore.collection('Classchild').where("classUID", whereIn: ClassUIDList).where("date", isEqualTo: date).orderBy("startTime", descending: false).get();
    for (var doc in result.docs) {
      dateClassList.add(doc);
    }
    notifyListeners();
  } //

}