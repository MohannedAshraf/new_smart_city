// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:citio/helper/fcm_api.dart';
import 'package:citio/services/notification_helper.dart';

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    await _requestPermission();
    await _getTokenAndSendToBackend(); // ✅ مدموجة
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
      print('📩 Message in Foreground: ${message.notification?.title}');
      NotificationHelper.showNotification(
        title: message.notification?.title ?? 'بدون عنوان',
        body: message.notification?.body ?? 'بدون محتوى',
      );
    });
  }

  void _handleOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📬 User tapped on notification (from background)');
    });
  }

  Future<void> _checkInitialMessage() async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      print('🚀 App launched via notification (terminated)');
    }
  }
}
