// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

class FCMApi {
  final Dio _dio = Dio();
  Future<void> sendTokenToBackend({
    required String token,
    required String userToken,
  }) async {
    try {
      final response = await _dio.post(
        'https://cms-central-ffb6acaub5afeecj.uaenorth-01.azurewebsites.net/api/User/update-fcm-token',
        data: {'fcmDeviceToken': token},
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );
      print('✅ FCM token sent to backend: ${response.statusCode}');
      print('Response data: ${response.data}');
    } on DioException catch (e) {
      if (e.response != null) {
        print('❌ Failed to send FCM token, status: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      } else {
        print('❌ Failed to send FCM token: ${e.message}');
      }
    } catch (e) {
      print('❌ Unexpected error: $e');
    }
  }
}
