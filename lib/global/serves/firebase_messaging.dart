import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const String _channelId = "high_importance_channel";
  static const String _channelName = "High Importance Notifications";
  static const String _channelDescription =
      "This channel is used for important notifications.";





  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/custom_icon');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await Firebase.initializeApp();
  }

  Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('www'),
      icon: '@drawable/custom_icon',
      enableVibration: true,
      visibility: NotificationVisibility.public,
      enableLights: true,
      autoCancel: true,
      color: Colors.white,
      largeIcon: DrawableResourceAndroidBitmap('@drawable/custom_icon'),
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      message.notification?.title ?? "Default Title",
      message.notification?.body ?? "Default Body",
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}




Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}