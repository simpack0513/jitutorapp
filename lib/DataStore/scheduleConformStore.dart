// 일정 변경할 때 데이터, 함수 관리
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:jitutorapp/ToastService.dart';

import '../FCMsender.dart';
import '../teacherPage/scheduleConform.dart';

final firestore = FirebaseFirestore.instance;

class ScheduleConformStore extends ChangeNotifier {
  // 변수
  late DocumentSnapshot doc; // Schedule 정보임. 일정 변경 현재 상태를 담는 문서 - 초기에 받아옴
  int count = 0; // 후보 카운터
  List optionClassDate = [];
  List optionClassStarttime = [];
  List optionClassEndtime = [];
  String currentClassName = "";
  String currentClassDate = "";
  String currentClassStarttime = "";
  String currentClassEndtime = "";
  int selectedOption = -1;
  var docContext;
  FCMController fcmControllersender = new FCMController();

  // 함수시작
  Future<void> setDoc(String docUID, var context, bool isMe) async{
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
      docContext = context;

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
      return ;
    }
    /*if (isMe) {
      ToastService.toastMsg('내가 보낸 요청은 확인할 수 없습니다.');
      return ;
    } */
    Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleConform()));
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

  // 일정 변경 수락
  void conformSchedule(String type, String userUID) async{
    Navigator.pop(docContext);
    // 수업 일정 업데이트
    await firestore.collection('Classchild').doc(doc["classChildUID"]).update({
      "date" : doc["listDate"][selectedOption],
      "startTime" : doc["listStartTime"][selectedOption],
      "endTime" : doc["listEndTime"][selectedOption],
      "underChange" : false,
    });
    // 스케쥴 변경 마감
    await doc.reference.delete();
    ToastService.toastMsg('일정 변경 수락이 정상적으로 되었습니다.');
    // 스케쥴 변경 메시지 작성
    String text = '"' +currentClassName + '" 수업이 정상적으로 변경되었습니다.';
    text = text + "\n<변경전>\n닐짜 : " + currentClassDate + "\n시간 : " + currentClassStarttime + " ~ " + currentClassEndtime;
    text = text + "\n<변경후>\n날짜 : " + optionClassDate[selectedOption] + "\n시간 : " + optionClassStarttime[selectedOption] + " ~ " + optionClassEndtime[selectedOption];
    text = text + "\n\n변경 사항을 캘린더에서 한번 더 확인해주세요";
    // 채팅방 정보 가져오기
    DocumentSnapshot classInfo =  await firestore.collection('Class').doc(doc["classUID"]).get();
    DocumentSnapshot chatroomInfo = await firestore.collection('Chatroom').doc(classInfo["parentChatroom"]).get();
    CollectionReference chat = firestore.collection('Chatroom').doc(classInfo["parentChatroom"]).collection('Chat');
    // 최근 메시지 전송 일자와 오늘의 날짜가 다르면 날씨 정보 택스트 업로드
    if (chatroomInfo["lastDate"].toString().split(' ')[0] != DateTime.now().toString().split(' ')[0]) {
      String text_date = DateFormat('yyyy년 M월 d일 E요일', 'ko').format(DateTime.now());
      await chat.add({
        "senderUID" : userUID,
        "text" : text_date,
        "time" : DateTime.now().toString(),
        "type" : "DAT",
        "read" : true,
      });
    }
    // 메시지 전송
    String time = DateTime.now().toString();
    chat.add({
      "senderUID" : userUID,
      "text" : text,
      "time" : time,
      "type" : "DEF",
      "read" : false,
    });
    // 읽지 않은 메시지 카운트 추가
    int _remainMsg;
    String youUID;
    String meName;
    if (type == "teacher") {
      _remainMsg = chatroomInfo["remainMsg3"];
      chatroomInfo.reference.update({
        "lastMsg" : text,
        "lastDate" : time,
        "remainMsg3" : _remainMsg + 1,
      });
      youUID = chatroomInfo["userUID3"];
      meName = chatroomInfo["userName1"];
    }
    else {
      _remainMsg = chatroomInfo["remainMsg1"];
      chatroomInfo.reference.update({
        "lastMsg" : text,
        "lastDate" : time,
        "remainMsg1" : _remainMsg + 1,
      });
      youUID = chatroomInfo["userUID1"];
      meName = chatroomInfo["userName3"];
    }
    // 메시지 알림 보내기
    DocumentSnapshot youDoc = await firestore.collection('Person').doc(youUID).get();
    await fcmControllersender.sendMessage(userToken: youDoc["FCMToken"], title: meName, body: text);
  }

}