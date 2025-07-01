class VendorSubcategory {
  final String name;
  final int id;

  VendorSubcategory({required this.name, required this.id});

  factory VendorSubcategory.fromJason(jsonData) {
    return VendorSubcategory(name: jsonData['nameAr'], id: jsonData['id']);
  }
}

class VendorSubcategoryProducts {
  final String name;
  final double? price;
  final String? image;
  final String? description;
  final int id;

  VendorSubcategoryProducts({
    required this.name,
    this.price,
    this.image,
    this.description,
    required this.id,
  });

  factory VendorSubcategoryProducts.fromJason(jsonData) {
    return VendorSubcategoryProducts(
      name: jsonData['nameAr'],
      price:
          jsonData['price'] != null
              ? double.tryParse(jsonData['price'].toString()) ?? 0.0
              : 0.0,
      image: jsonData['mainImageUrl'],
      description: jsonData['description'],
      id: jsonData['id'],
    );
  }
}
