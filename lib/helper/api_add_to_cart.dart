import 'dart:convert';
import 'package:city/models/add_to_cart_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddToCartService {
  static const String _baseUrl =
      "https://service-provider.runasp.net/api/Carts/items";

  static Future<AddToCartResponse> addToCart({
    required int productId,
    required int quantity,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "productId": productId.toString(),
        "quantity": quantity.toString(),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AddToCartResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("فشل في إضافة المنتج إلى العربة");
    }
  }
}
