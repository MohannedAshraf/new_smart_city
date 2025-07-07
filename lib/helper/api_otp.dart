// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/models/otp_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOtpApi {
  static Future<VerifyOtpResponse> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final url = Uri.parse("${Urls.cmsBaseUrl}/api/Auth/verify-otp");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "otp": otp}),
    );
    print("🔹 Response Status Code: ${response.statusCode}");
    print("🔹 Response Body: ${response.body}");
    print("🔹 URL: $url");
    print("🔹 Request Body: ${jsonEncode({"email": email, "otp": otp})}");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final data = VerifyOtpResponse.fromJson(responseData);

      // ✅ حفظ الـ Token و RefreshToken
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data.token);
      await prefs.setString('refreshToken', data.refreshToken);

      return data;
    } else {
      // ❌ نرمي نص صريح فقط
      throw "تحقق من الرمز";
    }
  }
}
