import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jitutorapp/studentPage/viewpoint.dart';
import 'package:provider/provider.dart';

import '../DataStore/InfoStore.dart';
import '../signUp.dart';
import 'order.dart';



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

  // 로그아웃 함수 따로 만듦
  void logout() async{
    context.read<InfoStore>().allPop();
    final storage = new FlutterSecureStorage();
    await storage.deleteAll();
  }



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
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPoint()));
              },
              style: elevatedButtonStyle,
              child: Column(crossAxisAlignment : CrossAxisAlignment.start, mainAxisAlignment : MainAxisAlignment.center, children: [
                Expanded(flex: 1, child: Text('내 포인트 보기', style: headtextStyle,)),
                Expanded(flex: 1, child: Text('현재 남은 포인트를 볼 수 있습니다.', style: bodytextStyle,))
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
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Order()));
              },
              style: elevatedButtonStyle,
              child: Column(crossAxisAlignment : CrossAxisAlignment.start, mainAxisAlignment : MainAxisAlignment.center, children: [
                Expanded(flex: 1, child: Text('보관함', style: headtextStyle,)),
                Expanded(flex: 1, child: Text('구매한 기프티콘을 확인할 수 있습니다.', style: bodytextStyle,))
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
              onPressed: (){
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) => signUp()), (route) => false);
                logout();
              },
              style: elevatedButtonStyle,
              child: Column(crossAxisAlignment : CrossAxisAlignment.start, mainAxisAlignment : MainAxisAlignment.center, children: [
                Expanded(flex: 1, child: Text('로그아웃 하기', style: headtextStyle,)),
                Expanded(flex: 1, child: Text('로그아웃을 바로 합니다.', style: bodytextStyle,))
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
