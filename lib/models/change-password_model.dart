class ChangePasswordResponse {
  final bool isSuccess;
  final bool isFailure;

  ChangePasswordResponse({required this.isSuccess, required this.isFailure});

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      isSuccess: json['isSuccess'] ?? false,
      isFailure: json['isFailure'] ?? false,
    );
  }
}
