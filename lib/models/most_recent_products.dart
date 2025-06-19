class MostRecentProduct {
  final int id;
  final String name;
  final String? image;
  MostRecentProduct({required this.name, required this.id, this.image});
  factory MostRecentProduct.fromJason(jsonData) {
    return MostRecentProduct(
      id: jsonData['id'],
      name: jsonData['description'],
      image: jsonData['imageUrl'],
    );
  }
}
