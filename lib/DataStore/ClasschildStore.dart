// 캘린더 내 수업 관리
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../FCMsender.dart';
final firestore = FirebaseFirestore.instance;


class Event{
  late QueryDocumentSnapshot doc;
  Event(this.doc);
}

class ClasschildStore extends ChangeNotifier{
  FCMController fcmControllersender = new FCMController();
  var dateClassList= []; // 달력에 선택할 날짜에 수업
  List<Map> comingClassList = [];
  var comingClassListDoc = [];
  List classUIDList = [];
  String date = '';
  int idx = 0; // 특정 classChild 인덱스
  Map<DateTime, List<Event>> events = {}; // 달력에 마커 표시할 map 자료형
  var allClasschild = []; // 현재 수업에 속해 있는 모든 Classchild
  List<Map> payList = [];

  // 클래스 UID에 맞는 포스트 문서를 받는 함수
  void getDateClassList(List ClassUIDList, String _date) async{
    var result = await firestore.collection('Classchild').where("classUID", whereIn: ClassUIDList).where("date", isEqualTo: _date).orderBy("startTime", descending: false).get();
    dateClassList = [];
    for (var doc in result.docs) {
      dateClassList.add(doc);
    }
    if (classUIDList.isEmpty) {
      for (var value in ClassUIDList) {
        classUIDList.add(value);
      }
    }
    date = _date;
    notifyListeners();
  } //

  // 모든 수업을 받아 날짜 별로 맵 형 자료형으로 바꾸는 함수 (캘린터에 마크 달기)
  void getEventAllday(List ClassUIDList) async{
    events = {};
    String date = "";
    List<Event> list = [];
    allClasschild = [];
    var result = await firestore.collection('Classchild').where("classUID", whereIn: ClassUIDList).orderBy("date", descending: false).get();
    for (var doc in result.docs) {
      allClasschild.add(doc);
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
    classPay(ClassUIDList);
  } //


  // 다가오는 수업 데이터베이스에서 받는 함수
  void getComingClassList(List ClassUIDList) async{
    String date;
    DateTime today = DateTime.now();
    comingClassList = [];
    comingClassListDoc = [];
    date = today.toString().split(' ')[0];
    // 오늘 일정 중 아직 시간이 안 지난 수업만 출력
    var result = await firestore.collection('Classchild').where("classUID", whereIn: ClassUIDList).where("date", isEqualTo: date).orderBy("startTime", descending: false).get();
    for(var doc in result.docs) {
      String hour = doc['startTime'].split(':')[0];
      String min = doc['startTime'].split(':')[1];
      String classTimeString = doc['date'] + ' ' + hour + ':' + min + ':00';
      DateTime time = DateTime.parse(classTimeString);
      if (today.compareTo(time) < 0) {
        Duration dateDiff = time.difference(today);
        String comingDayString;
        if (dateDiff.inMinutes < 60) {
          comingDayString = dateDiff.inMinutes.toString() + ' 분후';
        }
        else {
          comingDayString = dateDiff.inHours.toString() + ' 시간후';
        }
        Map map = {};
        map.addAll(doc.data());
        map.putIfAbsent("comingDay", () => comingDayString);
        map.putIfAbsent("id", () => doc.id.toString());
        comingClassList.add(map);
        comingClassListDoc.add(doc);
      }
    }

    for(int i=1; i<=3; i++) { // 1일후, 2일후, 3일후 일정까지 받는 함수
      date = today.add(Duration(days: i)).toString().split(' ')[0];
      var result = await firestore.collection('Classchild').where("classUID", whereIn: ClassUIDList).where("date", isEqualTo: date).orderBy("startTime", descending: false).get();
      for(var doc in result.docs) {
        Map map = {};
        map.addAll(doc.data());
        map.putIfAbsent("comingDay", () => i.toString() + ' 일후');
        map.putIfAbsent("id", () => doc.id.toString());
        comingClassList.add(map);
        comingClassListDoc.add(doc);
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
              'name' : name,
              'underChange' : false,
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

  // 리프레쉬 함수
  void refreshClasschild() {
    getDateClassList(classUIDList, date);
    getComingClassList(classUIDList);
  }

  // 일정 변경 한 것 지우는 작업 - date일정 버전
  Future<void> scheduleDelete(String userUID, String type, var context) async{
    Navigator.pop(context);
    var result = await firestore.collection('Schedule').where("classChildUID", isEqualTo: dateClassList[idx].id).get();
    for (var doc in result.docs) {
      doc.reference.delete();
    }
    dateClassList[idx].reference.update({
      'underChange' : false,
    });
    //캘린더 수업 업데이트
    refreshClasschild();
    notifyListeners();
    String className = dateClassList[idx]["name"];
    // 스케쥴 변경 메시지 작성
    String text = '"' +className + '" 수업의 일정 변경 요청이 취소되었습니다.';
    // 채팅방 정보 가져오기
    DocumentSnapshot classInfo =  await firestore.collection('Class').doc(dateClassList[idx]["classUID"]).get();
    DocumentSnapshot chatroomInfo = await firestore.collection('Chatroom').doc(classInfo["parentChatroom"]).get();
    CollectionReference chat = firestore.collection('Chatroom').doc(classInfo["parentChatroom"]).collection('Chat');
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
  // 일정 변경 한 것 지우는 작업 - 다가오는 일정 버전
  Future<void> scheduleDelete2(String userUID, String type, var context) async{
    Navigator.pop(context);
    var result = await firestore.collection('Schedule').where("classChildUID", isEqualTo: comingClassListDoc[idx].id).get();
    for (var doc in result.docs) {
      doc.reference.delete();
    }
    comingClassListDoc[idx].reference.update({
      'underChange' : false,
    });
    //캘린더 수업 업데이트
    refreshClasschild();
    notifyListeners();
    String className = comingClassListDoc[idx]["name"];
    // 스케쥴 변경 메시지 작성
    String text = '"' +className + '" 수업의 일정 변경 요청이 취소되었습니다.';
    // 채팅방 정보 가져오기
    DocumentSnapshot classInfo =  await firestore.collection('Class').doc(comingClassListDoc[idx]["classUID"]).get();
    DocumentSnapshot chatroomInfo = await firestore.collection('Chatroom').doc(classInfo["parentChatroom"]).get();
    CollectionReference chat = firestore.collection('Chatroom').doc(classInfo["parentChatroom"]).collection('Chat');
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

  // idx 변수 지정 함수
  void setIdx(int i) {
    idx = i;
    notifyListeners();
  }

  // 수업료 계산 함수
  void classPay(List ClassUIDList) async{
    payList = [];
    for (String ClassUID in classUIDList) {
      bool pay_delay = false;
      String next_paydate = "";
      String persent_string = "";
      int count = 0;
      int count_next = 0;
      var result = await firestore.collection('Class').doc(ClassUID).get();
      int pay_times = result["pay_times"];
      String className = result["classname"].toString().split(' ')[0] + "(" + result["classname"].toString().split(' ')[1] + ")";
      String payed_date = result["payed_date"];
      String today = DateTime.now().toString().split(' ')[0];
      for (var doc in allClasschild) {
        if (count_next == pay_times - 1) {
          next_paydate = DateTime.parse(doc["date"]).add(Duration(days: 1)).toString().split(' ')[0];
          next_paydate = next_paydate.split('-')[1] + "/" + next_paydate.split('-')[2];
        }
        if (doc["classUID"].toString().compareTo(ClassUID) == 0 && doc["date"].toString().compareTo(payed_date) >= 0 && doc["date"].toString().compareTo(today) <= 0) {
          count++;
        }
        if (doc["classUID"].toString().compareTo(ClassUID) == 0 && doc["date"].toString().compareTo(payed_date) >= 0) {
          count_next++;
        }
      }
      double persent = count / pay_times;
      persent_string = (persent * 100).toStringAsFixed(1) + "%";
      if (persent > 1) {
        pay_delay = true;
        persent = 1;
      }
      payList.add({
        "className" : className,
        "persent" : persent,
        "persent_string" : persent_string,
        "pay_delay" : pay_delay,
        "next_paydate" : next_paydate,
        "count" : count,
        "pay_times" : pay_times,
      });
    }
    notifyListeners();
  }

} // Class 끝