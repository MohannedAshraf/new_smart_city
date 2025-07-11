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

  factory ServiceDetails.fromJson(Map<String, dynamic> jsonData) {
    return ServiceDetails(
      id: jsonData['id'] ?? 0,
      serviceName: jsonData['serviceName']?.toString() ?? '',
      fee: jsonData['fee']?.toString(), // null-safe تحويل لـ String
      time: jsonData['processingTime']?.toString(),
      email: jsonData['contactInfo']?.toString(),
      category: jsonData['category']?.toString(),
      description: jsonData['serviceDescription']?.toString(),
      requirements:
          (jsonData['requiredFiles'] as List<dynamic>?)
              ?.map((x) => RequiredFiles.fromJson(x))
              .toList(),
    );
  }
}

class RequiredFiles {
  final int id;
  final String? fileName;
  final String? contentType;
  final String? fileExtension;

  RequiredFiles({
    required this.id,
    this.fileName,
    this.contentType,
    this.fileExtension,
  });

  factory RequiredFiles.fromJson(Map<String, dynamic> json) {
    return RequiredFiles(
      id: json['id'] ?? 0,
      fileName: json['attachedFileName']?.toString(),
      contentType: json['contentType']?.toString(),
      fileExtension: json['fileExtension']?.toString(),
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
  String? valueType;

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
