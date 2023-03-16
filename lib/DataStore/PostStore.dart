// 게시글 정보 저장하는 곳
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
final firestore = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;

class PostStore extends ChangeNotifier {
  var postDocList = [];
  int listNum = 0; // 수정 or 삭제할 게시글 인덱스 저장
  // 마지막으로 로드된 게시글 번호
  var lastVisible;

  // 클래스 UID에 맞는 포스트 문서를 받는 함수
  void initgetPostDoc(List ClassUIDList) async {
    if (postDocList.length >= 2) return;
    var result = await firestore.collection('Post').where(
        "classUID", whereIn: ClassUIDList)
        .orderBy("date", descending: true)
        .limit(2)
        .get();
    for (var doc in result.docs) {
      postDocList.add(doc);
      print(doc['image']);
    }
    if (postDocList.isNotEmpty) {
      lastVisible = postDocList[postDocList.length - 1];
    }
    print(postDocList);
    notifyListeners();
  } //

  // 클래스에 UID에 맞는 포스트 more get 함수
  void moregetPostDoc(List ClassUIDList) async {
    var result = await firestore.collection('Post').where(
        "classUID", whereIn: ClassUIDList).orderBy("date", descending: true)
        .startAfterDocument(lastVisible).limit(2)
        .get();
    lastVisible = result.docs[result.size - 1];
    for (var doc in result.docs) {
      postDocList.add(doc);
      print(doc['date']);
    }
    lastVisible = postDocList[postDocList.length - 1];
    print(postDocList);
    notifyListeners();
  }

  // 화면 새로고침 시 함수
  Future<void> refreshPost(List ClassUIDList) async {
    postDocList = [];
    initgetPostDoc(ClassUIDList);
  }

  //해당 doc에 하트 on/off 함수
  void changeHeart(int i) async {
    var result = await firestore.collection('Post').doc(postDocList[i].id);
    if (postDocList[i]['heart'] == true) {
      result.update({'heart': false});
      await result.get().then((value) => postDocList[i] = value);
    }
    else {
      result.update({'heart': true});
      postDocList[i] = result.snapshots();
      await result.get().then((value) => postDocList[i] = value);
    }
    notifyListeners();
  }

  // listNum 수정함수
  void setlistNum(int num) {
    listNum = num;
    notifyListeners();
  }

  // 데이터 삭제하기
  void deletePost(List ClassUIDList) async{
    int error_flag = 0;
    Reference ref = storage
        .ref()
        .child('postImage')
        .child(postDocList[listNum]['filename']);
    try {
      await ref.delete();
    } catch(e) {
      error_flag = 1;
      Fluttertoast.showToast(
          msg: '이미지 삭제 도중 오류가 발생했습니다. 다시 시도해주세요.',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          fontSize: 12
      );
      print(e);
    }
    if (error_flag == 0) {
      try {
        await postDocList[listNum].reference.delete();
      } catch(e) {
        Fluttertoast.showToast(
            msg: '이미지 삭제 도중 오류가 발생했습니다.',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            fontSize: 12
        );
        postDocList[listNum]['classUID'] = 'error';
      }
    }
    refreshPost(ClassUIDList);
  }

  //데이터 수정하기
  void updatePost(String comment, List ClassUIDList) async{
    try {
      await postDocList[listNum].reference.update(
          {'comment' : comment}
      );
    } catch(e) {
      Fluttertoast.showToast(
          msg: '게시글 수정 도중 오류가 발생했습니다. 다시 시도해주세요.',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          fontSize: 12
      );
    }
    refreshPost(ClassUIDList);
  }



}// 클래스 끝