import 'dart:convert';
// 여기는 연동 페이지 import
import 'package:get/get.dart';
import 'package:jitutorapp/DataStore/ClassStore.dart';
import 'package:jitutorapp/DataStore/ClasschildStore.dart';
import 'package:jitutorapp/DataStore/MainpageStore.dart';
import 'package:jitutorapp/DataStore/MarketStore.dart';
import 'package:jitutorapp/DataStore/OrderStore.dart';
import 'package:jitutorapp/DataStore/PointStore.dart';
import 'package:jitutorapp/DataStore/UserStore.dart';
import 'package:jitutorapp/DataStore/PostStore.dart';
import 'package:jitutorapp/DataStore/scheduleConformStore.dart';
import 'package:jitutorapp/mainLodding.dart';
import 'package:jitutorapp/notification_controller.dart';
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
          ChangeNotifierProvider(create: (c) => MarketStore()),
          ChangeNotifierProvider(create: (c) => OrderStore()),
          ChangeNotifierProvider(create: (c) => ScheduleConformStore()),
          ChangeNotifierProvider(create: (c) => MainpageStore()),
        ],
        child: GetMaterialApp(
          initialBinding: BindingsBuilder.put(() => NotificationController(), permanent: true),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
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
    return LoadingPage();
    //return signUp();
  }
}