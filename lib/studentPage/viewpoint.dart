import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jitutorapp/DataStore/ClassStore.dart';
import 'package:jitutorapp/DataStore/PointStore.dart';
import 'package:jitutorapp/DataStore/UserStore.dart';
import 'package:provider/provider.dart';

class ViewPoint extends StatefulWidget {
  const ViewPoint({Key? key}) : super(key: key);

  @override
  State<ViewPoint> createState() => _ViewPointState();
}

class _ViewPointState extends State<ViewPoint> {
  // 변수
  var headTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'Pretendard',
    fontSize: 20,
  );
  //


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon: Icon(Icons.arrow_back, color: Colors.black,))),
          title: Text('남은 포인트'),
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'Pretendard',
            fontSize: 20,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Container(
          height:  MediaQuery.of(context).size.height/13,
          width: double.infinity,
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.attach_money),
              Text('현재 잔여 포인트 : 100', style: headTextStyle,),
            ],
          ),
        ),

    );
  }

}