class EmergencyRequestModel {
  final String emergencyServiceId;
  final String latitude;
  final String longitude;
  final String address;

  EmergencyRequestModel({
    required this.emergencyServiceId,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'emergencyServiceId': emergencyServiceId,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}
