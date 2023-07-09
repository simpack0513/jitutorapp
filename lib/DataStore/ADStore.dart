import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final firestore = FirebaseFirestore.instance;

class ADStore extends ChangeNotifier {
  List<String> mainBanner = [];

  // 메인 배너 받아오기
  void getMainBanner() async{
    mainBanner = [];
    var result = await firestore.collection('AD').where("type", isEqualTo: 'home').get();
    for (var doc in result.docs) {
      mainBanner.add(doc['imageSrc']);
    }
    notifyListeners();
  }

}