import 'dart:convert';

import 'package:flutter/foundation.dart';

String baseUrl = 'https://service-provider.runasp.net';

class Vendor {
  final String name;
  final String businessName;
  final String type;
  final String image;
  Vendor({
    required this.name,
    required this.businessName,
    required this.type,
    required this.image,
  });
  factory Vendor.fromJason(jsonData) {
    return Vendor(
      name: jsonData['fullName'],
      businessName: jsonData['businessName'],
      type: jsonData['businessType'],
      image: baseUrl + jsonData['profilePictureUrl'],
    );
  }
}
