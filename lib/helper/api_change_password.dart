import 'dart:convert';
import 'package:citio/models/change-password_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiChangePassword {
  static Future<ChangePasswordResponse> changePassword(
    String newPassword,
  ) async {
    const String url =
        'https://central-user-management.agreeabledune-30ad0cb8.uaenorth.azurecontainerapps.io/api/Auth/change-password';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'newPassword': newPassword}),
    );

    if (response.statusCode == 200) {
      return ChangePasswordResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("فشل في الاتصال بالسيرفر: ${response.statusCode}");
    }
  }
}
