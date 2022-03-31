import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:http/http.dart' as http;

class PushNotificationsProvider {
  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void initNotifications() async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void onMessageListener() {
    //Background
    FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? message) {
        if (message != null) {
          debugPrint('NEW NOTIFICATIONS: $message');
        }
      },
    );

    //To recive the notifications in foreground
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                //  add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ),
          );
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
    });
  }

  void saveToken(
    String idUser,
    BuildContext context,
    String sessionToken,
  ) async {
    String? token = await FirebaseMessaging.instance.getToken();
    UsersProvider usersProvider = UsersProvider();
    usersProvider.init(context, token: sessionToken);
    usersProvider.updateNotificationToken(idUser, token!);
  }

  Future<void> sendMessage(
    String to,
    Map<String, dynamic> data,
    String title,
    String body,
  ) async {
    Uri uri = Uri.https('fcm.googleapis.com', '/fcm/send');

    await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAQO_e4Uo:APA91bFxLo86MoRujOyKDr4kk18hT1v-TeTWFffXDDmB2qrxO8V657gWz7V6VSBKRJK9P1aHwWgQvGr7ZJGqGHWxR2PPQkA__DNlorHZj5_CH8Y_GMUd45PyEGds92-rsionfzghPBCx'
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'ttl': '4500s',
          'data': data,
          'to': to,
        },
      ),
    );
  }

  Future<void> sendMessageMultiple(
    List<String>? toList,
    Map<String, dynamic> data,
    String title,
    String body,
  ) async {
    Uri uri = Uri.https('fcm.googleapis.com', '/fcm/send');

    await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAQO_e4Uo:APA91bFxLo86MoRujOyKDr4kk18hT1v-TeTWFffXDDmB2qrxO8V657gWz7V6VSBKRJK9P1aHwWgQvGr7ZJGqGHWxR2PPQkA__DNlorHZj5_CH8Y_GMUd45PyEGds92-rsionfzghPBCx'
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'ttl': '4500s',
          'data': data,
          'registration_ids': toList,
        },
      ),
    );
  }
}
