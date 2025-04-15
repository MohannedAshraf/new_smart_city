import 'package:city/helper/api.dart';
import 'package:city/models/request.dart';

class RequestsByStatus {
  Future<List<Request>> getRequestsByStatus({required String status}) async {
    List<dynamic> data = await Api().get(
      url:
          'https://government-services.runasp.net/api/requests?requestStatus=$status',
      token:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkZDYxNmIxYS1jMmU5LTQyYmEtOTJhOS0xNTlmZTlhOWY0OWYiLCJlbWFpbCI6ImZhdGhpQHRlc3QuY29tIiwiZ2l2ZW5fbmFtZSI6ImFobWVkIiwiZmFtaWx5X25hbWUiOiJmYXRoaSIsImp0aSI6Ijk3NTQ4YTc1LWQzMmItNDIzNC1iZWFlLTRmMTIwYjBhYTY2MCIsImV4cCI6MTc0NDY2NDEyMiwiaXNzIjoiR292ZXJubWVudEFwcCIsImF1ZCI6IkdvdmVybm1lbnRBcHAgdXNlcnMgYW5kIGFkbWlucyJ9.vZWmpaPZ0O-2qFFFm7ZbcKcVIM5kCaz7s0MzXFI-4zE',
    );
    List<Request> requestsList = [];
    for (int i = 0; i < data.length; i++) {
      requestsList.add(Request.fromJason(data[i]));
    }
    return requestsList;
  }
}
