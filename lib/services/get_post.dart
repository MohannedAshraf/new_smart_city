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

    // ignore: avoid_print
    print('Token used in getTenPosts: $token'); // هنا الطباعة ✅

    dynamic data = await Api().get(
      url: '${Urls.socialmediaBaseUrl}/api/posts/?scope=user&limit=10',
      token: token,
    );

    SocialmediaPost posts = SocialmediaPost.fromJason(data);
    return posts;
  }
}
