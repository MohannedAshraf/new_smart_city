import 'dart:convert';
import 'package:citio/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static const String baseUrl = "https://service-provider.runasp.net";

  static Future<List<Product>> fetchMostRequestedProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Products/most-requested'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
