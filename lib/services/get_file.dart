import 'dart:typed_data';

import 'package:citio/core/utils/variables.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class ServiceFile {
  Future<Uint8List?> getFile({required int id}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }
    String url = '${Urls.governmentbaseUrl}/api/Files/Attached/Request/$id';
    Map<String, String> headers = {};
    headers.addAll({'Authorization': 'Bearer $token'});
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('فشل تحميل الملف: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('خطأ: $e');
      return null;
    }
  }
}
