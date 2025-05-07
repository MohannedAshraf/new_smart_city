String _baseUrl = 'https://service-provider.runasp.net';

class MostRecentProduct {
  final String name;
  final String image;
  MostRecentProduct({required this.name, required this.image});
  factory MostRecentProduct.fromJason(jsonData) {
    return MostRecentProduct(
      name: jsonData['description'],
      image: _baseUrl + jsonData['imageUrl'],
    );
  }
}
