import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jitutorapp/DataStore/UserStore.dart';
import 'package:jitutorapp/FCMsender.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
final firestore = FirebaseFirestore.instance;

// type 종류
/*
  DEF = 일반 메시지
  DAT = 날짜 안내 메시지
  CHS = 일정 변경 메시지
 */

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, this.roomDocId, this.meImg, this.youImg, this.youName, this.remainMsg1, this.meName, this.youUID}) : super(key: key);

  final roomDocId;
  final meImg;
  final youImg;
  final youName;
  final remainMsg1;
  final meName;
  final youUID;

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
  var DAT_TypeTextStyle = TextStyle(
    fontFamily: 'LINESeedKR',
    color: Colors.white,
    fontSize: 11,
  );

  int chatLimit = 10; // 최대 몇 개의 채팅을 가져올 지 -> 초기화는 10으로

  TextEditingController tec = TextEditingController();
  ScrollController scrollController = ScrollController();
  FCMController fcmControllersender = new FCMController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        setState(() {
          chatLimit += 5;
        });
      }
    });
    if (widget.remainMsg1 > 10) {
      setState(() {
        chatLimit = widget.remainMsg1;
      });
    }
  }

  //

  @override
  Widget build(BuildContext context) {
    // 레퍼런스 관리
    CollectionReference chat = FirebaseFirestore.instance.collection('Chatroom').doc(widget.roomDocId).collection('Chat');
    DocumentReference chatroom = firestore.collection('Chatroom').doc(widget.roomDocId);

    chatroom.update({
      "remainMsg1" : 0,
    });

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
                        onPressed: () async{
                          // 메시지 보내기
                          if (tec.text == "") { // 빈 문장이면 바로 리턴
                            return ;
                          }
                          String text = tec.text;
                          tec.clear();

                          DocumentSnapshot doc = await chatroom.get();
                          // 최근 메시지 전송 일자와 오늘의 날짜가 다르면 날씨 정보 택스트 업로드
                          if (doc["lastDate"].toString().split(' ')[0] != DateTime.now().toString().split(' ')[0]) {
                            String text_date = DateFormat('yyyy년 M월 d일 E요일', 'ko').format(DateTime.now());
                            chat.add({
                              "senderUID" : context.read<UserStore>().userUID,
                              "text" : text_date,
                              "time" : DateTime.now().toString(),
                              "type" : "DAT",
                              "read" : true,
                            });
                          }

                          String time = DateTime.now().toString();
                          chat.add({
                            "senderUID" : context.read<UserStore>().userUID,
                            "text" : text,
                            "time" : time,
                            "type" : "DEF",
                            "read" : false,
                          });

                          int _remainMsg;
                          if (doc["type"] == "student") {
                            _remainMsg = doc["remainMsg2"];
                            chatroom.update({
                              "lastMsg" : text,
                              "lastDate" : time,
                              "remainMsg2" : _remainMsg + 1,
                            });
                          }
                          else {
                            _remainMsg = doc["remainMsg3"];
                            chatroom.update({
                              "lastMsg" : text,
                              "lastDate" : time,
                              "remainMsg3" : _remainMsg + 1,
                            });
                          }

                          // 메시지 알림 보내기
                          DocumentSnapshot youDoc = await firestore.collection('Person').doc(widget.youUID).get();
                          await fcmControllersender.sendMessage(userToken: youDoc["FCMToken"], title: widget.meName, body: text);
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
                    controller: scrollController,
                    itemCount: (snapshot.hasData) ? snapshot.data?.docs.length : 0,
                    itemBuilder: (context, i) {
                      bool isMe; // 메시지 Sender가 '나'인지 판단
                      if (snapshot.data?.docs[i]["senderUID"] == context.read<UserStore>().userUID) {
                        isMe = true;
                      }
                      else {
                        isMe = false;
                      }

                      if (!isMe && snapshot.data?.docs[i]["read"] == false) {
                        snapshot.data?.docs[i].reference.update({"read" : true});
                      }

                      String chatTime; // 메시지 보낸 시각 포멧으로 바꾸기
                      DateFormat formatter = DateFormat('a h:mm', 'ko');
                      chatTime = formatter.format(DateTime.parse(snapshot.data?.docs[i]["time"]));

                      if (snapshot.data?.docs[i]["type"] == "DEF") { // 일반 텍스트 타입 처리
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
                                    Text((isMe) ? '나' : widget.youName, style: bodyBoldtextStyle, textAlign: TextAlign.start,),
                                    Container(height: 5,),
                                    Container(
                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 4 * 3 - 50,),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Text(snapshot.data?.docs[i]["text"], style: bodytextStyle, ),
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
                      }
                      else if (snapshot.data?.docs[i]["type"] == "DAT") { // 텍스트 일짜 알려주는 타입 처리
                        return Center(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Text(snapshot.data?.docs[i]["text"], style: DAT_TypeTextStyle,),
                          ),
                        );
                      }
                      else if (snapshot.data?.docs[i]["type"] == "CHS") {
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
                                    Text((isMe) ? '나' : widget.youName, style: bodyBoldtextStyle, textAlign: TextAlign.start,),
                                    Container(height: 5,),
                                    Container(
                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 4 * 3 - 50,),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(snapshot.data?.docs[i]["text"], style: bodytextStyle, ),
                                          SizedBox(height: 20,),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.all(10),
                                                elevation: 0,
                                                backgroundColor: Colors.grey.shade200,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                            ),
                                            onPressed: (){},
                                            child: Container(alignment: Alignment.center, width: MediaQuery.of(context).size.width / 4 * 3 - 50, child: Text('확인하기', style: bodytextStyle,)),
                                          ),
                                        ],
                                      ),
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
                      }

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
