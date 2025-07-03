// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/notification_model.dart';

class NotificationApi {
  static const String baseUrl =
      'https://notification-service.agreeabledune-30ad0cb8.uaenorth.azurecontainerapps.io';
  static Uri getNotificationsUrl() => Uri.parse('$baseUrl/api/notifications');

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<NotificationModel>> fetchNotifications() async {
    final url = getNotificationsUrl();
    final token = await _getToken();
    print('#################Requesting URL: $url');

    print('Request URL: $url');
    print('Using token: $token');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print('📤 REQUEST TO: $url');
    print(
      '🔐 HEADERS: ${{'Content-Type': 'application/json', if (token != null) 'Authorization': 'Bearer $token'}}',
    );

    print('📥 STATUS CODE: ${response.statusCode}');
    print('📦 RESPONSE BODY: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => NotificationModel.fromJson(e)).toList();
    } else {
      throw Exception(
        'Failed to load notifications (status code: ${response.statusCode})',
      );
    }
  }
}
