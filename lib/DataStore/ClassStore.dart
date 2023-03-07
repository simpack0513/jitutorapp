// 유저가 가지고 있는 클래스 저장하는 곳
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final firestore = FirebaseFirestore.instance;

class ClassStore extends ChangeNotifier{
  var userClassList = [];
  var userClassNameList = [];
  var userClassUIDList = [];

  // 선생님 사용자의 UID에 맞는 클래스 정보만 받아와 userClassList에 저장
  Future<void> teacherGetClassFromFirebase(String UID) async{
    userClassList = [];
    userClassNameList = [];
    userClassUIDList = [];
    var result = await firestore.collection('Class').get();
    for (var doc in result.docs) {
      if(doc['teacherUID'] == UID) {
        userClassList.add(doc);
        userClassNameList.add(doc['classname']);
        userClassUIDList.add(doc.id.toString());
      }
    }
    if(userClassList.isEmpty) {
      userClassList.add('NULL');
      userClassNameList.add('현재 담당하는 수업이 없습니다.');
    }
    notifyListeners();
    print(userClassList);
    print(userClassNameList);
  }
  // 클래스 이름과 똑같은 클래스 문서 ID 반환
  String getClassUID(String classname) {
      for (var doc in userClassList) {
        if(doc['classname'] == classname) {
          return doc.id.toString();
        }
      }
      return 'null';
  }

  // 클래스 특정 인덱스만 데이터베이스에서 다시 get하기
  void teacherGetClassWithIndex(DocumentReference docRef, int idx) async{
    await docRef.get().then((value) => userClassList[idx] = value);
  }



}