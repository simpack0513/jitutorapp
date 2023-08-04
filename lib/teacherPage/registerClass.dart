import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitutorapp/DataStore/RegisterClassStore.dart';
import 'package:jitutorapp/DataStore/UserStore.dart';
import 'package:jitutorapp/ToastService.dart';
import 'package:provider/provider.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class RegisterClass extends StatefulWidget {
  const RegisterClass({Key? key}) : super(key: key);

  @override
  State<RegisterClass> createState() => _RegisterClassState();
}

class _RegisterClassState extends State<RegisterClass> {
  String studentName = "";
  String subject = "선택";
  List<String> dropdownList = ['선택', '수학', '영어'];



  @override
  void initState() {
    // TODO: implement initState
    context.read<RegisterClassStore>().init();
  }

  @override
  Widget build(BuildContext context) {
    var InfoPagetheme = ThemeData(
      fontFamily: 'LINESeedKR',
      inputDecorationTheme: InputDecorationTheme(
          counterStyle: TextStyle(
            fontFamily: 'LINESeedKR',
            fontSize: 30,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))
      ),

    );
    var titleTextStyle = TextStyle(
      fontFamily: 'LINESeedKR',
      fontSize: 20,
      color: Colors.black,
    );

    var mainTextStyle = TextStyle(
      fontFamily: 'LINESeedKR',
      fontSize: MediaQuery.of(context).size.width / 28,
      color: Colors.black,
    );

    var textFieldTextStyle = TextStyle(
      fontFamily: 'LINESeedKR',
      fontSize: MediaQuery.of(context).size.width / 25,
      color: Colors.black,
    );

    return MaterialApp(
      theme: InfoPagetheme,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.black, size: 20,)),
          title: Text("새 수업 등록", style: titleTextStyle,),
        ),

        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(' 학생 이름', style: mainTextStyle)),
              Padding(
                padding: const EdgeInsets.all(5),
                child: TextField(
                  onChanged: (text){
                    setState(() {
                      studentName = text;
                    });
                  },
                  style: textFieldTextStyle,
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(' 과목', style: mainTextStyle)),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: DropdownButtonFormField(
                  value: subject,
                  items: dropdownList.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: textFieldTextStyle,),
                    );
                  }).toList(),
                  onChanged: (dynamic value) {
                    setState(() {
                      subject = value;
                    });
                  },
                  iconSize: 20,
                ),

              ),

            ]
        ),
        bottomSheet: Container(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 30),
          width: double.infinity,
          height: 90,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
            ),
            onPressed: () {
              if (studentName.isEmpty) {
                ToastService.toastMsg('학생 이름을 입력해주세요.');
                return;
              }
              if (subject == "선택") {
                ToastService.toastMsg('과목을 선택해주세요.');
                return;
              }
              context.read<RegisterClassStore>().setFirstPage(studentName, subject, context.read<UserStore>().name);
              Navigator.push(context, MaterialPageRoute(builder: (context) => GetClassInfo()));
            },
            child: Text('다음으로', style: TextStyle(
              fontFamily: 'LINESeedKR',
              fontSize: 20,
              color: Colors.white,
            ),),
          ),
        ),


      ),
    );
  }
}

class GetClassInfo extends StatefulWidget {
  const GetClassInfo({Key? key}) : super(key: key);

  @override
  State<GetClassInfo> createState() => _GetClassInfoState();
}

class _GetClassInfoState extends State<GetClassInfo> {
  @override
  Widget build(BuildContext context) {
    var InfoPagetheme = ThemeData(
      fontFamily: 'LINESeedKR',
      inputDecorationTheme: InputDecorationTheme(
          counterStyle: TextStyle(
            fontFamily: 'LINESeedKR',
            fontSize: 30,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))
      ),

    );
    var titleTextStyle = TextStyle(
      fontFamily: 'LINESeedKR',
      fontSize: 20,
      color: Colors.black,
    );

    var mainTextStyle = TextStyle(
      fontFamily: 'LINESeedKR',
      fontSize: MediaQuery.of(context).size.width / 28,
      color: Colors.black,
    );

    var textFieldTextStyle = TextStyle(
      fontFamily: 'LINESeedKR',
      fontSize: MediaQuery.of(context).size.width / 25,
      color: Colors.black,
    );

    return MaterialApp(
      theme: InfoPagetheme,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.black, size: 20,)),
          title: Text(context.watch<RegisterClassStore>().className, style: titleTextStyle,),
        ),

        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(' 일주일에 몇 번 수업하세요?', style: mainTextStyle)),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  height: MediaQuery.of(context).size.height / 15,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.read<RegisterClassStore>().number.toString() + '회', style: mainTextStyle,),
                      IconButton(
                        onPressed: (){
                          selecte_number();
                        },
                        icon: Icon(Icons.arrow_drop_down_sharp, size: 20,),
                      )
                    ],
                  ),
                )
              ),
              SizedBox(height: 10,),
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text('과목을 선택하세요', style: mainTextStyle)),
            ]
        ),
        bottomSheet: Container(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 30),
          width: double.infinity,
          height: 90,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
            ),
            onPressed: () {

            },
            child: Text('다음으로', style: TextStyle(
              fontFamily: 'LINESeedKR',
              fontSize: 20,
              color: Colors.white,
            ),),
          ),
        ),


      ),
    );
  }

  // 일주일에 몇 번 수업하세요? 선택
  void selecte_number() {
    var mainTextStyle = TextStyle(
      fontFamily: 'LINESeedKR',
      fontSize: MediaQuery.of(context).size.width / 28,
      color: Colors.black,
    );
    var mainTextStyleGrey = TextStyle(
      fontFamily: 'LINESeedKR',
      fontSize: MediaQuery.of(context).size.width / 28,
      color: Colors.grey,
    );
    String titleStr = "이 내용으로 일정변경 요청을 수락하시겠습니까?";
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            insetPadding: EdgeInsets.zero,
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width / 10,
              padding: EdgeInsets.zero,
              child: WheelChooser.integer(
                onValueChanged: (i) => context.read<RegisterClassStore>().setNumber(i),
                maxValue: 7,
                minValue: 1,
                step: 1,
                listHeight: MediaQuery.of(context).size.height / 4,
                selectTextStyle: mainTextStyle,
                unSelectTextStyle: mainTextStyleGrey,
                initValue: context.read<RegisterClassStore>().number,
              ),
            )
          );
        });
  }



}

