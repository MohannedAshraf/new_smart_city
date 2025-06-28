// lib/models/discount_model.dart

class DiscountResponse {
  final double value;
  final bool isSuccess;
  final bool isFailure;

  DiscountResponse({
    required this.value,
    required this.isSuccess,
    required this.isFailure,
  });

  factory DiscountResponse.fromJson(Map<String, dynamic> json) {
    return DiscountResponse(
      value: (json['value'] ?? 0).toDouble(),
      isSuccess: json['isSuccess'] ?? false,
      isFailure: json['isFailure'] ?? false,
    );
  }
}
