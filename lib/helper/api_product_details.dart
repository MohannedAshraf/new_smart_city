import 'package:citio/models/product_details_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetailsService {
  static const String imageBaseUrl = 'https://service-provider.runasp.net';

  static const String baseUrl =
      'https://service-provider.runasp.net/api/Products';

  static Future<ProductDetails> fetchProductDetails(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ProductDetails.fromJson(jsonData);
    } else {
      throw Exception('Failed to load product details');
    }
  }
}
