import 'dart:convert';
import 'package:citio/models/otp_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOtpApi {
  static Future<VerifyOtpResponse> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final url = Uri.parse(
      "https://central-user-management.agreeabledune-30ad0cb8.uaenorth.azurecontainerapps.io/api/Auth/verify-otp",
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "otp": otp}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final data = VerifyOtpResponse.fromJson(responseData);

      // ✅ حفظ الـ Token و RefreshToken
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data.token);
      await prefs.setString('refreshToken', data.refreshToken);

      return data;
    } else {
      throw Exception("فشل في التحقق من الرمز: ${response.statusCode}");
    }
  }
}
