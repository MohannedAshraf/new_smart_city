// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:citio/core/utils/variables.dart';

import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';

class ApplyGovernmentService {
  Future<dynamic> submit({
    required int serviceId,
    required List<Map<String, dynamic>> serviceData,
    required List<PlatformFile> files,
    required String paymentMethodID,
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
        final item = serviceData[i];
        final type = item['FieldType'];
        final value = item['FieldValue'];

        ///

        req.fields['ServiceData[$i].FieldId'] = item['FieldId'].toString();

        if (value == null) {
          if (type == 'number') {
            req.fields['ServiceData[$i].FieldValueInt'] = '0';
          } else if (type == 'float') {
            req.fields['ServiceData[$i].FieldValueFloat'] = '0.0';
          } else if (type == 'date') {
          } else {
            req.fields['ServiceData[$i].FieldValueString'] = '';
          }
        } else {
          if (type == 'number') {
            req.fields['ServiceData[$i].FieldValueInt'] = value.toString();
          } else if (type == 'float') {
            req.fields['ServiceData[$i].FieldValueFloat'] = value.toString();
          } else if (type == 'date') {
            req.fields['ServiceData[$i].FieldValueDate'] =
                (value as DateTime).toIso8601String();
          } else {
            req.fields['ServiceData[$i].FieldValueString'] = value.toString();
          }
        }
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
      print(response);

      if (response.statusCode == 200) {
        print('succes');
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
