import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/provider/push_notifications_provider.dart';
import 'package:shop_app/routes/routes.dart';

PushNotificationsProvider pushNotificationsProvider =
    PushNotificationsProvider();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  debugPrint('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51JFh5jKfThoPE1Ioe9NjNnNzjqP3g4XknEJMO6xuXWPVCzqZuY0AZ57CDzhlhjxBvmj12j1UyybQUSrG6hzDty9100F74ItwRm';
  await Firebase.initializeApp();
  await Stripe.instance.applySettings();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  pushNotificationsProvider.initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void initState() {
    pushNotificationsProvider.onMessageListener();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop app',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.initialHome,
      onGenerateRoute: Routes.onGenerateRoute,
      theme: themeData,
    );
  }
}
