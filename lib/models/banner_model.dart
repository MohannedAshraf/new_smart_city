class BannerModel {
  final int id;
  final String description;
  final String imageUrl;
  final int discountPercentage;
  final int productId;

  BannerModel({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.discountPercentage,
    required this.productId,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      discountPercentage: (json['discountPercentage'] as num).toInt(),
      productId: json['product']['id'],
    );
  }
}
