// import 'package:flutter/material.dart';
//
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:secretarial_app/global/serves/firebase_messaging.dart';
// import 'package:secretarial_app/global/serves/push_notifications_serves.dart';
//
//
//
//
// class NotificationSenderScreen extends StatefulWidget {
//   const NotificationSenderScreen({super.key});
//
//   @override
//   _NotificationSenderScreenState createState() => _NotificationSenderScreenState();
// }
//
// class _NotificationSenderScreenState extends State<NotificationSenderScreen> {
//   final NotificationService _notificationService = NotificationService();
//
//   @override
//   void initState() {
//     super.initState();
//     _initApp();
//   }
//
//   Future<void> _initApp() async {
//     await _notificationService.init();
//     await requestNotificationPermission();
//     setupFirebaseMessagingListeners();
//   }
//
//   Future<void> requestNotificationPermission() async {
//     final status = await Permission.notification.request();
//     if (status == PermissionStatus.granted) {
//       print("Notification Permission Granted");
//     } else {
//       print("Notification Permission Denied");
//     }
//   }
//
//   void setupFirebaseMessagingListeners() {
//     FirebaseMessaging.instance.getInitialMessage().then(handleInitialMessage);
//     FirebaseMessaging.onMessage.listen(_notificationService.showNotification);
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessageOpenedApp);
//   }
//
//   void handleInitialMessage(RemoteMessage? message) {
//     if (message != null) {
//       print("Received initial message: ${message.messageId}");
//     }
//   }
//
//   void handleMessageOpenedApp(RemoteMessage message) {
//     print("Message opened app: ${message.messageId}");
//   }
//
//   void sendNotification() async {
//     const deviceToken = 'dR4_P2gtQranG4j5Kv1rwT:APA91bGerJSjSYy5h-bADRISMP_R4ZABSq0qPvRJ9gbqanoRnxXVx14hO1CAjwrQYyZQ1wwpDcmRbP55n8DPyjAXxFcyd4gk5u3_hXVaJQtupROwkQRO_sNWFyewPWgH3q7qS-QBOybl';
//     const tripID = 'sampleTripID';
//     await PushNotificationsServes.sendNotificationsToSelectedDriver(deviceToken, context, tripID);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Send Notification'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: sendNotification,
//           child: const Text('Send Notification'),
//         ),
//       ),
//     );
//   }
// }
