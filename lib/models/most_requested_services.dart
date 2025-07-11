class MostRequested {
  final int id;
  final String serviceName;
  final String fee;
  final String time;
  final List<String> papers;
  final String category;

  MostRequested({
    required this.id,
    required this.serviceName,
    required this.fee,
    required this.time,
    required this.papers,
    required this.category,
  });

  factory MostRequested.fromJason(jsonData) {
    return MostRequested(
      id: jsonData['id'],
      serviceName: jsonData['serviceName'],
      fee: jsonData['fee'].toString(),
      time: jsonData['processingTime'],
      papers: (jsonData['requiredFiles'] as List?)?.cast<String>() ?? [],
      category: jsonData['category'],
    );
  }
}
