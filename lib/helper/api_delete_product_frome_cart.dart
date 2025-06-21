import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeleteFromCartService {
  static const String baseUrl = 'https://service-provider.runasp.net/api/Carts';

  static Future<void> deleteProductFromCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    final url = Uri.parse('$baseUrl/$productId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 204) {
      // ✅ حذف بنجاح
      return;
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['errors']?.join(', ') ?? 'فشل حذف المنتج من السلة');
    }
  }
}
