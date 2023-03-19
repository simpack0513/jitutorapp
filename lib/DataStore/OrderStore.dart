// 학생 페이지에서 주문한 상품(보관함) 관리
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final firestore = FirebaseFirestore.instance;

class OrderStore extends ChangeNotifier {
  List orderList = [];

  void initOrderList(String userUID) async{
    orderList = [];
    var result = await firestore.collection('Order').where("userUID", isEqualTo: userUID).orderBy("orderTime", descending: true).get();
    for(var doc in result.docs) {
      orderList.add(doc);
    }
    notifyListeners();
  }
}