// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class Request {
  final int requestId;
  final int serviceId;
  final String serviceName;
  final String requestDate;
  final String requestStatus;
  // final String responseStatus;
  final String responseText;

  Request({
    required this.requestId,
    required this.serviceId,
    required this.serviceName,
    required this.requestDate,
    required this.requestStatus,
    // required this.responseStatus,
    required this.responseText,
  });

  factory Request.fromJason(jsonData) {
    return Request(
      requestId: jsonData['requestId'],
      serviceId: jsonData['serviceId'],
      serviceName: jsonData['serviceName'],
      requestDate:
          jsonData['requestDate'] != null &&
                  jsonData['requestDate'].toString().isNotEmpty
              ? getTimeAgo(jsonData['requestDate'])
              : 'التاريخ غير متوفر',
      requestStatus: jsonData['requestStatus'],
      //responseStatus: jsonData['responseStatus'],
      responseText: jsonData['responseText'],
    );
  }
}

String getTimeAgo(String dateString) {
  DateTime localDate = DateTime.parse(dateString + 'Z').toLocal();
  final date = DateTime.parse(dateString).toLocal();
  final now = DateTime.now();
  final diff = now.difference(localDate);

  if (diff.inSeconds < 60) {
    return 'منذ ${diff.inSeconds} ثانية';
  } else if (diff.inMinutes < 60) {
    return 'منذ ${diff.inMinutes} دقيقة';
  } else if (diff.inHours < 24) {
    return 'منذ ${diff.inHours} ساعة';
  } else if (diff.inDays < 7) {
    return 'منذ ${diff.inDays} يوم';
  } else {
    return DateFormat.yMMMMd('ar_EG').format(date);
  }
}
