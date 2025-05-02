String baseUrl = 'https://service-provider.runasp.net';

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
  final String profileImage;
  final String coverImage;
  final String email;
  Items({
    required this.name,
    required this.businessName,
    required this.type,
    required this.profileImage,
    required this.coverImage,
    required this.email,
  });
  factory Items.fromJason(jsonData) {
    return Items(
      name: jsonData['fullName'],
      businessName: jsonData['businessName'],
      type: jsonData['businessType'],
      profileImage: baseUrl + jsonData['profilePictureUrl'],
      coverImage: baseUrl + jsonData['coverImageUrl'],
      email: jsonData['email'],
    );
  }
}
