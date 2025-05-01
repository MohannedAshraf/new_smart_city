String baseUrl = 'https://service-provider.runasp.net';

class MostRequestedProduct {
  final String name;
  final String image;
  final String discription;
  final String price;
  MostRequestedProduct({
    required this.name,
    required this.image,
    required this.discription,
    required this.price,
  });
  factory MostRequestedProduct.fromJason(jsonData) {
    return MostRequestedProduct(
      name: jsonData['nameEn'],
      image: baseUrl + jsonData['mainImageUrl'],
      discription: jsonData['description'],
      price: jsonData['price'].toString(),
    );
  }
}
