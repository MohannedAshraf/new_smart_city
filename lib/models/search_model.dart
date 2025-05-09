class SearchResultModel {
  final String type;
  final String id;
  final String? nameEn;
  final String? nameAr;
  final String? fullName;
  final String? businessName;
  final String? businessType;
  final String? categoryNameEn;
  final String? categoryNameAr;
  final String? imageUrl;

  SearchResultModel({
    required this.type,
    required this.id,
    this.nameEn,
    this.nameAr,
    this.fullName,
    this.businessName,
    this.businessType,
    this.categoryNameEn,
    this.categoryNameAr,
    this.imageUrl,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      type: json['type'],
      id: json['id'],
      nameEn: json['nameEn'],
      nameAr: json['nameAr'],
      fullName: json['fullName'],
      businessName: json['businessName'],
      businessType: json['businessType'],
      categoryNameEn: json['categoryNameEn'],
      categoryNameAr: json['categoryNameAr'],
      imageUrl: json['imageUrl'],
    );
  }
}
