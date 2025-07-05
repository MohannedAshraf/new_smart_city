import 'dart:convert';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/models/reset_password_model.dart';
import 'package:http/http.dart' as http;

class ResetPasswordApi {
  static Future<OtpResponse> sendVerificationOtp(String email) async {
    final url = Uri.parse(
      "${Urls.serviceProviderbaseUrl}/api/Auth/send-verification-otp",
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      return OtpResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("فشل في إرسال الكود. الحالة: ${response.statusCode}");
    }
  }
}
