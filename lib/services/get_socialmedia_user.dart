import 'package:citio/core/utils/variables.dart';
import 'package:citio/helper/api.dart';
import 'package:citio/models/socialmedia_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetSocialmediaUser {
  Future<SocialmediaUser> getSocialMediaUser({required String id}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    // ignore: avoid_print
    print('Token used in getSocialMediaUser: $token'); // هنا الطباعة ✅

    dynamic data = await Api().get(
      url: '${Urls.socialmediaBaseUrl}/api/users/$id',
      token: token,
    );

    SocialmediaUser user = SocialmediaUser.fromJason(data);
    return user;
  }
}
