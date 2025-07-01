import 'package:file_picker/file_picker.dart';

class SubmittedService {
  final int serviceId;
  final List<ServiceData> serviceData;
  final List<PlatformFile> files;

  SubmittedService({
    required this.serviceId,
    required this.serviceData,
    required this.files,
  });

  factory SubmittedService.fromJson(Map<String, dynamic> json) {
    return SubmittedService(
      serviceId: json['ServiceId'] as int,
      serviceData:
          (json['ServiceData'] as List<dynamic>)
              .map((e) => ServiceData.fromJson(e as Map<String, dynamic>))
              .toList(),
      files: [], // files are picked locally—not deserialized from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ServiceId': serviceId,
      'ServiceData': serviceData.map((d) => d.toJson()).toList(),
      // files can't be included directly as JSON—they need to be uploaded
    };
  }
}

class ServiceData {
  final int fieldId;
  final String? stringValue;
  final int? intValue;

  ServiceData({required this.fieldId, this.stringValue, this.intValue});

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      fieldId: json['FieldId'] as int,
      stringValue: json['FieldValueString'] as String?,
      intValue: json['FieldValueInt'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FieldId': fieldId,
      if (stringValue != null) 'FieldValueString': stringValue,
      if (intValue != null) 'FieldValueInt': intValue,
    };
  }
}
