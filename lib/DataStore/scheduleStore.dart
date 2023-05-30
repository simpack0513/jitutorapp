// 일정 변경할 때 데이터, 함수 관리
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../FCMsender.dart';

final firestore = FirebaseFirestore.instance;

class ScheduleStore extends ChangeNotifier {
  // 변수
  var doc; // Classchild 정보임. 일정 변경 현재 상태를 담는 문서 - 초기에 받아옴
  int count = 2; // 후보 카운터
  late int idx;
  late String currentName;
  late String currentDate;
  late String currentStartTime;
  late String currentEndTime;
  late String type;

  late String listName;
  List listDate = [];
  List listStartTime = [];
  List listEndTime = [];

  int timelength = 0;
  late String docId;

  // 앱 푸시 알림 컨트롤러
  FCMController fcmControllersender = new FCMController();

  //

  //함수시작
  Future<void> setDoc(var document, String id, int i, String _type) async{
    doc = document;
    docId = id;
    idx = i;
    type = _type;
    currentName = doc['name'];
    currentDate = doc['date'];
    currentStartTime = doc['startTime'];
    currentEndTime = doc['endTime'];
    count = 2;
    listDate = []; listEndTime = []; listStartTime = [];
    listName = currentName; listDate.add(currentDate);
    listStartTime.add(currentStartTime); listEndTime.add(currentEndTime);

    String tmp = currentDate + ' ' + currentEndTime;
    String tmp2 = currentDate + ' ' + currentStartTime;
    DateTime end = DateTime.parse(tmp);
    DateTime start = DateTime.parse(tmp2);
    timelength = end.difference(start).inMinutes; // 수업 시간 몇 분인지 계산

    notifyListeners();
  }

  // 시간 바꾸기 startTime => 수업 시간에 따라 endTime도 자동으로 바꿔줌
  void setListStartTime(String text, int i) {
    listStartTime[i] = text;
    String tmp = currentDate + ' ' + listStartTime[i];
    DateTime start = DateTime.parse(tmp);
    start = start.add(Duration(minutes: timelength));
    listEndTime[i] = DateFormat('HH:mm').format(start).toString();
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
  // 날짜 변경 해주는 기능
  void changeDate(int i, String str) {
    listDate[i] = str;
    notifyListeners();
  }

  // 변경 사항 업로드
  Future<void> uploadData(bool checkBoxBool, String myUID, String myType, String name) async{
    CollectionReference ref = firestore.collection('Schedule');
    DocumentReference classRef = firestore.collection('Class').doc(doc["classUID"]);
    try {
      // 일정 변경 내용 등록
     var scheduleDoc = await ref.add({ //scheduleDoc는 콜렉션에 add하고 그 reference를 바로 받는다.
        'classUID' : doc['classUID'],
        'currentDate' : currentDate,
        'currentStartTime' : currentStartTime,
        'currentEndTime' : currentEndTime,
        'name' : currentName,
        'listDate' : listDate,
        'listStartTime' : listStartTime,
        'listEndTime' : listEndTime,
        'checkBox' : checkBoxBool,
        'classChildUID' : docId,
     });
     // 일정 변경 메시지 전송
      DocumentSnapshot classDoc = await classRef.get();
      String chatroomUID = classDoc["parentChatroom"];
      CollectionReference chatRef = firestore.collection('Chatroom').doc(chatroomUID).collection('Chat');
      DocumentReference chatroomRef = firestore.collection('Chatroom').doc(chatroomUID);
      String youUID = "";
      String myName = "";
      String youType;
      if (myType == "teacher") {
        youType = "학부모님";
        youUID = classDoc["parentUID"];
        myName = name + " 선생님";
      }
      else {
        youType = "선생님";
        youUID = classDoc["teacherUID"];
        myName = name + " 학부모님";
      }
      DateTime currentDatetime = DateTime.parse(currentDate);
      int difference = currentDatetime.difference(DateTime.now()).inDays;
      int todayWeekend = DateTime.now().weekday;
      DateFormat dateformat = DateFormat.EEEE('ko');
      DateFormat dateFormat2 = DateFormat('(M월 d일)');
      DateFormat dateFormat3 = DateFormat('M월 d일');
      String week = "";
      if (difference + todayWeekend <= 7) {
        week = "이번주 ";
        week += dateformat.format(currentDatetime);
        week += dateFormat2.format(currentDatetime);
      }
      else if (difference + todayWeekend <= 14) {
        week = "다음주 ";
        week += dateformat.format(currentDatetime);
        week += dateFormat2.format(currentDatetime);
      }
      else {
        week = dateFormat3.format(currentDatetime);
      }
      String text = "안녕하세요 " + youType+ "\n" + week + " 수업을 변경하고자 연락드립니다.\n아래 버튼을 클릭해 확인해주세요.";

     DocumentSnapshot chatroomDoc = await chatroomRef.get();

     if (chatroomDoc["lastDate"].toString().split(' ')[0] != DateTime.now().toString().split(' ')[0]) {
       String text_date = DateFormat('yyyy년 M월 d일 E요일', 'ko').format(DateTime.now());
       await chatRef.add({
         "senderUID" : myUID,
         "text" : text_date,
         "time" : DateTime.now().toString(),
         "type" : "DAT",
         "read" : true,
       });
     }

      await chatRef.add({
        "read" : false,
        "senderUID" : myUID,
        "text" : text,
        "time" : DateTime.now().toString(),
        "type" : "CHS",
        "scheduleUID" : scheduleDoc.id,
      });

      if (myType == "teacher") {

        int remainMsg3 = chatroomDoc["remainMsg3"];
        await chatroomRef.update({
          "lastMsg" : text,
          "lastDate" : DateTime.now().toString(),
          "remainMsg3" : remainMsg3 + 1,
        });
      }
      else {
        int remainMsg1 = chatroomDoc["remainMsg1"];
        await chatroomRef.update({
          "lastMsg" : text,
          "lastDate" : DateTime.now().toString(),
          "remainMsg1" : remainMsg1 + 1,
        });
      }

      DocumentSnapshot youDoc = await firestore.collection('Person').doc(youUID).get();
      await fcmControllersender.sendMessage(userToken: youDoc["FCMToken"], title: myName, body: text);

    } catch (e) {
      Fluttertoast.showToast(
        msg: '일정 변경에 실패하였습니다. 다시 시도해주세요.',
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        fontSize: 12,
      );
      print(e);
      return ;
    }
    var result = await firestore.collection('Classchild').doc(docId).get();
    await result.reference.update({
      'underChange' : true,
    });

    Fluttertoast.showToast(
      msg: '일정 변경 요청에 성공하였습니다.',
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black,
      fontSize: 12,
    );
  }

}