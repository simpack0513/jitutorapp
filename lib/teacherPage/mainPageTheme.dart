import 'package:flutter/material.dart';

//테마
var mainTheme = ThemeData(
  appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1.0,
      centerTitle: false,
      iconTheme: IconThemeData(
        color: Colors.grey,
        size: 40,
      )
  ),
  textTheme: TextTheme(
      headline1 : TextStyle(
        fontFamily: 'Pretendard',
        color: Colors.black,
        fontSize: 25,
      )
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    showUnselectedLabels: false,
    showSelectedLabels: false,
    elevation: 3.0,
    backgroundColor: Colors.white,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.grey,
  ),

);