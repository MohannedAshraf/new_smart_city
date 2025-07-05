import 'dart:convert';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/models/delete_acc_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiDeleteAccountHelper {
  static Future<DeleteResponseModel> deleteMyAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    final url = Uri.parse("${Urls.cmsBaseUrl}/api/Account/delete-my-account");

    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return DeleteResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("فشل حذف الحساب: ${response.body}");
    }
  }
}
