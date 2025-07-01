// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:citio/core/utils/variables.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplyGovernmentService {
  Future<dynamic> submit({
    required int serviceId,
    required List<Map<String, dynamic>> serviceData,
    required List<PlatformFile> files,
  }) async {
    try {
      final uri = Uri.parse('${Urls.governmentbaseUrl}/api/Requests/Submit');
      final req = http.MultipartRequest('POST', uri);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('لم يتم العثور على التوكن!');
      }
      req.headers['Authorization'] = 'Bearer $token';

      req.fields['ServiceId'] = serviceId.toString();

      for (int i = 0; i < serviceData.length; i++) {
        req.fields['ServiceData[$i].FieldId'] =
            serviceData[i]['FieldId'].toString();
        req.fields['ServiceData[$i].FieldValueString'] =
            serviceData[i]['FieldValueString'];
      }

      for (var file in files) {
        final multipartFile = await http.MultipartFile.fromPath(
          'files',
          file.path!,
          filename: file.name,
          contentType: MediaType('application', 'octet-stream'),
        );
        req.files.add(multipartFile);
      }

      final streamedResponse = await req.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }
}
