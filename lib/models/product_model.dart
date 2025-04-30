class ProductModel {
  final int id;
  final String name;
  final String description;
  final String mainImageUrl;
  final double price;
  final int requestCount;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.mainImageUrl,
    required this.price,
    required this.requestCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['nameEn'],
      description: json['description'],
      mainImageUrl: json['mainImageUrl'],
      price: json['price'].toDouble(),
      requestCount: json['requestCount'],
    );
  }
}
