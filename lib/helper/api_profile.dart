// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';
import 'package:citio/core/utils/variables.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:citio/models/profile_model.dart';

const String baseUrl = Urls.cmsBaseUrl;

class ApiProfileHelper {
  static Future<ProfileModel?> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception("التوكن غير موجود");

    final url = Uri.parse("$baseUrl/api/Account");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final profile = ProfileModel.fromJson(data);

      if (profile.id != null) {
        try {
          final idAsInt = int.parse(profile.id!);
          await prefs.setInt('mobileUserId', idAsInt);
          print("✅ userId saved: $idAsInt");
        } catch (e) {
          print("❌ فشل في تحويل userId إلى int: $e");
        }
      }

      // ✅ تخزين العنوان الكامل
      if (profile.address != null ||
          profile.buildingNumber != null ||
          profile.floorNumber != null) {
        final fullAddress =
            '${profile.address ?? ''}, ${profile.buildingNumber ?? ''}, ${profile.floorNumber ?? ''}';
        await prefs.setString('fullAddress', fullAddress);
        print("✅ Full address saved: $fullAddress");
      }

      return profile;
    } else {
      throw Exception("فشل في تحميل البيانات");
    }
  }
}
