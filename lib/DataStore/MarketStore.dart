// 학생 페이지에서 마켓 아이템 관리
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final firestore = FirebaseFirestore.instance;

class MarketStore extends ChangeNotifier {
  //변수
  List marketItem = [];  //Item 리스트

  //함수
  // 마켓 초기화 (get Item)
  void getMarketItem() async{
    marketItem = [];
    var result = await firestore.collection('MarketItem').get();
    for (var doc in result.docs) {
      marketItem.add(doc);
    }
    notifyListeners();
  }

  // 물건을 살수 있을지? bool 포인트 계산
  bool checkPointBeforeBuy(int point, int i) {
    if (point >= marketItem[i]['price']) {
      return true;
    }
    return false;
  }

  void postNewOrder(int i, String name, String userUID) async{
    String time = DateTime.now().toString();
    await firestore.collection('Order').add({
      'image' : marketItem[i]['image'],
      'name' : marketItem[i]['name'],
      'userName' : name,
      'userUID' : userUID,
      'orderTime' : time,
      'state' : 'before',
    });
    
  }




}