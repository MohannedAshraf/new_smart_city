import 'dart:convert';
import 'package:city/models/emergency_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyApiService {
  static Future<String?> sendEmergency(EmergencyRequestModel request) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token"); // اتأكد انه محفوظ

    final response = await http.post(
      Uri.parse("https://cms-reporting.runasp.net/api/MReport/emergency"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message'];
    } else {
      return "فشل إرسال البلاغ!";
    }
  }
}
