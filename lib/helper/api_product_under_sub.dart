// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_under_sub_model.dart';

class ApiProductUnderSub {
  static const String baseUrl = 'https://service-provider.runasp.net/api';
  static const String imageBaseUrl = 'https://service-provider.runasp.net';

  static Future<List<ProductUnderSubModel>> fetchProductsBySubCategory(
    int subCategoryId,
  ) async {
    final url = Uri.parse('$baseUrl/SubCategory/$subCategoryId/products');

    try {
      // ✅ الحصول على التوكن من SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      print('Request URL: $url');
      print('Token: $token');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token', // ✅ التوكن هنا
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'] != null) {
          final List<dynamic> items = data['items'];
          return items.map((e) => ProductUnderSubModel.fromJson(e)).toList();
        } else {
          throw Exception('لا توجد منتجات لهذا القسم');
        }
      } else {
        throw Exception('فشل في تحميل المنتجات (${response.statusCode})');
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('فشل في الاتصال بالخادم أو في تحليل البيانات: $e');
    }
  }
}
