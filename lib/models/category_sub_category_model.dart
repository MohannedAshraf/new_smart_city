class CategoryModel {
  final int id;
  final String nameEn;
  final String nameAr;
  final String imageUrl;

  CategoryModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      nameEn: json['nameEn'],
      nameAr: json['nameAr'],
      imageUrl: json['imageUrl'],
    );
  }
}

class SubCategoryModel {
  final int id;
  final String nameEn;
  final String nameAr;
  final String imageUrl;

  SubCategoryModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.imageUrl,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'],
      nameEn: json['nameEn'],
      nameAr: json['nameAr'],
      imageUrl: json['imageUrl'],
    );
  }
}
