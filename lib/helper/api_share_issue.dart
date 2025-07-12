import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:citio/core/utils/variables.dart';

class ShareIssueApi {
  Future<void> share(int reportId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final dio = Dio();

    try {
      final response = await dio.post(
        '${Urls.issueBaseUrl}/api/MReport/social-media/share',
        data: {"reportId": reportId},
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
      print('✅ Shared successfully: ${response.data}');
    } catch (e) {
      print('❌ Failed to share issue: $e');
    }
  }
}
