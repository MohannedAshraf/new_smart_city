import 'dart:convert';
import 'package:citio/models/chat_message_model.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiChatHelper {
  static Future<List<ChatMessage>> getOldMessages({
    required String otherUserId,
    required int orderId,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) throw Exception("يرجى تسجيل الدخول أولًا");

    final url = Uri.parse(
      "${Urls.serviceProviderbaseUrl}/api/Messages/conversation/$otherUserId/$orderId",
    );

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => ChatMessage.fromApiJson(json)).toList();
      } else {
        throw Exception("فشل تحميل الرسائل (كود: ${response.statusCode})");
      }
    } catch (e) {
      throw Exception("❌ Failed to load old messages: $e");
    }
  }
}
