import 'dart:convert';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/models/order_details_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsApiHelper {
  static Future<VendorOrderDetailsResponse> fetchOrderDetails({
    required int orderId,
    required String vendorId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token not found');

    final url = Uri.parse(
      '${Urls.serviceProviderbaseUrl}/api/Orders/orders/$orderId/vendors/$vendorId',
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return VendorOrderDetailsResponse.fromJson(data);
    } else {
      throw Exception('Failed to fetch order details: ${response.statusCode}');
    }
  }
}
