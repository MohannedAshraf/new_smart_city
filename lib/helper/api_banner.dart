// File: api_banner.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:citio/models/banner_model.dart';

class ApiTopBanners {
  static const String baseUrl = 'https://service-provider.runasp.net';

  static Future<List<BannerModel>> fetchTopBanners() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/api/Banners/top-Banners');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => BannerModel.fromJson(json)).toList();
    } else {
      throw Exception('فشل تحميل البانرات: ${response.statusCode}');
    }
  }
}
