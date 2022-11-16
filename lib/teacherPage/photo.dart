import 'package:flutter/material.dart';

//스타일
var textTheme = TextStyle(
  fontFamily: 'Pretendard',
  fontSize: 15,
);

//

class Photo extends StatefulWidget {
  const Photo({Key? key}) : super(key: key);

  @override
  State<Photo> createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 3,
          itemBuilder: (c, i){return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                height: MediaQuery.of(context).size.width/7,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.all(7) ,child: Icon(Icons.account_circle, size: 40,)),
                    Text('황인태 영어 수업 - 신지호 선생님', style: textTheme,),
                  ],
                )),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                color: Colors.lightBlueAccent,
              ),
              Container(
                padding: EdgeInsets.all(13),
                child: Row(
                  children: [
                    Icon(Icons.favorite_border_rounded, size: 30,),
                    Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0), child: Icon(Icons.bookmark_border_rounded, size: 30)),
                  ],
                )
              ),
              Padding(padding: EdgeInsets.fromLTRB(13, 0, 0, 5), child: Text('2022.11.08', style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.bold,
              ),)),
              Container(
                padding: EdgeInsets.fromLTRB(13, 0, 15, 10),
                child: Text('이차방정식과 이차함수를 나갔습니다. 숙제 페이지는 라이트 쎈 89 ~ 101쪽 입니다.', style: textTheme,),
              )
            ],
          );}
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        backgroundColor: Colors.indigoAccent,
        child: Icon(Icons.add_a_photo),
        onPressed: (){},
      ),
    );
  }
}
