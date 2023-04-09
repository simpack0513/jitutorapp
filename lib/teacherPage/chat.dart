import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jitutorapp/DataStore/UserStore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
final firestore = FirebaseFirestore.instance;

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, this.roomDocId, this.meImg, this.youImg, this.youName}) : super(key: key);

  final roomDocId;
  final meImg;
  final youImg;
  final youName;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //변수
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
  var timeTextStyle = TextStyle(
    fontFamily: 'LINESeedKR',
    color: Colors.grey,
    fontSize: 10,
  );

  int chatLimit = 10; // 최대 몇 개의 채팅을 가져올 지 -> 초기화는 10으로

  TextEditingController tec = TextEditingController();

  //

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xf7F3F7FC),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0), child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Colors.black,))),
          title: Text(widget.youName),
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'LINESeedKR',
            fontSize: 18,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Column(
          verticalDirection: VerticalDirection.up,
          children: [
            SafeArea(
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
                        controller: tec,
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
                        onPressed: (){
                          // 메시지 보내기
                          CollectionReference chat = FirebaseFirestore.instance.collection('Chatroom').doc(widget.roomDocId).collection('Chat');
                          String text = tec.text;
                          chat.add({
                            "senderUID" : context.read<UserStore>().userUID,
                            "text" : text,
                            "time" : DateTime.now().toString(),
                            "type" : "DEF",
                            "read" : false,
                          });
                          tec.clear();
                        },
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
            StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('Chatroom').doc(widget.roomDocId).collection('Chat').orderBy("time", descending: true).limit(chatLimit).snapshots(),
              builder: (context, snapshot) {
                return Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    reverse: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: (snapshot.hasData) ? snapshot.data?.docs.length : 0,
                    itemBuilder: (context, i) {
                      bool isMe; // 메시지 Sender가 '나'인지 판단
                      if (snapshot.data?.docs[i]["senderUID"] == context.read<UserStore>().userUID) {
                        isMe = true;
                      }
                      else {
                        isMe = false;
                      }

                      String chatTime; // 메시지 보낸 시각 포멧으로 바꾸기
                      DateFormat formatter = DateFormat('a h:mm', 'ko');
                      chatTime = formatter.format(DateTime.parse(snapshot.data?.docs[i]["time"]));


                      return Container(
                        padding: EdgeInsets.all(10),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            textDirection: (isMe) ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.topCenter,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: (isMe) ? Image.network(widget.meImg) : Image.network(widget.youImg),
                                ),
                              ),
                              Container(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: (isMe) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Text((isMe) ? '나' : widget.youName.split(' ')[0], style: bodyBoldtextStyle, textAlign: TextAlign.start,),
                                  Container(height: 5,),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width / 4 * 3 - 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Text(snapshot.data?.docs[i]["text"], style: bodytextStyle,),
                                  ),
                                ],
                              ),
                              Container(
                                width: 5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: (isMe) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  (snapshot.data?.docs[i]["read"]) ? SizedBox(width: 0, height: 0,) : Icon(Icons.circle, color: Colors.red, size: 10,),
                                  Text(chatTime, style: timeTextStyle,),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            ),
          ],
        ),
        resizeToAvoidBottomInset: true,

      ),
    );
  }
}
