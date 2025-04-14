class Request {
  final int requestID;
  final String serviceName;
  final String requestDate;
  final String requestStatus;
  final String responseStatus;
  final String responseText;

  Request(
      {required this.requestID,
      required this.serviceName,
      required this.requestDate,
      required this.requestStatus,
      required this.responseStatus,
      required this.responseText});

  factory Request.fromJason(jsonData) {
    return Request(
        requestID: jsonData['requestID'],
        serviceName: jsonData['serviceName'],
        requestDate: jsonData['requestDate'],
        requestStatus: jsonData['requestStatus'],
        responseStatus: jsonData['responseStatus'],
        responseText: jsonData['responseText']);
  }
}
