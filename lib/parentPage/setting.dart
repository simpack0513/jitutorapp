import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jitutorapp/DataStore/InfoStore.dart';
import 'package:jitutorapp/signUp.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../DataStore/UserStore.dart';



class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // 변수
  var headtextStyle = TextStyle(
    fontFamily: 'LINESeedKR',
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );
  var bodytextStyle = TextStyle(
    fontFamily: 'LINESeedKR',
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
          fontFamily: 'LINESeedKR',
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
          Container( // 2
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
          Container( // 6
            color: Colors.amber,
            width: double.infinity,
            height: MediaQuery.of(context).size.height/8,
            child: ElevatedButton(
              onPressed: () async{
                String url = "https://important-ceiling-52a.notion.site/f9f23a9c90434a7b931deaef55a07e4b?pvs=4";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  Get.snackbar('연결 실패', '오류',
                      duration: Duration(seconds: 10), backgroundColor: Colors.white);
                }
              },
              style: elevatedButtonStyle,
              child: Column(crossAxisAlignment : CrossAxisAlignment.start, mainAxisAlignment : MainAxisAlignment.center, children: [
                Expanded(flex: 1, child: Text('개인정보처리방침', style: headtextStyle,)),
                Expanded(flex: 1, child: Text('개인정보처리방침을 확인합니다.', style: bodytextStyle,))
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
                Expanded(flex: 1, child: Text('로그아웃을 합니다.', style: bodytextStyle,))
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
