import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:city/models/cart_model.dart';

class ApiCartModel {
  static const String baseUrl = 'https://service-provider.runasp.net/api';

  static Future<CartModel> fetchCart() async {
    final url = Uri.parse('$baseUrl/Carts');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // تأكد إن المفتاح ده صحيح

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن، يرجى تسجيل الدخول أولاً');
    }

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    // ignore: avoid_print
    print('Bearer $token');
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        return CartModel.fromJson(data);
      } catch (e) {
        throw Exception('فشل في معالجة بيانات السلة: ${e.toString()}');
      }
    } else {
      throw Exception('فشل في تحميل السلة (Status: ${response.statusCode})');
    }
  }
}
