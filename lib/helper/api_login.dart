import 'dart:convert';
import 'package:citio/models/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiLoginHelper {
  static Future<LoginResponse?> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(
      "https://cms-central-ffb6acaub5afeecj.uaenorth-01.azurewebsites.net/api/auth/login",
    );

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
        // ✅ نحتفظ بنفس اسم التوكن القديم
        await prefs.setString('token', loginResponse.token ?? "");
        await prefs.setString('refreshToken', loginResponse.refreshToken ?? "");

        return loginResponse;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error["message"] ?? "حدث خطأ غير متوقع");
      }
    } catch (e) {
      throw Exception("فشل الاتصال بالخادم، حاول مرة أخرى");
    }
  }
}
