class ProductReview {
  final int id;
  final String productNameEn;
  final String productNameAr;
  final String userFullName;
  final String userEmail;
  final String vendorFullName;
  final int rating;
  final String comment;
  final DateTime createdAt;

  ProductReview({
    required this.id,
    required this.productNameEn,
    required this.productNameAr,
    required this.userFullName,
    required this.userEmail,
    required this.vendorFullName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['id'],
      productNameEn: json['productNameEn'],
      productNameAr: json['productNameAr'],
      userFullName: json['userFullName'],
      userEmail: json['userEmail'],
      vendorFullName: json['vendorFullName'],
      rating: json['rating'] as int,
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
