// lib/helper/api_discount.dart

import 'dart:convert';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/models/discount_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiDiscount {
  static Future<DiscountResponse?> getDiscount(String discountCode) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final url = Uri.parse(
      "${Urls.serviceProviderbaseUrl}/api/Banners/GetDiscount?discountCode=$discountCode",
    );

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return DiscountResponse.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load discount');
    }
  }
}
