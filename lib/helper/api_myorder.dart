import 'dart:convert';
import 'package:citio/models/myorder_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrdersApiHelper {
  static Future<List<OrderItem>> fetchOrders({String? status}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token not found');

    final queryParams =
        (status != null && status.isNotEmpty) ? '?Statuses=$status' : '';
    final url = Uri.parse(
      'https://service-provider.runasp.net/api/Orders/users$queryParams',
    );

    print("🧪 Calling URL: $url");

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List items = data['items'];
      return items.map((e) => OrderItem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch orders: ${response.statusCode}');
    }
  }
}
