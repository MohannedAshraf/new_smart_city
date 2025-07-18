// ignore_for_file: avoid_print

import 'package:citio/core/utils/variables.dart';
import 'package:citio/helper/api.dart';
import 'package:citio/models/request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestsByStatus {
  Future<List<Request>> getRequestsByStatus({required String status}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    List<dynamic> data = await Api().get(
      url: '${Urls.governmentbaseUrl}/api/Requests?Status=$status',
      token: token,
    );
    List<Request> requestsList = [];
    for (int i = 0; i < data.length; i++) {
      requestsList.add(Request.fromJason(data[i]));
    }
    return requestsList;
  }

  Future<List<Request>> getAllRequests() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    List<dynamic> data = await Api().get(
      url: '${Urls.governmentbaseUrl}/api/Requests/Member',
      token: token,
    );
    List<Request> requestsList = [];
    for (int i = 0; i < data.length; i++) {
      requestsList.add(Request.fromJason(data[i]));
    }
    return requestsList;

    ///commitytt
  }
}
