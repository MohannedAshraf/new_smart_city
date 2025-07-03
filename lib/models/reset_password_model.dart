class OtpResponse {
  final bool isSuccess;
  final bool isFailure;

  OtpResponse({required this.isSuccess, required this.isFailure});

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      isSuccess: json['isSuccess'] ?? false,
      isFailure: json['isFailure'] ?? false,
    );
  }
}
