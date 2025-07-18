// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/models/rate_product_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductReviewApi {
  static const String baseUrl = '${Urls.serviceProviderbaseUrl}/api/Products';

  static Future<ProductReview?> getReview(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception("Token not found");

    final url = Uri.parse('$baseUrl/$productId/reviews');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProductReview.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception("فشل في تحميل التقييم: ${response.statusCode}");
    }
  }

  static Future<void> postReview(int productId, int rating) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception("Token not found");

    final url = Uri.parse('$baseUrl/$productId/reviews');
    final body = jsonEncode({"rating": rating, "comment": ""});

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      print("❌ RESPONSE BODY: ${response.body}");
      throw Exception("فشل في إرسال التقييم: ${response.statusCode}");
    }
  }
}
