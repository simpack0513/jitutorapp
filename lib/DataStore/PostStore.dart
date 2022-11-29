// 게시글 정보 저장하는 곳
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final firestore = FirebaseFirestore.instance;

class PostStore extends ChangeNotifier{
  var postDocList = [];

  // 클래스 UID에 맞는 포스트 문서를 받는 함수
  void initgetPostDoc(List ClassUIDList) async{
    postDocList = [];
    var result = await firestore.collection('Post').where("classUID", whereIn: ClassUIDList).orderBy("date", descending: true).get();
    for (var doc in result.docs) {
      postDocList.add(doc);
      print(doc['date']);
    }
    print(postDocList);
    notifyListeners();
  } //

  //해당 doc에 하트 on/off 함수
  void changeHeart(QueryDocumentSnapshot doc) async{
    var result = await firestore.collection('Post').doc(doc.id);
    if(doc['heart'] == true) result.update({'heart' : false});
    else result.update({'heart' : true});
    notifyListeners();
  }

}