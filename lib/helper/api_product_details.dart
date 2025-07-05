import 'package:citio/core/utils/variables.dart';
import 'package:citio/models/product_details_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsService {
  static const String imageBaseUrl = Urls.serviceProviderbaseUrl;

  static const String baseUrl = '${Urls.serviceProviderbaseUrl}/api/Products';

  static Future<ProductDetails> fetchProductDetails(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ProductDetails.fromJson(jsonData);
    } else {
      throw Exception('Failed to load product details');
    }
  }
}
