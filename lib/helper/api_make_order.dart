// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:citio/models/make_order_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiMakeOrder {
  static Future<void> sendOrder(MakeOrderModel order) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(
      'token',
    ); // تأكد إن دا نفس المفتاح المستخدم ف التخزين

    final uri = Uri.parse('https://service-provider.runasp.net/api/Orders');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(order.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Order Sent Successfully");
        print(response.body);
      } else {
        print("❌ Failed to send order: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print("❗ Exception while sending order: $e");
    }
  }
}
