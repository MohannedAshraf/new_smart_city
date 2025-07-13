// lib/models/discount_model.dart

class DiscountResponse {
  final double value;

  DiscountResponse({required this.value});

  factory DiscountResponse.fromJson(dynamic json) {
    return DiscountResponse(value: (json is num) ? json.toDouble() : 0.0);
  }
}
