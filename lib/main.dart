import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:go_saku/domain/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/utils/hive_service.dart';
import 'domain/model/fcm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await Firebase.initializeApp();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/saku');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      // Tangkap data yang dikirimkan oleh backend
      String title = message.notification!.title ?? '';
      String body = message.notification!.body ?? '';

      showReceiveNotification(title, body);
      showTransferNotification(title, body);
      showDepositNotification(title, body);
      showWithdrawNotification(title, body);
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Color.fromARGB(255, 43, 68, 207)));
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: login_Screnn(),
    );
  }
}
