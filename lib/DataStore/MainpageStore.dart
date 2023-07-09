//메인페이지 페이지 관리
import 'package:flutter/cupertino.dart';

class MainpageStore extends ChangeNotifier {
  var tap = 0;

  void setTap(int i) {
    tap = i;
    notifyListeners();
  }
}