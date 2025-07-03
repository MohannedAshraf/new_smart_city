// ignore_for_file: avoid_print

import 'package:citio/core/utils/variables.dart';
import 'package:citio/helper/api.dart';
import 'package:citio/models/socialmedia_post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetPost {
  Future<SocialmediaPost> getPosts({int page = 1, int limit = 10}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final String? userId = prefs.getString('userId'); // ✅ إضافة userId

    if (token == null || userId == null) {
      throw Exception('لم يتم العثور على التوكن أو معرف المستخدم!');
    }

    print('Token used in getPosts: $token');
    print('User ID: $userId');

    dynamic data = await Api().get(
      url: '${Urls.socialmediaBaseUrl}/api/posts/?limit=$limit&page=$page',
      token: token,
    );

    print('########################Raw JSON response from API: $data');

    // ✅ تعديل هنا لتمرير userId
    SocialmediaPost posts = SocialmediaPost.fromJson(data, userId);
    return posts;
  }
}
