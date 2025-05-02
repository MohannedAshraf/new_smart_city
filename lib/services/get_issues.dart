import 'package:city/helper/api.dart';
import 'package:city/models/issue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetIssues {
  Future<Issue> getIssues() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    dynamic data = await Api().get(
      url: 'https://cms-reporting.runasp.net/api/MReport/my-reports',
      token: token,
    );
    Issue issues = Issue.fromJason(data);

    return issues;
  }
}
