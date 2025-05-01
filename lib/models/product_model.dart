class Product {
  final int id;
  final String nameEn;
  final String description;
  final String mainImageUrl;
  final double price;
  final int requestCount;

  Product({
    required this.id,
    required this.nameEn,
    required this.description,
    required this.mainImageUrl,
    required this.price,
    required this.requestCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      nameEn: json['nameEn'],
      description: json['description'],
      mainImageUrl: json['mainImageUrl'],
      price: (json['price'] as num).toDouble(),
      requestCount: json['requestCount'],
    );
  }
}
