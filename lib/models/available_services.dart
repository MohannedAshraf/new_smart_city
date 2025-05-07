class AvailableServices {
  final String serviceName;
  final String fee;
  final String time;
  final String email;

  AvailableServices({
    required this.serviceName,
    required this.fee,
    required this.time,
    required this.email,
  });

  factory AvailableServices.fromJason(jsonData) {
    return AvailableServices(
      serviceName: jsonData['serviceName'],
      fee: jsonData['fee'].toString(),
      time: jsonData['processingTime'],
      email: jsonData['contactInfo'],
    );
  }
}
