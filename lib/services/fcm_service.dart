// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:citio/helper/fcm_api.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('🔄 Background Message Received: ${message.messageId}');

  final title = message.data['title'] ?? 'إشعار في الخلفية';
  final body = message.data['body'] ?? 'وصلتك رسالة أثناء عدم استخدام التطبيق';

  await _showNotification(title: title, body: body);
}

Future<void> initializeNotifications() async {
  const androidSettings = AndroidInitializationSettings(
    '@drawable/notification_icon',
  );

  const initSettings = InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

Future<void> _showNotification({
  required String title,
  required String body,
}) async {
  const androidDetails = AndroidNotificationDetails(
    'default_channel',
    'Default Channel',
    channelDescription: 'القناة الافتراضية للإشعارات',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@drawable/notification_icon',
  );

  const notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title,
    body,
    notificationDetails,
  );
}

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    await _requestPermission();
    await _getTokenAndSendToBackend();
    _handleForegroundMessages();
    _handleOpenedApp();
    _checkInitialMessage();
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('🔔 Permission status: ${settings.authorizationStatus}');
  }

  Future<void> _getTokenAndSendToBackend() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('token');

      if (userToken == null) {
        print('⛔️ No user token found.');
        return;
      }

      final fcmToken = await _messaging.getToken();
      print('📲 FCM Token: $fcmToken');

      if (fcmToken != null) {
        await FCMApi().sendTokenToBackend(
          token: fcmToken,
          userToken: userToken,
        );
      }
    } catch (e) {
      print('❌ Error sending FCM token: $e');
    }
  }

  void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Foreground Message: ${message.notification?.title}');

      final title =
          message.notification?.title ?? message.data['title'] ?? 'بدون عنوان';
      final body =
          message.notification?.body ?? message.data['body'] ?? 'بدون محتوى';

      _showNotification(title: title, body: body);
    });
  }

  void _handleOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📬 App opened via notification');
    });
  }

  Future<void> _checkInitialMessage() async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      print('🚀 App launched via notification (terminated)');
    }
  }
}
