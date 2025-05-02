import 'dart:math';

class EmergencyFakeData {
  static final List<String> addresses = [
    "Building 1, Smart Village",
    "Building 2, Smart Village",
    "Tower A, Nasr City",
    "Mall B, New Cairo",
    "Office 5, Zamalek",
    "Flat 22, Dokki",
    "Street 9, Maadi",
    "Villa 12, 6 October",
    "Compound X, Sheikh Zayed",
    "Office 101, Downtown",
  ];

  static final List<String> latitudes = List.generate(
    30,
    (index) => (30.00 + Random().nextDouble()).toStringAsFixed(5),
  );

  static final List<String> longitudes = List.generate(
    30,
    (index) => (31.00 + Random().nextDouble()).toStringAsFixed(5),
  );

  static final List<String> issueCategories = [
    'electrical_issues',
    'plumbing_issues',
    'waste_management',
    'road_and_traffic',
    'public_safety',
    'parks_and_recreation',
    'public_transportation',
    'environmental_concerns',
    'infrastructure',
    'community_services',
    'health_and_safety',
    'public_events',
    'technology_connectivity',
    'emergency',
    'miscellaneous',
  ];

  static String getRandomAddress() {
    return addresses[Random().nextInt(addresses.length)];
  }

  static String getRandomLatitude() {
    return latitudes[Random().nextInt(latitudes.length)];
  }

  static String getRandomLongitude() {
    return longitudes[Random().nextInt(longitudes.length)];
  }

  static String getRandomIssueCategoryKey() {
    return issueCategories[Random().nextInt(issueCategories.length)];
  }
}
