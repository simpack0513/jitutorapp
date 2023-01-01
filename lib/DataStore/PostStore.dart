// 게시글 정보 저장하는 곳
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final firestore = FirebaseFirestore.instance;

class PostStore extends ChangeNotifier{
  var postDocList = [];
  // 마지막으로 로드된 게시글 번호
  var lastVisible;

  // 클래스 UID에 맞는 포스트 문서를 받는 함수
  void initgetPostDoc(List ClassUIDList) async{
    if(postDocList.length >= 2) return;
    var result = await firestore.collection('Post').where("classUID", whereIn: ClassUIDList).orderBy("date", descending: true).limit(2).get();
    for (var doc in result.docs) {
      postDocList.add(doc);
      print(doc['date']);
    }
    lastVisible = postDocList[postDocList.length-1];
    print(postDocList);
    notifyListeners();
  } //

  // 클래스에 UID에 맞는 포스트 more get 함수
  void moregetPostDoc(List ClassUIDList) async{
    var result = await firestore.collection('Post').where("classUID", whereIn: ClassUIDList).orderBy("date", descending: true).startAfterDocument(lastVisible).limit(2).get();
    lastVisible = result.docs[result.size-1];
    for (var doc in result.docs) {
      postDocList.add(doc);
      print(doc['date']);
    }
    lastVisible = postDocList[postDocList.length-1];
    print(postDocList);
    notifyListeners();
  }

  // 화면 새로고침 시 함수
  Future<void> refreshPost(List ClassUIDList) async{
    postDocList = [];
    initgetPostDoc(ClassUIDList);
  }

  //해당 doc에 하트 on/off 함수
  void changeHeart(DocumentSnapshot doc) async{
    var result = await firestore.collection('Post').doc(doc.id);
    if(doc['heart'] == true) {
      result.update({'heart' : false});
      doc.reference.update({'heart' : false});
    }
    else {
      result.update({'heart': true});
      doc.reference.update({'heart' : true});
    }
    notifyListeners();
    }

  }