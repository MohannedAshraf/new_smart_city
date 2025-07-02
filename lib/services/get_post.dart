import 'package:citio/core/utils/variables.dart';
import 'package:citio/helper/api.dart';
import 'package:citio/models/socialmedia_post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetPost {
  Future<SocialmediaPost> getTenPosts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    print('Token used in getTenPosts: $token'); // طباعة التوكن

    // استدعاء API
    dynamic data = await Api().get(
      url: '${Urls.socialmediaBaseUrl}/api/posts/?limit=10',
      token: token,
    );

    // طباعة الاستجابة الخام بصيغة JSON
    print('########################Raw JSON response from API: $data');

    // تحويل JSON إلى نموذج Dart
    SocialmediaPost posts = SocialmediaPost.fromJason(data);
    return posts;
  }
}
