class ProductUnderSubModel {
  final int id;
  final String nameAr;
  final String nameEn;
  final String imageUrl;
  final String description;
  final String vendorFullName;
  final String vendorBusinessName;
  final double price;
  final double rating;

  ProductUnderSubModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.imageUrl,
    required this.description,
    required this.vendorFullName,
    required this.vendorBusinessName,
    required this.price,
    required this.rating,
  });

  factory ProductUnderSubModel.fromJson(Map<String, dynamic> json) {
    return ProductUnderSubModel(
      id: json['id'],
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      imageUrl: json['mainImageUrl'] ?? '',
      description: json['description'] ?? '',
      vendorFullName: json['vendorFullName'] ?? '',
      vendorBusinessName: json['vendorBusinessName'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }
}
