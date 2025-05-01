class MostRequested {
  final String serviceName;
  final String fee;
  final String time;

  MostRequested({
    required this.serviceName,
    required this.fee,
    required this.time,
  });

  factory MostRequested.fromJason(jsonData) {
    return MostRequested(
      serviceName: jsonData['serviceName'],
      fee: jsonData['fee'].toString(),
      time: jsonData['processingTime'],
    );
  }
}
