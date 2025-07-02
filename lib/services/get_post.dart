import 'package:citio/core/utils/variables.dart';
import 'package:citio/helper/api.dart';
import 'package:citio/models/socialmedia_post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetPost {
  Future<SocialmediaPost> getPosts({int page = 1, int limit = 10}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    print('Token used in getPosts: $token');

    dynamic data = await Api().get(
      url: '${Urls.socialmediaBaseUrl}/api/posts/?limit=$limit&page=$page',
      token: token,
    );

    print('########################Raw JSON response from API: $data');

    SocialmediaPost posts = SocialmediaPost.fromJason(data);
    return posts;
  }
}
