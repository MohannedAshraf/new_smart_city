import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:citio/models/my_socialmedia_user.dart';

class GetMySocialmediaUserService {
  Future<MySocialmediaUser?> fetchMyUser(String token) async {
    final url = Uri.parse('https://graduation.amiralsayed.me/api/users/me');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MySocialmediaUser.fromJson(jsonData); // ✅ التعديل هنا
      } else {
        print('❌ Error fetching user: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Exception: $e');
      return null;
    }
  }
}
