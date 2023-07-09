// 유저가 가지고 있는 클래스 저장하는 곳
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final firestore = FirebaseFirestore.instance;

class ClassStore extends ChangeNotifier{
  var userClassList = [];
  var userClassNameList = [];
  var userClassUIDList = [];
  var userClassListAtHome = []; // 홈화면 출력용

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
  // 학생 사용자의 UID에 맞는 클래스 정보만 받아와 userClassList에 저장
  Future<void> studentGetClassFromFirebase(String UID) async{
    userClassList = [];
    userClassNameList = [];
    userClassUIDList = [];
    var result = await firestore.collection('Class').get();
    for (var doc in result.docs) {
      if(doc['studentUID'] == UID) {
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

  // 학부모 사용자의 UID에 맞는 클래스 정보만 받아와 userClassList에 저장
  Future<void> parentGetClassFromFirebase(String UID) async{
    userClassList = [];
    userClassNameList = [];
    userClassUIDList = [];
    var result = await firestore.collection('Class').get();
    for (var doc in result.docs) {
      if(doc['parentUID'] == UID) {
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

  // 클래스 리스트를 가공하여 홈화면에 제공
  void makeHomeList() {
    userClassListAtHome = [];
    for (int i = 0; i < userClassList.length; i++) {
      String imageSrc = "";
      if (userClassNameList[i].toString().split(' ')[1].compareTo('수학') == 0) {
        imageSrc = "https://firebasestorage.googleapis.com/v0/b/jitutor.appspot.com/o/asset%2Fmath.png?alt=media&token=2e38d495-7ce3-40d5-8492-32f37dbd461d";
      }
      else if (userClassNameList[i].toString().split(' ')[1].compareTo('영어') == 0) {
        imageSrc = "https://firebasestorage.googleapis.com/v0/b/jitutor.appspot.com/o/asset%2Fenglish.png?alt=media&token=aaaf61d9-a692-4ddc-abab-2d9787cb93c0";
      }
      String className = "";
      className = userClassNameList[i].toString().split(' ')[0] + ' 학생 -' + userClassNameList[i].toString().split('-')[1];

      String startDate = "";
      startDate = userClassList[i]['startdate'].toString().split('-')[0]+'년 '+userClassList[i]['startdate'].toString().split('-')[1] + '월 '+userClassList[i]['startdate'].toString().split('-')[2] +'일';

      String classTime = "";
      for (int j=0; j < userClassList[i]['time'].length; j++) {
        if (j != 0) {
          classTime += '\n';
        }
        classTime += "매주 " + userClassList[i]['weeks'][j].toString() + " " + userClassList[i]['time'][j].toString();
      }

      userClassListAtHome.add({
        'image' : imageSrc,
        'className' : className,
        'startDate' : startDate,
        'classTime' : classTime,
      });
    }
    notifyListeners();
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