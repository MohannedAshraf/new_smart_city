class ProductDetails {
  final int id;
  final String nameEn;
  final String nameAr;
  final String mainImageUrl;
  final String description;
  final String vendorFullName;
  final String vendorBusinessName;
  final double price;
  final int rating;
  final double discountPercentage;

  ProductDetails({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.mainImageUrl,
    required this.description,
    required this.vendorFullName,
    required this.vendorBusinessName,
    required this.price,
    required this.rating,
    required this.discountPercentage,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      id: json['id'],
      nameEn: json['nameEn'],
      nameAr: json['nameAr'],
      mainImageUrl: json['mainImageUrl'],
      description: json['description'],
      vendorFullName: json['vendorFullName'],
      vendorBusinessName: json['vendorBusinessName'],
      price: (json['price'] as num).toDouble(),
      rating:
          json['rating'] is int
              ? json['rating']
              : (json['rating'] as num).round(),
      discountPercentage: (json['discountPercentag'] ?? 0).toDouble(),
    );
  }
}
