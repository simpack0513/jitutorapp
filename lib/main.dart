import 'dart:convert';
// 여기는 연동 페이지 import
import 'package:jitutorapp/DataStore/ClassStore.dart';
import 'package:jitutorapp/DataStore/ClasschildStore.dart';
import 'package:jitutorapp/DataStore/PointStore.dart';
import 'package:jitutorapp/DataStore/UserStore.dart';
import 'package:jitutorapp/DataStore/PostStore.dart';
import 'package:jitutorapp/teacherPage/mainPage.dart';
import 'signUp.dart';
import 'DataStore/InfoStore.dart';
import 'DataStore/scheduleStore.dart';

//
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final firestore = FirebaseFirestore.instance;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (c) => InfoStore()),
          ChangeNotifierProvider(create: (c) => UserStore()),
          ChangeNotifierProvider(create: (c) => ClassStore()),
          ChangeNotifierProvider(create: (c) => PostStore()),
          ChangeNotifierProvider(create: (c) => ClasschildStore()),
          ChangeNotifierProvider(create: (c) => ScheduleStore()),
          ChangeNotifierProvider(create: (c) => PointStore()),
        ],
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('ko', 'KR'),
          ],
          home : MyApp(),
        ),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return signUp();
    //return signUp();
  }
}