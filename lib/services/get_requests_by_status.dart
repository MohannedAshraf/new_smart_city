import 'package:city/helper/api.dart';
import 'package:city/models/request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestsByStatus {
  Future<List<Request>> getRequestsByStatus({required String status}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    List<dynamic> data = await Api().get(
      url:
          'https://government-services.runasp.net/api/requests?requestStatus=$status',
      token: token,
    );
    List<Request> requestsList = [];
    for (int i = 0; i < data.length; i++) {
      requestsList.add(Request.fromJason(data[i]));
    }
    return requestsList;
  }
}
