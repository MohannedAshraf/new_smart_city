// services/get_my_user_minimal.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:citio/models/socialmedia_user_minimal.dart';

class GetMyUserMinimalService {
  Future<SocialmediaUserMinimal?> fetchMyUser(String token) async {
    final url = Uri.parse('https://graduation.amiralsayed.me/api/users/me');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return SocialmediaUserMinimal.fromJson(jsonData);
      } else {
        print('❌ Error fetching user: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Exception while fetching user: $e');
      return null;
    }
  }
}
