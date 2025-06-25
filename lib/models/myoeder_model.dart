class OrderItem {
  final int orderId;
  final String vendorId;
  final String vendorName;
  final String vendorImageUrl;
  final String orderStatus;
  final DateTime orderDate;
  final int totalItems;
  final double totalAmount;

  OrderItem({
    required this.orderId,
    required this.vendorId,
    required this.vendorName,
    required this.vendorImageUrl,
    required this.orderStatus,
    required this.orderDate,
    required this.totalItems,
    required this.totalAmount,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderId: json['orderId'],
      vendorId: json['vendorId'],
      vendorName: json['vendorName'],
      vendorImageUrl: json['vendorImageUrl'],
      orderStatus: json['orderStatus'],
      orderDate: DateTime.parse(json['orderDate']),
      totalItems: json['totalItems'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }
}
