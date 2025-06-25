class VendorOrderDetailsResponse {
  final VendorOrderDto vendorOrder;
  final List<OrderItem> items;
  final String userAddress;
  final String? vendorPhone;
  final String? estimatedDeliveryDate;
  final String? shipmentStatus;

  VendorOrderDetailsResponse({
    required this.vendorOrder,
    required this.items,
    required this.userAddress,
    this.vendorPhone,
    this.estimatedDeliveryDate,
    this.shipmentStatus,
  });

  factory VendorOrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    return VendorOrderDetailsResponse(
      vendorOrder: VendorOrderDto.fromJson(json['vendorOrderDto']),
      items:
          (json['vendorOrderItemResponse'] as List)
              .map((e) => OrderItem.fromJson(e))
              .toList(),
      userAddress: json['userAddress'],
      vendorPhone: json['vendorPhone'],
      estimatedDeliveryDate: json['estimatedDeliveryDate'],
      shipmentStatus: json['shipementStatus'],
    );
  }
}

class VendorOrderDto {
  final int orderId;
  final String vendorId;
  final String vendorName;
  final String vendorImageUrl;
  final String orderStatus;
  final DateTime orderDate;
  final int totalItems;
  final double totalAmount;

  VendorOrderDto({
    required this.orderId,
    required this.vendorId,
    required this.vendorName,
    required this.vendorImageUrl,
    required this.orderStatus,
    required this.orderDate,
    required this.totalItems,
    required this.totalAmount,
  });

  factory VendorOrderDto.fromJson(Map<String, dynamic> json) {
    return VendorOrderDto(
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

class OrderItem {
  final int productId;
  final String productImageUrl;
  final String nameAr;
  final double price;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.productImageUrl,
    required this.nameAr,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      productImageUrl: json['productImageUrl'],
      nameAr: json['nameAr'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
    );
  }
}
