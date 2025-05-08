import 'package:citio/helper/api.dart';
import 'package:citio/models/report.dart';

class AddReport {
  Future<ReportIssue> addReport(
    String mobileUserId,
    String description,
    String issueCategoryKey,
    String? image,
    double latitude,
    double longitude,
    String address,
  ) async {
    // ignore: missing_required_param
    Map<String, dynamic> data = await Api().post(
      url: 'https://cms-reporting.runasp.net/api/MReport',
      body: {
        'mobileUserId': mobileUserId,
        'description': description,
        'issueCategoryKey': issueCategoryKey,
        'image': image,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
      },
    );
    return ReportIssue.fromJason(data);
  }
}
