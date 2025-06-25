import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:citio/helper/fcm_api.dart';
import 'package:citio/services/notification_helper.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('🔄 Background Message Received: ${message.messageId}');

  final title = message.data['title'] ?? 'إشعار في الخلفية';
  final body = message.data['body'] ?? 'وصلتك رسالة أثناء عدم استخدام التطبيق';

  await NotificationHelper.showNotification(title: title, body: body);
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

      NotificationHelper.showNotification(
        title:
            message.notification?.title ??
            message.data['title'] ??
            'بدون عنوان',
        body:
            message.notification?.body ?? message.data['body'] ?? 'بدون محتوى',
      );
    });
  }

  void _handleOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📬 App opened via notification');
      // TODO: Navigate based on message.data if needed
    });
  }

  Future<void> _checkInitialMessage() async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      print('🚀 App launched via notification (terminated)');
      // TODO: Navigate based on initialMessage.data
    }
  }
}
