import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jitutorapp/DataStore/UserStore.dart';
import 'package:jitutorapp/teacherPage/chat.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
final firestore = FirebaseFirestore.instance;

class Messenger extends StatefulWidget {
  const Messenger({Key? key}) : super(key: key);

  @override
  State<Messenger> createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
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

  // 함수


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Chatroom').where("userUID1", isEqualTo: context.read<UserStore>().userUID).orderBy("lastDate", descending: true).snapshots(),
      builder: (context, snapshot) {
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: (snapshot.hasData) ? snapshot.data?.docs.length : 0,
          itemBuilder: (context, i) {
            // 학생인지 학부모인지 체크
            bool isUser2;
            String type = snapshot.data?.docs[i]["type"];
            if (type == "parent") {
              isUser2 = false;
            }
            else {
              isUser2 = true;
            }
            // 날짜 체크 후 출력 정하기
            DateFormat formatter = DateFormat('yyyy-MM-dd');
            String today = formatter.format(DateTime.now());
            String lastDate = snapshot.data!.docs[i]["lastDate"].toString();
            DateTime lastDate_datetime = DateTime.parse(lastDate);
            String date = "";
            if (today == lastDate.split(' ')[0]) {
              DateFormat formatter = DateFormat('a h:mm', 'ko');
              date = formatter.format(lastDate_datetime);
            }
            else {
              DateFormat formatter = DateFormat('M월 d일');
              date = formatter.format(lastDate_datetime);
            }


            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.white,
                  elevation: 0,
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
                  roomDocId: snapshot.data!.docs[i].id,
                  meImg: snapshot.data?.docs[i]["userImg1"],
                  youImg: (isUser2) ? snapshot.data?.docs[i]["userImg2"] : snapshot.data?.docs[i]["userImg3"],
                  youName: (isUser2) ? snapshot.data?.docs[i]["userName2"] : snapshot.data?.docs[i]["userName3"],
                  remainMsg1: snapshot.data?.docs[i]["remainMsg1"],
                  meName: snapshot.data?.docs[i]["userName1"],
                  youUID : (isUser2) ? snapshot.data?.docs[i]["userUID2"] : snapshot.data?.docs[i]["userUID3"],
                )));
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
                          child: Image.network((isUser2) ? snapshot.data?.docs[i]["userImg2"] : snapshot.data?.docs[i]["userImg3"]),
                      ),
                    )),
                    Expanded(flex: 3, child: Container(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 5,),
                          Text((isUser2) ? snapshot.data?.docs[i]["userName2"] : snapshot.data?.docs[i]["userName3"], style: headtextStyle,),
                          Container(height: 5,),
                          Text(snapshot.data?.docs[i]["lastMsg"], style: bodytextStyle, overflow: TextOverflow.ellipsis, maxLines: 2,),
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
                            Text(date, style: bodytextStyle,),
                            SizedBox(height: 5,),
                            (snapshot.data!.docs[i]["remainMsg1"] != 0) ? Container(
                              width: 18,
                              height: 18,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Text(snapshot.data!.docs[i]["remainMsg1"].toString() , style: TextStyle(color: Colors.white, fontSize: 14),),
                            ) : Container(),
                          ],
                      ),
                    )),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}
