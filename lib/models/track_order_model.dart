class TrackOrderModel {
  final int id;
  final List<VendorGroup> vendorGroups;

  TrackOrderModel({required this.id, required this.vendorGroups});

  factory TrackOrderModel.fromJson(Map<String, dynamic> json) {
    return TrackOrderModel(
      id: json['id'],
      vendorGroups: List<VendorGroup>.from(
        json['vendorGroups'].map((x) => VendorGroup.fromJson(x)),
      ),
    );
  }
}

class VendorGroup {
  final String businessName;
  final double totalPrice;
  final int itemCount;
  final List<Item> items;
  final String? estimatedDeliveryDate; // ✅ made nullable
  final String? shipementStatus; // ✅ made nullable
  final String vendorPhone;

  VendorGroup({
    required this.businessName,
    required this.totalPrice,
    required this.itemCount,
    required this.items,
    required this.estimatedDeliveryDate,
    required this.shipementStatus,
    required this.vendorPhone,
  });

  factory VendorGroup.fromJson(Map<String, dynamic> json) {
    return VendorGroup(
      businessName: json['businessName'],
      totalPrice: (json['totalPrice'] as num).toDouble(),
      itemCount: json['itemCount'],
      items: List<Item>.from(json['items'].map((x) => Item.fromJson(x))),
      estimatedDeliveryDate: json['estimatedDeliveryDate'], // nullable
      shipementStatus: json['shipementStatus'], // nullable
      vendorPhone: json['vendorPhone'],
    );
  }
}

class Item {
  final int productId;
  final String productImageUrl;
  final String nameEn;
  final String nameAr;
  final double price;
  final int quantity;

  Item({
    required this.productId,
    required this.productImageUrl,
    required this.nameEn,
    required this.nameAr,
    required this.price,
    required this.quantity,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      productId: json['productId'],
      productImageUrl: json['productImageUrl'],
      nameEn: json['nameEn'],
      nameAr: json['nameAr'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
    );
  }
}
