import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secretarial_app/administration/add_secretary/screen/add_secretary.dart';
import 'package:secretarial_app/administration/all_secretarial/screen/all_secretarial.dart';
import 'package:secretarial_app/administration/home/screen/home_screen.dart';
import 'package:secretarial_app/auth/login/screen/login_screen.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:secretarial_app/firebase_options.dart';
import 'package:secretarial_app/global/data/local/cache_helper.dart';
import 'package:secretarial_app/global/data/remote/dio_helper.dart';
import 'package:secretarial_app/global/serves/firebase_messaging.dart';
import 'package:secretarial_app/global/utils/size_app.dart';
import 'package:secretarial_app/secretariat/add_task/screen/add_task_screen.dart';

import 'secretariat/home/screen/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  SizeApp.screenSize =
      MediaQueryData.fromView(WidgetsBinding.instance.window).size;
  await CacheHelper.init();
  runApp(const MyApp());


}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    // _initApp();
  }



  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (status == PermissionStatus.granted) {
      print("Notification Permission Granted");
    } else {
      print("Notification Permission Denied");
    }
  }



  // Future<void> _initApp() async {
  //   await _notificationService.init();
  //  await requestNotificationPermission();
  //     setupFirebaseMessagingListeners();
  // }

  // void setupFirebaseMessagingListeners() {
  //   FirebaseMessaging.instance.getInitialMessage().then(handleInitialMessage);
  //   FirebaseMessaging.onMessage.listen(_notificationService.showNotification);
  //   FirebaseMessaging.onMessageOpenedApp.listen(handleMessageOpenedApp);
  // }

  // void handleInitialMessage(RemoteMessage? message) {
  //   if (message != null) {
  //     print("Received initial message: ${message.messageId}");
  //   }
  // }

  void handleMessageOpenedApp(RemoteMessage message) {
    print("Message opened app: ${message.messageId}");
  }



  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: LoginScreen(),
      // home: HomeAdministrationScreen(),
      // home: HomeAdministrationScreen(),
    );
  }
}
