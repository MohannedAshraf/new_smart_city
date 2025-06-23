import 'package:flutter/foundation.dart';

class AllServicesCategories {
  final String name;

  AllServicesCategories({required this.name});

  factory AllServicesCategories.fromJason(jasonData) {
    return AllServicesCategories(name: jasonData['category']);
  }
}
