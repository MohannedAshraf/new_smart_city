// ignore: unused_element

class Vendor {
  final String name;
  final String businessName;
  final String type;
  final String? image;
  final String? coverImage;
  final String id;
  final double rating;
  Vendor({
    required this.name,
    required this.businessName,
    required this.type,
    this.image,
    this.coverImage,
    required this.id,
    required this.rating,
  });
  factory Vendor.fromJason(jsonData) {
    return Vendor(
      name: jsonData['fullName'],
      businessName: jsonData['businessName'],
      type: jsonData['businessType'],
      image: jsonData['profilePictureUrl'],
      coverImage: jsonData['coverImageUrl'],
      id: jsonData['id'],
      rating:
          jsonData['rating'] != null
              ? double.tryParse(jsonData['rating'].toString()) ?? 0.0
              : 0.0,
    );
  }
}
