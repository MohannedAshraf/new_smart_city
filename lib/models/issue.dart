import 'package:intl/intl.dart';

String _baseUrl = 'https://cms-reporting.runasp.net/';

class Issue {
  final List<Values> values;

  const Issue({required this.values});
  factory Issue.fromJason(jsonData) {
    return Issue(
      values: List<Values>.from(
        jsonData['items'].map((x) => Values.fromJason(x)),
      ),
    );
  }
}

class Values {
  final String title;
  final String date;
  final String status;
  final String? address;
  final String? image;

  const Values({
    required this.title,
    required this.date,
    required this.status,
    this.address,
    this.image,
  });
  factory Values.fromJason(jsonData) {
    return Values(
      title: jsonData['issueCategoryAR'],
      date: DateFormat.yMMMMd(
        'en_US',
      ).add_jm().format(DateTime.parse(jsonData['dateIssued'])),
      status: jsonData['reportStatus'],
      image: _baseUrl + jsonData['imageUrl'],
    );
  }
}
