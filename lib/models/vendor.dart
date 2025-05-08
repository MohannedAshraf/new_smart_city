// ignore: unused_element
String _baseUrl = 'https://service-provider.runasp.net';

class Vendor {
  final String name;
  final String businessName;
  final String type;
  final String? image;
  Vendor({
    required this.name,
    required this.businessName,
    required this.type,
    this.image,
  });
  factory Vendor.fromJason(jsonData) {
    return Vendor(
      name: jsonData['fullName'],
      businessName: jsonData['businessName'],
      type: jsonData['businessType'],
      image: jsonData['profilePictureUrl'],
    );
  }
}
