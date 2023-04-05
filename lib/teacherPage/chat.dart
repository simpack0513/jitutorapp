import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //변수
  String test_img = 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMTA3MTFfMTQg%2FMDAxNjI1OTg2NTU0MTAw.pgUWeHaPctix0o_UbjNpIQGgKIxos3ZMYivmOiYvhi4g.AxnXZY_f7VXyzS6fYrdX2qzw6DbYcLFpV0I4hyaf5WUg.JPEG.chimmy1004%2FIMG_0188.JPG&type=sc960_832';

  ScrollController _scrollController = ScrollController();

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
  var textfieldTextStyle = TextStyle(
    fontFamily: 'LINESeedKR',
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  //


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xf7F3F7FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0), child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Colors.black,))),
        title: Text('이승재 학생'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: 'LINESeedKR',
          fontSize: 20,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.white,
                          elevation: 0,
                        ),
                        onPressed: (){},
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 9,
                          child: Icon(Icons.add, color: Colors.black,),
                        ),
                      ),
                    ),
                    Expanded(flex: 7, child: Container(
                      width: double.infinity,
                      child: TextField(
                          minLines: 1,
                          maxLines: 4,
                        style: headtextStyle,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        )
                      ),
                    )),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.white,
                          elevation: 0,
                        ),
                        onPressed: (){},
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 9,
                          child: Icon(Icons.send, color: Colors.black,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // 스크롤 컨트롤러
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, i) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 1),
                      curve: Curves.easeInOut);
                });
                return Container(
                  padding: EdgeInsets.all(10),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textDirection: (i % 2 == 0) ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.topCenter,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(test_img),
                          ),
                        ),
                        Container(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: (i % 2 == 0) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text('이승재', style: bodyBoldtextStyle, textAlign: TextAlign.start,),
                            Container(height: 5,),
                            Container(
                              padding: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width / 4 * 3 - 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Text('테스트 택스트 테스트 택스트', style: bodytextStyle,),
                            ),
                          ],
                        ),
                        Container(
                          width: 5,
                        ),
                        Container(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Icon(Icons.circle, color: Colors.red, size: 10,)
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,

    );
  }
}
