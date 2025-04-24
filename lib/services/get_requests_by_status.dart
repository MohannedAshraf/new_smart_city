import 'package:city/helper/api.dart';
import 'package:city/models/request.dart';

class RequestsByStatus {
  Future<List<Request>> getRequestsByStatus({required String status}) async {
    List<dynamic> data = await Api().get(
      url:
          'https://government-services.runasp.net/api/requests?requestStatus=$status',
      token:
          'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFtaXJhbHNheWVkLndvcmtAZ21haWwuY29tIiwibmFtZWlkIjoiODNkN2UyYWEtMWFiYS00ZWEzLTgzODUtZDIxN2IxYTNhMDU4IiwidW5pcXVlX25hbWUiOiJhbWlyYWxzYXllZC53b3JrMzg3Mzg1MTc3NSIsInJvbGUiOiJNb2JpbGVVc2VyIiwibmJmIjoxNzQ1Mjg3NDYyLCJleHAiOjE3NDUyODgzNjIsImlhdCI6MTc0NTI4NzQ2MiwiaXNzIjoiQ2VudHJhbFVzZXJNYW5hZ2VtZW50U2VydmljZSIsImF1ZCI6IkNlbnRyYWxVc2VyTWFuYWdlbWVudFNlcnZpY2UifQ.exNWMTudxjUQBX9yETTirFF_v2q7lnUQ-PczjQboiOn2C6TZpCR6sUwtJlZpm0OP_EUA56zOWkWNcUR-Jns7TA',
    );
    List<Request> requestsList = [];
    for (int i = 0; i < data.length; i++) {
      requestsList.add(Request.fromJason(data[i]));
    }
    return requestsList;
  }
}
