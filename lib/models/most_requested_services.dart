class MostRequested {
  final String serviceName;

  MostRequested({
    required this.serviceName,
  });

  factory MostRequested.fromJason(jsonData) {
    return MostRequested(
      serviceName: jsonData['serviceName'],
    );
  }
}
