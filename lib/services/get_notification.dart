// ignore_for_file: avoid_print

import 'package:citio/helper/api.dart';
import 'package:citio/models/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetNotifications {
  Future<List<NotificationModel>> getNotifications({
    String? category,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    print('📡 [GetNotifications] Fetching notifications...');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    // بناء الرابط مع pagination و category إذا موجودة
    final queryParameters = <String, String>{
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
      if (category != null) 'category': category,
    };

    final uri = Uri.https(
      'notification-service.agreeabledune-30ad0cb8.uaenorth.azurecontainerapps.io',
      '/api/notifications',
      queryParameters,
    );

    // استدعاء API عبر كلاس Api الموجود عندك
    final data = await Api().get(url: uri.toString(), token: token);

    // حسب المعلومات عندنا، الاستجابة عبارة عن قائمة مباشرة من الإشعارات
    if (data is List) {
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } else {
      throw Exception('تنسيق البيانات غير صحيح: متوقع قائمة.');
    }
  }
}
