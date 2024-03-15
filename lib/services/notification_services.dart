import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService{

  static Future<void> initalize() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("Notification initialized");
    }
  }

}