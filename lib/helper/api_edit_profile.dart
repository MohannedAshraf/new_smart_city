import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl =
    "https://central-user-management.agreeabledune-30ad0cb8.uaenorth.azurecontainerapps.io";

class ApiUpdateProfile {
  static Future<bool> updateProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String address,
    required String buildingNumber,
    required String floorNumber,
    File? imageFile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final uri = Uri.parse("$baseUrl/api/Account/update-my-account");

    final request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['FullName'] = fullName;
    request.fields['Email'] = email;
    request.fields['PhoneNumber'] = phoneNumber;
    request.fields['Address'] = address;
    request.fields['BuildingNumber'] = buildingNumber;
    request.fields['FloorNumber'] = floorNumber;

    if (imageFile != null) {
      final image = await http.MultipartFile.fromPath('Image', imageFile.path);
      request.files.add(image);
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return response.statusCode == 200;
  }
}
