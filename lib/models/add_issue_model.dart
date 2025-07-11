class ComplaintResponse {
  final int? value; // دا الـ reportId
  final bool isSuccess;
  final bool isFailure;

  ComplaintResponse({
    required this.value,
    required this.isSuccess,
    required this.isFailure,
  });

  factory ComplaintResponse.fromJson(Map<String, dynamic> json) {
    return ComplaintResponse(
      value: json['value'],
      isSuccess: json['isSuccess'] ?? false,
      isFailure: json['isFailure'] ?? false,
    );
  }
}
