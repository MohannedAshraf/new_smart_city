import 'dart:convert';
import 'package:citio/core/utils/variables.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static const String _refreshUrl =
      '${Urls.cmsBaseUrl}/api/Account/refreshToken';

  static Future<bool> refreshTokenIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('token');
    final refreshToken = prefs.getString('refreshToken');

    if (accessToken == null || refreshToken == null) return false;

    try {
      final response = await http.post(
        Uri.parse(_refreshUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newToken = data['value']['token'];
        final newRefreshToken = data['value']['refreshToken'];

        if (newToken != null && newRefreshToken != null) {
          await prefs.setString('token', newToken);
          await prefs.setString('refreshToken', newRefreshToken);
          return true;
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('❌ Failed to refresh token: $e');
    }

    return false;
  }
}
