// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/models/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiLoginHelper {
  static Future<LoginResponse?> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("${Urls.cmsBaseUrl}/api/Auth/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email.trim(), "password": password.trim()}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(data);

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', loginResponse.token ?? "");
        await prefs.setString('refreshToken', loginResponse.refreshToken ?? "");

        print("✅ Token: ${loginResponse.token}");
        print("🔁 Refresh Token: ${loginResponse.refreshToken}");

        return loginResponse;
      } else {
        final error = jsonDecode(response.body);
        final errorMessage = error["message"] ?? "بيانات الدخول غير صحيحة";
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception(
        e.toString().contains("SocketException")
            ? "فشل الاتصال بالخادم، تأكد من الاتصال بالإنترنت"
            : e.toString().replaceAll("Exception: ", ""),
      );
    }
  }
}
