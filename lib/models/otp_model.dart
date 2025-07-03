class VerifyOtpResponse {
  final String id;
  final String userName;
  final String email;
  final String token;
  final String refreshToken;

  VerifyOtpResponse({
    required this.id,
    required this.userName,
    required this.email,
    required this.token,
    required this.refreshToken,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    final value = json['value'];
    return VerifyOtpResponse(
      id: value['id'],
      userName: value['userName'],
      email: value['email'],
      token: value['token'],
      refreshToken: value['refreshToken'],
    );
  }
}
