import 'package:flutter/material.dart';

class signUp extends StatelessWidget {
  signUp({Key? key}) : super(key: key);
  var mainTextStyle = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 30,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('지튜터에 오신 것을 환영합니다', style: mainTextStyle,),
              Text('아래 버튼을 눌러 회원가입을 진행하십시오.', style: TextStyle(fontSize: 15, fontFamily: 'Pretendard')),
              Container(height: 50,),
              Row(children: [
                Flexible(child: TextButton(onPressed: (){}, child: Image.asset('assets/studentButtonIcon.png', fit: BoxFit.fitHeight,) ), flex: 1, ),
                Flexible(child: TextButton(onPressed: (){}, child: Image.asset('assets/parentButtonIcon.png', fit: BoxFit.fill,)), flex: 1, ),

              ],),
            TextButton(onPressed: (){}, child: Image.asset('assets/teacherButtonIcon.png')),

            ],
          ),
        ),
      ),

    );
  }
}
