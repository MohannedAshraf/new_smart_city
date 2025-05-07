class CartItem {
  final int productId;
  final String nameAr;
  final String nameEn;
  final double price;
  final int quantity;

  CartItem({
    required this.productId,
    required this.nameAr,
    required this.nameEn,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
    );
  }
}

class CartModel {
  final int id;
  final List<CartItem> items;

  CartModel({required this.id, required this.items});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final itemsList =
        (json['items'] as List).map((item) => CartItem.fromJson(item)).toList();

    return CartModel(id: json['id'], items: itemsList);
  }
}
