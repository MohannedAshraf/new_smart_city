class FeedbackResponse {
  final String message;
  final int? rateValue;

  FeedbackResponse({required this.message, this.rateValue});

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      message: json['message'] ?? '',
      rateValue: json['rateValue'],
    );
  }

  bool get isSuccess => message.toLowerCase().contains('success');
}
