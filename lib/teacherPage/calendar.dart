import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jitutorapp/DataStore/ClasschildStore.dart';
import 'package:jitutorapp/DataStore/ClassStore.dart';
import 'package:jitutorapp/teacherPage/scheduleChange.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../DataStore/scheduleStore.dart'; // 캘린더 패키지

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  // 여기는 변수
  var calendarHeaderStyle = HeaderStyle(
    formatButtonVisible: false,
    titleCentered: true,
  );
  var headtextStyle = TextStyle(
    fontFamily: 'Pretendard',
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );
  var bodytextStyle = TextStyle(
    fontFamily: 'Pretendard',
    color: Colors.black,
    fontSize: 14,
  );
  var bodyBoldtextStyle = TextStyle(
      fontFamily: 'Pretendard',
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.bold,
  );

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  // 변수 끝

  @override
  void initState(){
    super.initState();
    // context.read<ClasschildStore>().delete();
    context.read<ClasschildStore>().getDateClassList(context.read<ClassStore>().userClassUIDList, selectedDay.toString().split(' ')[0]);
    context.read<ClasschildStore>().getEventAllday(context.read<ClassStore>().userClassUIDList);
    context.read<ClasschildStore>().getComingClassList(context.read<ClassStore>().userClassUIDList);
  }

  // 함수 시작
  // 달력 해당 날짜에 이벤트 반환(개수를 취하는듯..)
  List<Event> _getEventsForDay(DateTime day) {
    return context.watch<ClasschildStore>().events[day] ?? [];
  }

  // 일정 변경 버튼 누르면 실행되는 함수
  void changeDate(int i) async{
    String date = context.read<ClasschildStore>().dateClassList[i]['date'];
    String today = DateTime.now().toString().split(' ')[0];
    if (date.compareTo(today) <= 0) {
      Fluttertoast.showToast(
          msg: '당일 수업 혹은 이미 지나간 수업은 변경이 불가능합니다.',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.black87,
          fontSize: 12,
      );
    }
    else {
      await context.read<ScheduleStore>().setDoc(context.read<ClasschildStore>().dateClassList[i]);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleChange()));
    }
  }
  void changeDate2(int i) async{
    String date = context.read<ClasschildStore>().comingClassList[i]['date'];
    String today = DateTime.now().toString().split(' ')[0];
    if (date.compareTo(today) <= 0) {
      Fluttertoast.showToast(
        msg: '당일 수업 혹은 이미 지나간 수업은 변경이 불가능합니다.',
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black87,
        fontSize: 12,
      );
    }
    else {
      await context.read<ScheduleStore>().setDoc(context.read<ClasschildStore>().comingClassList[i]);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleChange()));
    }
  }

  //


  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfff2f1f0),
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container( // 맨 위 박스 - 캘린더
              padding: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width,
              color: const Color(0xfff2f1f0),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 1, 1),
                focusedDay: selectedDay,
                locale: 'ko-KR',
                headerStyle: calendarHeaderStyle,
                calendarStyle: CalendarStyle(
                  markerSize: 10.0,
                  markerDecoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  )
                ),
                onDaySelected: (DateTime selectedDay, DateTime focusedDay) { // 날짜 선택시 실행되는 함수
                  setState(() {
                    this.selectedDay = selectedDay;
                  });
                  context.read<ClasschildStore>().getDateClassList(context.read<ClassStore>().userClassUIDList, selectedDay.toString().split(' ')[0]);
                },
                selectedDayPredicate: (DateTime day) {
                  return isSameDay(selectedDay, day);
                },
                eventLoader: _getEventsForDay,
              ),
            ),
            Container( // 위에서 두번째 박스 - 선택한 날짜의 수업
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(selectedDay.month.toString()+'월 '+selectedDay.day.toString()+'일 수업', style: headtextStyle),
                  (context.watch<ClasschildStore>().dateClassList.isNotEmpty) ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: context.watch<ClasschildStore>().dateClassList.length,
                      itemBuilder: (context, i) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(context.watch<ClasschildStore>().dateClassList[i]['name']
                                +'  '+context.watch<ClasschildStore>().dateClassList[i]['startTime']
                              +' ~ '+context.watch<ClasschildStore>().dateClassList[i]['endTime'], style: bodytextStyle,),
                           // Text('황인규(영어)  16:00 ~ 18:00', style: bodytextStyle,),
                            TextButton(onPressed: (){
                              changeDate(i);
                            }, child: Text('일정변경')),
                          ],
                        );
                      }
                  )
                  : Text('\n해당 날짜에 수업이 없습니다.', style: bodytextStyle),

                ],
              ),
            ),
            Container( // 위에서 세번째 박스 - 다가오는 수업
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('다가오는 수업', style: headtextStyle),
                  (context.watch<ClasschildStore>().comingClassList.isNotEmpty) ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: context.watch<ClasschildStore>().comingClassList.length,
                      itemBuilder: (context, i) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(context.watch<ClasschildStore>().comingClassList[i]["comingDay"]+' 일후', style: bodyBoldtextStyle),
                            Text(context.watch<ClasschildStore>().comingClassList[i]['name']
                                +'  '+context.watch<ClasschildStore>().comingClassList[i]['startTime']
                                +' ~ '+context.watch<ClasschildStore>().comingClassList[i]['endTime'], style: bodytextStyle,),
                            TextButton(onPressed: (){
                              changeDate2(i);
                            }, child: Text('일정변경')),
                          ],
                        );
                      }
                  ) : Text('\n다가오는 수업이 없습니다.', style: bodytextStyle),

                ],
              ),
            ),

            Container( // 위에서 네번째 박스 - 수업료
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width/3,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
