import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; // 캘린더 패키지

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
                onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                  setState(() {
                    this.selectedDay = selectedDay;
                  });
                },
                selectedDayPredicate: (DateTime day) {
                  return isSameDay(selectedDay, day);
                },
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
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context, i) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('황인규(영어)  16:00 ~ 18:00', style: bodytextStyle,),
                            TextButton(onPressed: (){}, child: Text('일정변경')),
                          ],
                        );
                      }
                  ),

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
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 2,
                      itemBuilder: (context, i) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('2 일후', style: bodyBoldtextStyle),
                            Text('황인규(영어)  16:00 ~ 18:00', style: bodytextStyle),
                            TextButton(onPressed: (){}, child: Text('일정변경')),
                          ],
                        );
                      }
                  ),

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
