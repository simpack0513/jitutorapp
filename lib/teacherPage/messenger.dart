import 'package:flutter/material.dart';
import 'package:jitutorapp/teacherPage/chat.dart';

class Messenger extends StatefulWidget {
  const Messenger({Key? key}) : super(key: key);

  @override
  State<Messenger> createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
  //변수
  String test_img = 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMTA3MTFfMTQg%2FMDAxNjI1OTg2NTU0MTAw.pgUWeHaPctix0o_UbjNpIQGgKIxos3ZMYivmOiYvhi4g.AxnXZY_f7VXyzS6fYrdX2qzw6DbYcLFpV0I4hyaf5WUg.JPEG.chimmy1004%2FIMG_0188.JPG&type=sc960_832';
  var headtextStyle = TextStyle(
    fontFamily: 'LINESeedKR',
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w200,
  );
  var bodytextStyle = TextStyle(
    fontFamily: 'LINESeedKR',
    color: Colors.black,
    fontSize: 13,
  );
  var bodyBoldtextStyle = TextStyle(
    fontFamily: 'LINESeedKR',
    color: Colors.black,
    fontSize: 13,
    fontWeight: FontWeight.bold,
  );

  // 함수


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          elevation: 0,
      ),
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.width / 5,
        child: Row(
          children: [
            Expanded(flex: 1, child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(test_img),
              ),
            )),
            Expanded(flex: 3, child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('이승재 학생', style: headtextStyle,),
                  Container(height: 5,),
                  Text('선생님 체크체크 5페이지 ~~~ 부분이 이해가 되지 않습니다. 설명 부탁 !!ㅜ!ㅏㅣ~ㅏ~ㅣㅓㅣㅏ~ㅁ나ㅣ어ㅣㅏㅏㅁㅇㅁㄴ읍쥥ㅂㅣ', style: bodytextStyle, overflow: TextOverflow.ellipsis, maxLines: 2,),
                ],
              ),
            )),
            Expanded(flex: 1, child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Text('오전 10:50', style: bodytextStyle,),
                    SizedBox(height: 5,),
                    Container(
                      width: 18,
                      height: 18,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text('5', style: TextStyle(color: Colors.white, fontSize: 14),),
                    )
                  ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
