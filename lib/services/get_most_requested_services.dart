import 'package:city/helper/api.dart';
import 'package:city/models/most_requested_services.dart';

class MostRequestedServices {
  Future<List<MostRequested>> getMostRequestedServices() async {
    // ignore: missing_required_param
    List<dynamic> data = await Api().get(
        url:
            'https://government-services.runasp.net/api/Services/MostRequestedServices');
    List<MostRequested> requestsList = [];
    for (int i = 0; i < data.length; i++) {
      requestsList.add(
        MostRequested.fromJason(data[i]),
      );
    }
    return requestsList;
  }
}
