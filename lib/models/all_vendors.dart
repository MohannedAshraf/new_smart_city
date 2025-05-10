class AllVendor {
  List<Items> items;

  AllVendor({required this.items});
  factory AllVendor.fromJason(Map<String, dynamic> jasonData) {
    return AllVendor(
      items: List<Items>.from(
        jasonData['items'].map((x) => Items.fromJason(x)),
      ),
    );
  }
}

class Items {
  final String name;
  final String businessName;
  final String type;
  final String? profileImage;
  final String? coverImage;

  final double rating;
  final String id;
  Items({
    required this.name,
    required this.businessName,
    required this.type,
    this.profileImage,
    this.coverImage,

    required this.rating,
    required this.id,
  });
  factory Items.fromJason(jsonData) {
    return Items(
      name: jsonData['fullName'],
      businessName: jsonData['businessName'],
      type: jsonData['businessType'],
      profileImage: jsonData['profilePictureUrl'],
      coverImage: jsonData['coverImageUrl'],

      rating:
          jsonData['rating'] != null
              ? double.tryParse(jsonData['rating'].toString()) ?? 0.0
              : 0.0,
      id: jsonData['id'],
    );
  }
}
