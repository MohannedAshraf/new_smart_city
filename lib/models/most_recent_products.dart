class MostRecentProduct {
  final String name;
  final String? image;
  MostRecentProduct({required this.name, this.image});
  factory MostRecentProduct.fromJason(jsonData) {
    return MostRecentProduct(
      name: jsonData['description'],
      image: jsonData['imageUrl'],
    );
  }
}
