class MostRequestedProduct {
  final String name;
  final String? image;
  final String discription;
  final String price;
  final int id;
  MostRequestedProduct({
    required this.name,
    this.image,
    required this.discription,
    required this.price,
    required this.id,
  });
  factory MostRequestedProduct.fromJason(jsonData) {
    return MostRequestedProduct(
      name: jsonData['nameEn'],
      image: jsonData['mainImageUrl'],
      discription: jsonData['description'],
      price: jsonData['price'].toString(),
      id: jsonData['id'],
    );
  }
}
