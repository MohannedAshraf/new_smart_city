// lib/helper/api_cash_payment.dart

// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/models/make_order_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiCashPaymentHelper {
  static Future<void> sendCashOrder(MakeOrderModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse(
      "${Urls.serviceProviderbaseUrl}/api/Orders/Cash-payment",
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ Cash order sent successfully");
    } else {
      print("❌ Failed to send cash order: ${response.body}");
      throw Exception("Cash payment failed");
    }
  }
}
