import 'package:flutter/material.dart';

class signUp extends StatelessWidget {
  const signUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('지튜터에 오신 것을 환영합니다.'),
              Text('아래 버튼을 눌러 회원가입을 진행하십시오.'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('이미지1'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
