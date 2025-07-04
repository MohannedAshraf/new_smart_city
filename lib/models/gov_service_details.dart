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

class RequiredFields {
  final int id;
  final String fileName;
  final String description;
  final String htmlType;
  final int fieldDataId;
  String? fieldValueString;
  int? fieldValueInt;
  double? fieldValueFloat;
  DateTime? fieldValueDate;
  final String valueType;

  RequiredFields({
    required this.id,
    required this.fileName,
    required this.description,
    required this.htmlType,
    required this.fieldDataId,
    this.fieldValueString,
    this.fieldValueInt,
    this.fieldValueFloat,
    this.fieldValueDate,
    required this.valueType,
  });

  factory RequiredFields.fromJason(Map<String, dynamic> json) {
    return RequiredFields(
      id: json['id'] ?? 0,
      fileName: json['filedName'] ?? '',
      description: json['description'] ?? '',
      htmlType: json['htmlType'] ?? '',
      fieldDataId: json['fieldDataId'] ?? 0,
      fieldValueString: json['fieldValueString'],
      fieldValueInt:
          json['fieldValueInt'] != null
              ? int.tryParse(json['fieldValueInt'].toString())
              : null,
      fieldValueFloat:
          json['fieldValueFloat'] != null
              ? double.tryParse(json['fieldValueFloat'].toString())
              : null,
      fieldValueDate:
          json['fieldValueDate'] != null
              ? DateTime.tryParse(json['fieldValueDate'].toString())
              : null,
      valueType: json['valueType'] ?? '',
    );
  }
}
