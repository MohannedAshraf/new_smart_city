// ignore_for_file: unused_element

import 'package:intl/intl.dart';

String _baseUrl = 'https://cms-reporting.runasp.net/';

class Issue {
  final List<Values> values;

  const Issue({required this.values});
  factory Issue.fromJason(jsonData) {
    return Issue(
      values: List<Values>.from(
        jsonData['value'].map((x) => Values.fromJason(x)),
      ),
    );
  }
}

class Values {
  final int id;
  final String title;
  final String date;
  final String status;
  final String? address;
  final String? image;
  final String? description;

  const Values({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
    this.address,
    this.image,
    this.description,
  });
  factory Values.fromJason(jsonData) {
    return Values(
      id: jsonData['id'] ?? '',
      title: jsonData['issueCategoryAR'],
      date: DateFormat.yMMMMd(
        'en_US',
      ).add_jm().format(DateTime.parse(jsonData['dateIssued'])),
      status: jsonData['reportStatus'],
      image: jsonData['imageUrl'],
      address: jsonData['address'],
      description: jsonData['description'],
    );
  }
}
