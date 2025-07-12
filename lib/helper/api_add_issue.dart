import 'dart:io';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/models/add_issue_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComplaintApiService {
  final Dio dio = Dio();

  Future<ComplaintResponse> sendComplaint({
    required String description,
    required String issueCategoryKey,
    required String latitude,
    required String longitude,
    required String address,
    File? image,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');

    final formData = FormData.fromMap({
      "Description": description,
      "IssueCategoryKey": issueCategoryKey,
      "Latitude": latitude,
      "Longitude": longitude,
      "Address": address,
      if (image != null)
        "Image": await MultipartFile.fromFile(
          image.path,
          filename: "image.jpg",
        ),
    });

    final response = await dio.post(
      "${Urls.issueBaseUrl}/api/MReport",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "multipart/form-data",
        },
      ),
    );
    print("Response Data: ${response.data}");

    return ComplaintResponse.fromJson(response.data);
  }
}
