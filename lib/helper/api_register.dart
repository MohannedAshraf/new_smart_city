import 'dart:convert';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/models/register_model.dart';
import 'package:http/http.dart' as http;

class ApiRegisterHelper {
  static Future<RegisterResponse> registerUser({
    required String fullName,
    required String phoneNumber,
    required String email,
    required String password,
    required String address,
    required String buildingNumber,
    required String floorNumber,
  }) async {
    final url = Uri.parse("${Urls.cmsBaseUrl}/api/Auth/register");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fullName": fullName,
          "phoneNumber": phoneNumber,
          "email": email,
          "password": password,
          "address": address,
          "buildingNumber": buildingNumber,
          "floorNumber": floorNumber,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return RegisterResponse.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'فشل في إنشاء الحساب');
      }
    } catch (e) {
      throw Exception(
        e.toString().contains("SocketException")
            ? "فشل الاتصال بالخادم، تأكد من الاتصال بالإنترنت"
            : e.toString().replaceAll("Exception: ", ""),
      );
    }
  }
}
