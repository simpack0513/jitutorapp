import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jitutorapp/ToastService.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../DataStore/UserStore.dart';
import '../DataStore/scheduleConformStore.dart';

class ScheduleConform extends StatefulWidget {
  const ScheduleConform({Key? key}) : super(key: key);

  @override
  State<ScheduleConform> createState() => _ScheduleConformState();
}

class _ScheduleConformState extends State<ScheduleConform> {
  // 변수, 테마
  var calendarHeaderStyle = HeaderStyle(
    formatButtonVisible: false,
    titleCentered: true,
    leftChevronIcon: Icon(Icons.arrow_left, color: Colors.black,),
    rightChevronIcon: Icon(Icons.arrow_right, color: Colors.black,),
  );
  var containerTheme = BoxDecoration(
    color : Colors.white,
    borderRadius: BorderRadius.circular(20),
  );
  var selectedContainerTheme = BoxDecoration(
    color : Colors.lightBlue.shade100,
    borderRadius: BorderRadius.circular(20),
  );
  var bodytextStyle = TextStyle(
    fontFamily: 'LINESeedKR',
    color: Colors.black,
    fontSize: 14,
    height: 2,
  );
  var bodytextStyle2 = TextStyle(
    fontFamily: 'LINESeedKR',
    color: Colors.black,
    fontSize: 14,
  );
  var btntextStyle = TextStyle(
    fontFamily: 'LINESeedKR',
    color: Colors.white,
    fontSize: 14,
  );
  var headtextStyle = TextStyle(
    fontFamily: 'LINESeedKR',
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xf7F3F7FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0), child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Colors.black,))),
        title: Text('일정변경 확인'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: 'LINESeedKR',
          fontSize: 20,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 1, 1),
                  focusedDay: context.watch<ScheduleConformStore>().currentClassDate.isNotEmpty ? DateTime.parse(context.watch<ScheduleConformStore>().currentClassDate.split(' ')[0]) : DateTime.now(),
                  locale: 'ko-KR',
                  headerStyle: calendarHeaderStyle,
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: true,
                    weekendTextStyle: TextStyle().copyWith(color: Colors.red),
                    holidayTextStyle: TextStyle().copyWith(color: Colors.blue[800]),
                  ),
                  onDaySelected: (DateTime selectedDay, DateTime focusedDay) { // 날짜 선택시 실행되는 함수
                  },
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: containerTheme,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('변경하고자 하는 수업', style: headtextStyle),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      color: Colors.grey,
                      width: double.infinity,
                      height: 0.5,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('수업명', style: bodytextStyle,),
                      Text(context.read<ScheduleConformStore>().currentClassName, style: bodytextStyle,),
                    ],),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('수업일', style: bodytextStyle,),
                      Text(context.read<ScheduleConformStore>().currentClassDate, style: bodytextStyle,),
                    ],),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('수업시간', style: bodytextStyle,),
                      Text(context.read<ScheduleConformStore>().currentClassStarttime+' ~ '+context.read<ScheduleConformStore>().currentClassEndtime, style: bodytextStyle,),
                    ],),
                  ],),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: context.watch<ScheduleConformStore>().count,
                    itemBuilder: (context, i) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                        ),
                        onPressed: (){
                          context.read<ScheduleConformStore>().choiceOption(i);
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: (context.watch<ScheduleConformStore>().selectedOption == i) ? selectedContainerTheme : containerTheme,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('변경 후보' + (i+1).toString(), style: headtextStyle),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              color: Colors.grey,
                              width: double.infinity,
                              height: 0.5,
                            ),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text('수업일', style: bodytextStyle,),
                              Text(context.watch<ScheduleConformStore>().optionClassDate[i], style: bodytextStyle2, ),
                            ],),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text('수업시간', style: bodytextStyle,),
                              Text(context.watch<ScheduleConformStore>().optionClassStarttime[i] + ' ~ ' + context.watch<ScheduleConformStore>().optionClassEndtime[i], style: bodytextStyle2,),
                            ],),
                          ],),
                        ),
                      );
                    }
                ),
              ],
            ),
          ), //body
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: MediaQuery.of(context).size.height/18,
              width: MediaQuery.of(context).size.width/2 - 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff698abe),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                ),
                onPressed: (){
                  if (context.read<ScheduleConformStore>().selectedOption == -1) {
                    ToastService.toastMsg('변경할 후보를 눌러 선택해주세요');
                  }
                  else {
                    OKDialog();
                  }
                },
                child: Text(
                    '후보를 선택하고\n변경 수락하기',
                    style: btntextStyle,
                    textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: MediaQuery.of(context).size.height/18,
              width: MediaQuery.of(context).size.width/2 - 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade300,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.all(5),
                ),
                onPressed: (){
                  NoDialog();
                },
                child: Text(
                    '맞는 일정이 없어요\n요청 거절하기',
                    style: btntextStyle,
                    textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 예 아니로 다이얼로그 함수
  void OKDialog() {
    String titleStr = "이 내용으로 일정변경 요청을 수락하시겠습니까?";
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            //Dialog Main Title
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height/15,
                  alignment: Alignment.center,
                  child: Text(titleStr, style : TextStyle(
                    fontFamily: 'LINESeedKR',
                    color: Colors.black,
                    fontSize: 14,
                  )),
                ),
                Container(
                  color: Colors.grey,
                  height: 0.5,
                  width: double.infinity,
                )
              ],
            ),
            //
            content: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text('아니오', style: TextStyle(
                      fontFamily: 'LINESeedKR',
                      fontSize: 15,
                      color: Colors.black,)),
                  ),
                ),
                Container(
                  color: Colors.grey,
                  width: 0.5,
                  height: MediaQuery.of(context).size.height/20,
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<ScheduleConformStore>().conformSchedule(context.read<UserStore>().type, context.read<UserStore>().userUID);
                    },
                    child: Text('네', style: TextStyle(
                      fontFamily: 'LINESeedKR',
                      fontSize: 15,
                      color: Colors.black,)),
                  ),
                ),
              ]
            ),
          );
        });
  }
  // 예 아니로 다이얼로그 함수
  void NoDialog() {
    String titleStr = "정말 후보 중 맞는 일정이 없으신가요?";
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            //Dialog Main Title
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height/15,
                  alignment: Alignment.center,
                  child: Text(titleStr, style : TextStyle(
                    fontFamily: 'LINESeedKR',
                    color: Colors.black,
                    fontSize: 14,
                  )),
                ),
                Container(
                  color: Colors.grey,
                  height: 0.5,
                  width: double.infinity,
                )
              ],
            ),
            //
            content: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text('아니오', style: TextStyle(
                        fontFamily: 'LINESeedKR',
                        fontSize: 15,
                        color: Colors.black,)),
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    width: 0.5,
                    height: MediaQuery.of(context).size.height/20,
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                      onPressed: () {
                      },
                      child: Text('네', style: TextStyle(
                        fontFamily: 'LINESeedKR',
                        fontSize: 15,
                        color: Colors.black,)),
                    ),
                  ),
                ]
            ),
          );
        });
  }
}

