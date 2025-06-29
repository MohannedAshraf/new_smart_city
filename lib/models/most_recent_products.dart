class MostRecentProduct {
  final String name;
  final String? image;
  final ProductPanners product;

  MostRecentProduct({required this.name, this.image, required this.product});
  factory MostRecentProduct.fromJason(jsonData) {
    return MostRecentProduct(
      name: jsonData['description'],
      image: jsonData['imageUrl'],
      product: ProductPanners.fromJason(jsonData['product']),
    );
  }
}

class VendorBanners {}

class ProductPanners {
  final int id;

  ProductPanners({required this.id});
  factory ProductPanners.fromJason(jsonData) {
    return ProductPanners(id: jsonData['id']);
  }
}
