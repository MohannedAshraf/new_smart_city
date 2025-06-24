class ServiceDetails {
  final int id;
  final String serviceName;
  final String? fee;
  final String? time;
  final String? email;
  final String? category;
  final String? description;
  final List<RequiredFiles>? requirements;

  ServiceDetails({
    required this.id,
    required this.serviceName,
    this.fee,
    this.time,
    this.email,
    this.category,
    this.description,
    this.requirements,
  });

  factory ServiceDetails.fromJason(jsonData) {
    return ServiceDetails(
      id: jsonData['id'],
      serviceName: jsonData['serviceName'],
      fee: jsonData['fee'].toString(),
      time: jsonData['processingTime'],
      email: jsonData['contactInfo'],
      category: jsonData['category'],
      description: jsonData['serviceDescription'],
      requirements: List<RequiredFiles>.from(
        jsonData['requiredFiles'].map((x) => RequiredFiles.fromJason(x)),
      ),
    );
  }
}

class RequiredFiles {
  final int id;
  final String fileName;
  final String contentType;
  final String fileExtension;

  RequiredFiles({
    required this.id,
    required this.fileName,
    required this.contentType,
    required this.fileExtension,
  });

  factory RequiredFiles.fromJason(jsonData) {
    return RequiredFiles(
      id: jsonData['id'],
      fileName: jsonData['fileName'],
      contentType: jsonData['contentType'],
      fileExtension: jsonData['fileExtension'],
    );
  }
}
