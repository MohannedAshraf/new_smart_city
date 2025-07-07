import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  static const String baseUrl = 'https://graduation.amiralsayed.me/api/users';

  static Future<Map<String, String>> getUserInfo(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/$userId');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return {
        'userName': jsonData['localUserName'] ?? 'Unknown',
        'avatarUrl': 'https://graduation.amiralsayed.me${jsonData['avatarUrl'] ?? ''}',
      };
    } else {
      print('❌ Failed to get user $userId - ${response.statusCode}');
      return {
        'userName': 'Unknown',
        'avatarUrl': '',
      };
    }
  }
}
