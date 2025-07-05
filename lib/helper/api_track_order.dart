// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/models/track_order_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiTrackOrder {
  static Future<TrackOrderModel?> fetchOrderDetails(int orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      print("❌ No token found");
      return null;
    }

    final url = Uri.parse(
      "${Urls.serviceProviderbaseUrl}/api/Orders/Details/$orderId",
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return TrackOrderModel.fromJson(decoded);
    } else {
      print("❌ Fetch failed: ${response.statusCode}, ${response.body}");
      return null;
    }
  }
}
