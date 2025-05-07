class AddToCartResponse {
  final int cartId;
  final int productId;
  final int quantity;

  AddToCartResponse({
    required this.cartId,
    required this.productId,
    required this.quantity,
  });

  factory AddToCartResponse.fromJson(Map<String, dynamic> json) {
    return AddToCartResponse(
      cartId: json['cartId'],
      productId: json['productId'],
      quantity: json['quantity'],
    );
  }
}
