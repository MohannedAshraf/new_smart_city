import 'package:intl/intl.dart';

class ReportIssue {
  final double latitude;
  final double longitude;
  final String description;
  final String category;
  final String address;
  final String? image;
  final String userId;

  ReportIssue({
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.category,
    required this.address,
    required this.userId,
    this.image,
  });

  factory ReportIssue.fromJason(jsonData) {
    return ReportIssue(
      description: jsonData['description'],
      category: jsonData['issueCategoryKey'],
      latitude: jsonData['latitude'],
      longitude: jsonData['longitude'],
      address: jsonData['Address'],
      image: jsonData['image'],
      userId: jsonData['mobileUserId'],
    );
  }
}
