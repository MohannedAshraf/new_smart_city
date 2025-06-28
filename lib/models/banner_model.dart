class BannerModel {
  final String discountCode;
  final String description;
  final String imageUrl;
  final int discountPercentage;
  final int productId;

  BannerModel({
    required this.discountCode,
    required this.description,
    required this.imageUrl,
    required this.discountPercentage,
    required this.productId,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      discountCode: json['discountCode'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      discountPercentage: json['discountPercentage'],
      productId: json['product']['id'],
    );
  }
}
