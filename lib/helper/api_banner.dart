import 'dart:convert';
import 'package:citio/models/banner_model.dart';
import 'package:http/http.dart' as http;

class ApiTopBanners {
  static const String baseUrl = 'https://service-provider.runasp.net';

  static Future<List<BannerModel>> fetchTopBanners() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Banners/top-Banners'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => BannerModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load banners');
    }
  }
}
