class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String category;
  final DateTime createdAt;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    String rawDate = json['createdAt'] ?? '';
    if (rawDate.isNotEmpty && !rawDate.endsWith('Z')) {
      rawDate = rawDate + 'Z'; // إضافة Z لاعتبار الوقت UTC
    }
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      category: json['category'] ?? '',
      createdAt: DateTime.parse(rawDate).toLocal(),
    );
  }
}
