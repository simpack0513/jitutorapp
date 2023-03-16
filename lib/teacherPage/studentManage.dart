import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jitutorapp/DataStore/ClassStore.dart';
import 'package:jitutorapp/DataStore/PointStore.dart';
import 'package:jitutorapp/DataStore/UserStore.dart';
import 'package:provider/provider.dart';

class StudentManage extends StatefulWidget {
  const StudentManage({Key? key}) : super(key: key);

  @override
  State<StudentManage> createState() => _StudentManageState();
}

class _StudentManageState extends State<StudentManage> {
  // 변수
  var headtextStyle = TextStyle(
    fontFamily: 'Pretendard',
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );
  var bodytextStyle = TextStyle(
    fontFamily: 'Pretendard',
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  var elevatedButtonStyle = ElevatedButton.styleFrom(
    elevation: 0,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    padding: EdgeInsets.all(20),
    alignment: Alignment.topLeft,
  );
  //



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0), child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Colors.black,))),
        title: Text('학생 관리'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: 'Pretendard',
          fontSize: 20,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: ListView.builder(
          itemCount: context.read<ClassStore>().userClassList.length,
          itemBuilder: (context, i) {
            return Column(children: [
              Container( // 1
                color: Colors.white,
                width: double.infinity,
                padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height/8,
                child: Column(crossAxisAlignment : CrossAxisAlignment.start, mainAxisAlignment : MainAxisAlignment.center, children: [
                  Expanded(flex: 1, child: Text(context.read<ClassStore>().userClassNameList[i].toString().split(' ')[0] + '(' + context.read<ClassStore>().userClassNameList[i].toString().split(' ')[1] + ')', style: headtextStyle,)),
                  Expanded(flex: 1, child: TextButton(
                    child: Text('포인트 부여하기', style: bodytextStyle,),
                    onPressed: (){
                      context.read<PointStore>().initPoint();
                      PointDialog(context.read<ClassStore>().userClassNameList[i].toString().split(' ')[0], context.read<ClassStore>().userClassList[i]['studentUID']);
                      },)),
                ],),
              ),
              Container(
                color: Colors.grey,
                height: 0.5,
                width: double.infinity,
              ),
            ],);
          })

    );
  }

  // 예 아니로 다이얼로그 함수
  void PointDialog(String name, String studentUID) {
    List pointList = [];
    for(int i=0; i<=context.read<UserStore>().point && i<=200; i += 10) {
      pointList.add(i.toString());
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
                  alignment: Alignment.center,
                  child: Column(children: [
                    Text('현재 나의 잔여 포인트 : ' + context.read<UserStore>().point.toString(), style : TextStyle(
                      fontFamily: 'Pretendard',
                      color: Colors.black,
                      fontSize: 14,
                    )),
                    Row(children: [
                      Text(name + '에게 부여할 포인트 : ', style : TextStyle(
                        fontFamily: 'Pretendard',
                        color: Colors.black,
                        fontSize: 14,
                      )),
                      DropdownButton(
                          value: context.watch<PointStore>().seletedPoint.toString(),
                          items: pointList.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),);
                          }).toList(),
                          onChanged: (text) {
                            context.read<PointStore>().setPoint(text.toString());
                          }
                      ),
                    ],)
                  ]),
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
                      child: Text('취소', style: TextStyle(
                        fontFamily: 'Pretendard',
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
                        context.read<UserStore>().givePoint(context.read<PointStore>().seletedPoint);
                        context.read<PointStore>().updatePoint(context.read<UserStore>().userUID, studentUID);
                        Navigator.of(context).pop();
                      },
                      child: Text('부여하기', style: TextStyle(
                        fontFamily: 'Pretendard',
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
