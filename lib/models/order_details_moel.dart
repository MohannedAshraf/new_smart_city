class VendorOrderDetailsResponse {
  final VendorOrderDto vendorOrderDto;
  final List<OrderItem> vendorOrderItemResponse;
  final String userAddress;
  final String? vendorPhone;
  final String? estimatedDeliveryDate;

  VendorOrderDetailsResponse({
    required this.vendorOrderDto,
    required this.vendorOrderItemResponse,
    required this.userAddress,
    required this.vendorPhone,
    required this.estimatedDeliveryDate,
  });

  factory VendorOrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    return VendorOrderDetailsResponse(
      vendorOrderDto: VendorOrderDto.fromJson(json['vendorOrderDto']),
      vendorOrderItemResponse:
          (json['vendorOrderItemResponse'] as List)
              .map((e) => OrderItem.fromJson(e))
              .toList(),
      userAddress: json['userAddress'],
      vendorPhone: json['vendorPhone'],
      estimatedDeliveryDate: json['estimatedDeliveryDate'],
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
  final String nameEn;
  final String nameAr;
  final double price;
  final int quantity;
  bool isRated;
  double rating;

  OrderItem({
    required this.productId,
    required this.productImageUrl,
    required this.nameEn,
    required this.nameAr,
    required this.price,
    required this.quantity,
    required this.isRated,
    required this.rating,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      productImageUrl: json['productImageUrl'],
      nameEn: json['nameEn'],
      nameAr: json['nameAr'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      isRated: json['isRated'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}
