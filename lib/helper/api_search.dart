import 'dart:convert';
import 'package:citio/models/search_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiSearch {
  static const String baseUrl =
      "https://service-provider.runasp.net/api/Search";

  static Future<List<SearchResultModel>> search(String term) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final url = Uri.parse("$baseUrl?term=$term");

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List jsonData = jsonDecode(response.body);
      return jsonData.map((e) => SearchResultModel.fromJson(e)).toList();
    } else {
      throw Exception('فشل في جلب نتائج البحث');
    }
  }
}
