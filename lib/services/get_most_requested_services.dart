import 'package:citio/helper/api.dart';
import 'package:citio/models/most_requested_services.dart';

import 'package:citio/models/available_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MostRequestedServices {
  Future<List<MostRequested>> getMostRequestedServices() async {
    // ignore: missing_required_param
    List<dynamic> data = await Api().get(
      url:
          'https://government-services.runasp.net/api/Dashboard/MostRequestedServices',
    );
    List<MostRequested> requestsList = [];
    for (int i = 0; i < data.length; i++) {
      requestsList.add(MostRequested.fromJason(data[i]));
    }
    return requestsList;
  }

  Future<List<AvailableServices>> getAllServices() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    // ignore: missing_required_param
    List<dynamic> data = await Api().get(
      url: 'https://government-services.runasp.net/api/Services/Available',
      // token: token
    );
    List<AvailableServices> requestsList = [];
    for (int i = 0; i < data.length; i++) {
      requestsList.add(AvailableServices.fromJason(data[i]));
    }
    return requestsList;
  }
}
