import 'package:intl/intl.dart';

class Request {
  final int requestId;
  final int serviceId;
  final String serviceName;
  final String requestDate;
  final String requestStatus;
  // final String responseStatus;
  final String responseText;

  Request({
    required this.requestId,
    required this.serviceId,
    required this.serviceName,
    required this.requestDate,
    required this.requestStatus,
    // required this.responseStatus,
    required this.responseText,
  });

  factory Request.fromJason(jsonData) {
    return Request(
      requestId: jsonData['requestId'],
      serviceId: jsonData['serviceId'],
      serviceName: jsonData['serviceName'],
      requestDate: DateFormat.yMMMMd(
        'en_US',
      ).add_jm().format(DateTime.parse(jsonData['requestDate'])),
      requestStatus: jsonData['requestStatus'],
      //responseStatus: jsonData['responseStatus'],
      responseText: jsonData['responseText'],
    );
  }
}
