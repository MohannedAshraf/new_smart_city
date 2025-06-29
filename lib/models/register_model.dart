class RegisterResponse {
  final bool isSuccess;
  final bool isFailure;

  RegisterResponse({required this.isSuccess, required this.isFailure});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      isSuccess: json['isSuccess'] ?? false,
      isFailure: json['isFailure'] ?? true,
    );
  }
}
