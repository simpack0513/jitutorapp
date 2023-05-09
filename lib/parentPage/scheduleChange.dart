import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jitutorapp/DataStore/scheduleStore.dart';
import 'package:provider/provider.dart';

import '../DataStore/ClasschildStore.dart';
import '../DataStore/UserStore.dart';

class ScheduleChange extends StatefulWidget {
  const ScheduleChange({Key? key}) : super(key: key);

  @override
  State<ScheduleChange> createState() => _ScheduleChangeState();
}

class _ScheduleChangeState extends State<ScheduleChange> {
  // 변수, 테마
  var containerTheme = BoxDecoration(
    color : Colors.white,
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
  var headtextStyle = TextStyle(
    fontFamily: 'LINESeedKR',
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  bool checkBoxBool = false;
  var homeContext; // schedulechage 위젯의 context를 보관

  List timeList = ['00:00', '00:30', '01:00','01:30','02:00','02:30','03:00','03:30','04:00','04:30',
    '05:00','05:30','06:00','06:30','07:00','07:30','08:00','08:30','09:00','09:30','10:00','10:30',
    '11:00','11:30','12:00', '12:30','13:00','13:30','14:00','14:30','15:00','15:30','16:00','16:30',
    '17:00','17:30','18:00','18:30','19:00','19:30', '20:00','20:30','21:00','21:30','22:00','22:30',
    '23:00','23:30'
  ];

  //

  // 날짜 고르기 함수
  void showDatePickerPop(int i) async {
    Future<DateTime?> selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.parse(context.read<ScheduleStore>().listDate[i]), //초기값
      firstDate: DateTime.now().add(Duration(days: 1)), //시작일
      lastDate: DateTime(2025), //마지막일
    );
    selectedDate.then((value) {
      if(value != null) {
        context.read<ScheduleStore>().changeDate(i, value.toString().split(' ')[0]);
      }
    });
  }
  //

  @override
  void initState() {
    setState(() {
      homeContext = context;
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xf7F3F7FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0), child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Colors.black,))),
        title: Text('일정변경'),
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
            Container(
              margin: EdgeInsets.all(10),
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: containerTheme,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('현재', style: headtextStyle),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  color: Colors.grey,
                  width: double.infinity,
                  height: 0.5,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('수업명', style: bodytextStyle,),
                  Text(context.read<ScheduleStore>().currentName, style: bodytextStyle,),
                ],),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('수업일', style: bodytextStyle,),
                  Text(context.read<ScheduleStore>().currentDate, style: bodytextStyle,),
                ],),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('수업시간', style: bodytextStyle,),
                  Text(context.read<ScheduleStore>().currentStartTime+' ~ '+context.read<ScheduleStore>().currentEndTime, style: bodytextStyle,),
                ],),
              ],),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: context.watch<ScheduleStore>().count,
                itemBuilder: (context, i) {
                  return (i != context.watch<ScheduleStore>().count-1) ? Container(
                    margin: EdgeInsets.all(10),
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: containerTheme,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('변경 후보' + (i+1).toString(), style: headtextStyle),
                        (i != 0) ? IconButton(onPressed: (){
                          context.read<ScheduleStore>().deleteSchedule(i);
                        }, icon: Icon(Icons.clear, size: 25, color: Colors.black,), padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),) : Container(),
                      ]),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        color: Colors.grey,
                        width: double.infinity,
                        height: 0.5,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('수업명', style: bodytextStyle,),
                        Text(context.read<ScheduleStore>().listName, style: bodytextStyle2,),
                      ],),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('수업일', style: bodytextStyle,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                          ),
                          onPressed: (){
                            showDatePickerPop(i);
                          },
                          child: Row(children: [
                            Text(context.watch<ScheduleStore>().listDate[i], style: bodytextStyle2, ),
                            Icon(Icons.event, size: 20, color: Colors.black,),
                          ]),
                        ),
                      ],),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('수업시간', style: bodytextStyle,),
                        Row(
                          children: [
                            DropdownButton(
                              value: context.watch<ScheduleStore>().listStartTime[i],
                              items: timeList.map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),);
                              }).toList(),
                              onChanged: (text) {
                                context.read<ScheduleStore>().setListStartTime(text.toString(), i);
                              }
                            ),
                            Text(' ~   ', style: bodytextStyle2,),
                            DropdownButton(
                                value: context.watch<ScheduleStore>().listEndTime[i],
                                items: timeList.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),);
                                }).toList(),
                                onChanged: (text) {
                                    context.read<ScheduleStore>().setListEndTime(text.toString(), i);
                                  }
                            ),
                          ]),
                      ],),
                    ],),
                  ) : Container(// 여기는 후보 추가 버튼
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    width: double.infinity,
                    decoration: containerTheme,
                    height: MediaQuery.of(context).size.height/17,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                      ),
                      onPressed: (){
                        context.read<ScheduleStore>().addSchedule();
                      },
                      child: Icon(Icons.add, size: 25, color: Colors.black,),
                    ),
                  );
                }
            ),

          ],
        ),
      ), //body
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
        height: MediaQuery.of(context).size.height/13,
        color: Colors.white,
        child: Row(mainAxisAlignment : MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Checkbox(
                value: checkBoxBool,
                activeColor: Color(0xff698abe),
                onChanged: (value){
                  setState(() {
                    checkBoxBool = value!;
                  });
                }
            ),
            Text('앞으로 모든 일정 변경하기', style: TextStyle(
              fontFamily: 'LINESeedKR',
              fontSize: 13,
              color: Colors.black,)),
          ],),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff698abe),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
              ),
              onPressed: (){
                FlutterDialog();
              },
              child: Text('변경 요청하기', style: TextStyle(
                fontFamily: 'LINESeedKR',
                fontSize: 15,
                color: Colors.white,)),
          ),
        ],),
      ),
    );
  }

  // 예 아니로 다이얼로그 함수
  void FlutterDialog() {
    String titleStr = '';
    if (checkBoxBool == true) {
      titleStr = "앞으로 모든 일정에 대하여 변경하는게 맞으신가요?";
    }
    else {
      titleStr = "이 내용으로 일정변경 요청을 하시겠습니까?";
    }
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
                    onPressed: () async{
                      await context.read<ScheduleStore>().uploadData(checkBoxBool, context.read<UserStore>().userUID, context.read<UserStore>().type, context.read<UserStore>().name);
                      context.read<ClasschildStore>().refreshClasschild();
                      Navigator.of(context).pop();
                      Navigator.of(homeContext).pop();
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

