import 'package:citio/core/utils/variables.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class UpdateAttachedFiles {
  Future<void> updateAttachedFiles(
    int requestId,
    List<PlatformFile> files,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    var uri = Uri.parse(
      '${Urls.governmentbaseUrl}/api/Files/Attached/Request/$requestId',
    );

    var request = http.MultipartRequest('PUT', uri);

    // إضافة التوكن لو مطلوب
    request.headers.addAll({'Authorization': token});

    // إضافة كل ملف في الـ body
    for (var file in files) {
      if (file.path != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'Files', // نفس اسم المفتاح في Postman
            file.path!,
            filename: file.name,
          ),
        );
      }
    }

    // إرسال الطلب
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Files updated successfully');
    } else {
      print('Error: ${response.statusCode}');
      final body = await response.stream.bytesToString();
      print('Response body: $body');
    }
  }
}
