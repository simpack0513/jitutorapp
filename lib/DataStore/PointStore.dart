// 선생님이 포인트 줄 때 쓰는 공간
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
final firestore = FirebaseFirestore.instance;

class PointStore extends ChangeNotifier {
  int seletedPoint = 0; // 부여할 포인트


  // 부여할 포인트 초기화
  void initPoint() {
    seletedPoint = 0;
    notifyListeners();
  }
  // 부여할 포인트 설정
  void setPoint(String num) {
    seletedPoint = int.parse(num);
    notifyListeners();
  }

  // 선생님, 학생 모두 데이터 베이스에 부여한 포인트 반영
  void updatePoint(String userUID, String studentUID) async{
    var result = await firestore.collection('Person').doc(userUID).get();
    int remainPoint = result['point'] - seletedPoint;
    result.reference.update({
      'point' : remainPoint,
    });
    result = await firestore.collection('Person').doc(studentUID).get();
    int remainPoint2 = result['point'] + seletedPoint;
    result.reference.update({
      'point' : remainPoint2,
    });

    String str = '잔여 포인트는 : ' + remainPoint.toString() + '입니다.';
    Fluttertoast.showToast(
      msg: str,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black,
      fontSize: 12,
    );
  }
}