// 학생 페이지에서 주문한 상품(보관함) 관리
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
final firestore = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;

class OrderStore extends ChangeNotifier {
  List orderList = [];
  bool needRefresh = false; // 초기화가 필요한지 확인

  void initOrderList(String userUID) async{
    orderList = [];
    var result = await firestore.collection('Order').where("userUID", isEqualTo: userUID).orderBy("orderTime", descending: true).get();
    for(var doc in result.docs) {
      if (doc['state'] != 'delete') {
        orderList.add(doc);
      }
    }
    notifyListeners();
  }

  void deleteOrder(int index) async{
    String time = DateTime.now().toString();
    var ref = orderList[index].reference;
    Reference imageRef = storage
        .ref()
        .child('giftcon')
        .child(orderList[index]['giftconFilename']);
    orderList.removeAt(index);
    notifyListeners();

    await imageRef.delete();
    ref.update({
      'state' : 'delete',
      'giftconFilename' : FieldValue.delete(),
      'giftconImage' : FieldValue.delete(),
      'deleteTime' : time,
    });

  }

  void setRefreshTrue() { // 새로운 주문이 있고 리프래쉬가 필요하다고 설정
    needRefresh = true;
    notifyListeners();
  }

  void setRefreshFalse() { // 리프래쉬 후 false로 설정
    needRefresh = false;
    notifyListeners();
  }

  void deleteOrderListElement(int index) { //특정 인덱스 원소 제거
    orderList.removeAt(index);
    notifyListeners();
  }



  // 관리자 모드 모든 주문 받아오기 (단, 아직 기프티콘 등록이 안된 상품만)
  void getAllBeforeOrder() async{
    orderList = [];
    var result = await firestore.collection('Order').where("state", isEqualTo: 'before').orderBy("orderTime", descending: true).get();
    for(var doc in result.docs) {
      orderList.add(doc);
    }
    notifyListeners();
  }
}