import 'package:citio/helper/api.dart';
import 'package:citio/models/request.dart';

class RequestsByStatus {
  Future<List<Request>> getRequestsByStatus({required String status}) async {
    List<dynamic> data = await Api().get(
      url:
          'https://government-services.runasp.net/api/requests?requestStatus=$status',
      token:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkZDYxNmIxYS1jMmU5LTQyYmEtOTJhOS0xNTlmZTlhOWY0OWYiLCJlbWFpbCI6ImZhdGhpQHRlc3QuY29tIiwiZ2l2ZW5fbmFtZSI6ImFobWVkIiwiZmFtaWx5X25hbWUiOiJmYXRoaSIsImp0aSI6IjY4MDhhZjc1LTU0YzktNDhhYS1iNWFlLTVmYmQ0OWQxMjYwNCIsImV4cCI6MTc0MTQ5NzcwMiwiaXNzIjoiR292ZXJubWVudEFwcCIsImF1ZCI6IkdvdmVybm1lbnRBcHAgdXNlcnMgYW5kIGFkbWlucyJ9.ULrT54Fi0X2Qf-AS35rOEkwXM3zWA24euZ5Ir__9xds',
    );
    List<Request> requestsList = [];
    for (int i = 0; i < data.length; i++) {
      requestsList.add(Request.fromJason(data[i]));
    }
    return requestsList;
  }
}
