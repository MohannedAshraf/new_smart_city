class MostRequested {
  final String serviceName;
  final String fee;
  final String time;
  final List<String> papers;

  MostRequested({
    required this.serviceName,
    required this.fee,
    required this.time,
    required this.papers,
  });

  factory MostRequested.fromJason(jsonData) {
    return MostRequested(
      serviceName: jsonData['serviceName'],
      fee: jsonData['fee'].toString(),
      time: jsonData['processingTime'],
      papers: (jsonData['requiredFiles'] as List?)?.cast<String>() ?? [],
    );
  }
}
