class ComplaintResponse {
  final bool isSuccess;
  final bool isFailure;

  ComplaintResponse({required this.isSuccess, required this.isFailure});

  factory ComplaintResponse.fromJson(Map<String, dynamic> json) {
    return ComplaintResponse(
      isSuccess: json['isSuccess'] ?? false,
      isFailure: json['isFailure'] ?? false,
    );
  }
}
