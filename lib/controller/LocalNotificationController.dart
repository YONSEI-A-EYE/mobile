import "dart:developer";

import "package:aeye/page/baby_monitor.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:get/get.dart";

import '../../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp();
  String title = message.notification?.title ?? "title missing";
  String body = message.notification?.body ?? "body missing";
  NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: AndroidNotificationDetails(
      "Baby fall",
      "High_Importance_Notifications",
      priority: Priority.max,
      importance: Importance.max,
    ),
  );
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.show(
    message.notification.hashCode,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
  );
}

class LocalNotificationController extends GetxController {
  RxBool messaging = false.obs;

  void isOff() {
    messaging = false.obs;
    update();
  }

  void isOn() {
    messaging = true.obs;
    update();
  }

  BuildContext? _context = null;

  void setContext(BuildContext context) {
    _context = context;
    update();
  }

  void getAlert() {
    Get.to(() => BabyMonitor());
  }

  void removeAlert(BuildContext context) {
    Navigator.pop(context);
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final fcmToken = await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: DarwinInitializationSettings());

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notification) {
      String payload = notification.payload ?? "missing title";
      if (_context != null) {
        log("work well");
        getAlert();
        log("erherhehehehe");
        return;
      }

      //??????????????? ????????? ??????(foreground ??? ?????? ?????? -> context ????????????)

      // }, onDidReceiveBackgroundNotificationResponse:
      //         (NotificationResponse payloadData) {
      //   log("here2");
    });
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
          "Baby fall",
          "High_Importance_Notifications",
          priority: Priority.max,
          importance: Importance.max,
        ),
      );
      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          platformChannelSpecifics,
        );
      }
    });
  }

  void onMessageOpened() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      log("is background here");
      if (_context != null) {
        getAlert();
        return;
      }
    });
  }
}
