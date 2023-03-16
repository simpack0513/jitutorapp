import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jitutorapp/teacherPage/marketItemUpload.dart';
import 'package:jitutorapp/teacherPage/studentManage.dart';



class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0), child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Colors.black,))),
        title: Text('설정'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: 'Pretendard',
          fontSize: 20,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: ListView(
        children: [
          Container( // 1
            color: Colors.amber,
            width: double.infinity,
            height: MediaQuery.of(context).size.height/8,
            child: ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => StudentManage()));
              },
              style: elevatedButtonStyle,
              child: Column(crossAxisAlignment : CrossAxisAlignment.start, mainAxisAlignment : MainAxisAlignment.center, children: [
                Expanded(flex: 1, child: Text('학생 관리', style: headtextStyle,)),
                Expanded(flex: 1, child: Text('현재 선생님께서 수업 중인 학생들을 보거나, 포인트를 부여할 수 있습니다.', style: bodytextStyle,))
              ],),
            ),
          ),
          Container(
            color: Colors.grey,
            height: 0.5,
            width: double.infinity,
          ),
          Container( // 2
            color: Colors.amber,
            width: double.infinity,
            height: MediaQuery.of(context).size.height/8,
            child: ElevatedButton(
              onPressed: (){},
              style: elevatedButtonStyle,
              child: Column(crossAxisAlignment : CrossAxisAlignment.start, mainAxisAlignment : MainAxisAlignment.center, children: [
                Expanded(flex: 1, child: Text('수업 관리', style: headtextStyle,)),
                Expanded(flex: 1, child: Text('새로운 수업을 추가하거나 수업 종료를 설정할 수 있습니다.', style: bodytextStyle,))
              ],),
            ),
          ),
          Container(
            color: Colors.grey,
            height: 0.5,
            width: double.infinity,
          ),
          Container( // 3
            color: Colors.amber,
            width: double.infinity,
            height: MediaQuery.of(context).size.height/8,
            child: ElevatedButton(
              onPressed: (){},
              style: elevatedButtonStyle,
              child: Column(crossAxisAlignment : CrossAxisAlignment.start, mainAxisAlignment : MainAxisAlignment.center, children: [
                Expanded(flex: 1, child: Text('내 정보 관리', style: headtextStyle,)),
                Expanded(flex: 1, child: Text('비밀번호 재설정 등 ', style: bodytextStyle,))
              ],),
            ),
          ),
          Container(
            color: Colors.grey,
            height: 0.5,
            width: double.infinity,
          ),
          Container( // 4
            color: Colors.amber,
            width: double.infinity,
            height: MediaQuery.of(context).size.height/8,
            child: ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MarketItemUpload()));
              },
              style: elevatedButtonStyle,
              child: Column(crossAxisAlignment : CrossAxisAlignment.start, mainAxisAlignment : MainAxisAlignment.center, children: [
                Expanded(flex: 1, child: Text('마켓 상품 등록', style: headtextStyle,)),
                Expanded(flex: 1, child: Text('학생이 구매할 상품을 마켓에 등록할 수 있습니다.', style: bodytextStyle,))
              ],),
            ),
          ),
          Container(
            color: Colors.grey,
            height: 0.5,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
