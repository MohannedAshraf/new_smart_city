// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';

import 'package:citio/models/gov_service_details.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:citio/core/utils/variables.dart';

import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';

class ApplyGovernmentService {
  Future<dynamic> submit({
    required int serviceId,
    required List<RequiredFields> serviceData,
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
      req.fields['PaymentMethodId'] = paymentMethodID.toString();
      for (int i = 0; i < serviceData.length; i++) {
        final item = serviceData[i];
        final type = item.htmlType;
        final value = item;

        ///

        req.fields['ServiceData[$i].FieldId'] = item.id.toString();

        if (item.fieldValueString == null &&
            item.fieldValueInt == null &&
            item.fieldValueFloat == null &&
            item.fieldValueDate == null) {
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
            req.fields['ServiceData[$i].FieldValueInt'] =
                value.fieldValueInt.toString();
          } else if (type == 'float') {
            req.fields['ServiceData[$i].FieldValueFloat'] =
                value.fieldValueFloat.toString();
          } else if (type == 'date') {
            req.fields['ServiceData[$i].FieldValueDate'] =
                (value.fieldValueDate as DateTime).toIso8601String();
          } else {
            req.fields['ServiceData[$i].FieldValueString'] =
                value.fieldValueString.toString();
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
      // print(response);
      // print(req.fields);
      // print('successssssssssssssssssssssssssssssss walllllaaaaaaaaaaa');

      if (response.statusCode == 200) {
        // print('successssssssssssssssssssssssssssssss');
        // print(req.fields);
        // print(req.files);
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
