import 'dart:convert';
import 'package:city/models/feedback_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackApiService {
  final Dio dio = Dio();

  Future<FeedbackResponse> sendFeedback({
    required String comment,
    required int rateValue,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("🔴 Token is null");
      return FeedbackResponse(message: "Token is null");
    }

    final url = 'https://cms-reporting.runasp.net/api/Feedback';
    final body = {"comment": comment, "rateValue": rateValue};

    try {
      print("📤 Sending Feedback...");
      print("🔸 URL: $url");
      print("🔸 Body: $body");

      final response = await dio.post(
        url,
        data: jsonEncode(body),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      print("✅ Response Status Code: ${response.statusCode}");
      print("📥 Response Data: ${response.data}");

      return FeedbackResponse.fromJson(response.data);
    } catch (e) {
      print("❌ Error while sending feedback: $e");
      return FeedbackResponse(message: "Error: $e");
    }
  }
}
