class LoginResponse {
  final String? id;
  final String? userName;
  final String? email;
  final String? token;
  final String? refreshToken;
  final bool? isSuccess;
  final bool? isFailure;

  LoginResponse({
    this.id,
    this.userName,
    this.email,
    this.token,
    this.refreshToken,
    this.isSuccess,
    this.isFailure,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final value = json['value'];
    return LoginResponse(
      id: value['id'],
      userName: value['userName'],
      email: value['email'],
      token: value['token'],
      refreshToken: value['refreshToken'],
      isSuccess: json['isSuccess'],
      isFailure: json['isFailure'],
    );
  }
}
