class EditCartResponse {
  final int cartId;
  final int productId;
  final int quantity;

  EditCartResponse({
    required this.cartId,
    required this.productId,
    required this.quantity,
  });

  factory EditCartResponse.fromJson(Map<String, dynamic> json) {
    return EditCartResponse(
      cartId: json['cartId'],
      productId: json['productId'],
      quantity: json['quantity'],
    );
  }
}
