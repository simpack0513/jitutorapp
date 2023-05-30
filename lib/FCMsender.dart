import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

// 상대방 기기에 앱 푸시 알림을 띄우는 코드
// FCM 세팅은 notification_controller에 있음

class FCMController {
  final String _serverKey = "AAAAHSEOxrY:APA91bFu_6ChkK7bhMQJIVU3h5CtRfXHWMhHQhBzfx1bwJuZ9VhA6qrqpeRKKLqlr0Sard9De77Yz4DftfUDW9RsoR-ZSOR2DFLiJTK-ibqOWwZxWwHnExufFXbJXqPbYyFUaCFb48oW";

  Future<void> sendMessage({
    required String userToken,
    required String title,
    required String body,
  }) async {

    http.Response response;

    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    try {
      response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$_serverKey'
          },
          body: jsonEncode({
            'notification': {'title': title, 'body': body, 'sound': 'false'},
            'ttl': '60s',
            "content_available": true,
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              "action": '테스트',
            },
            // 상대방 토큰 값, to -> 단일, registration_ids -> 여러명
            'to': userToken
            // 'registration_ids': tokenList
          }));
    } catch (e) {
      print('error $e');
    }
  }
}