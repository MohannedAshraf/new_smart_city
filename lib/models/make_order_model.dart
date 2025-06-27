class Makeorder {
  final int productId;
  final String nameEn;
  final String nameAr;
  final double price;
  final int quantity;

  Makeorder({
    required this.productId,
    required this.nameEn,
    required this.nameAr,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "nameEn": nameEn,
    "nameAr": nameAr,
    "price": price,
    "quantity": quantity,
  };
}

class VendorGroup {
  final String businessName;
  final double totalPrice;
  final int itemCount;
  final List<Makeorder> items;

  VendorGroup({
    required this.businessName,
    required this.totalPrice,
    required this.itemCount,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
    "businessName": businessName,
    "totalPrice": totalPrice,
    "itemCount": itemCount,
    "items": items.map((e) => e.toJson()).toList(),
  };
}

class Payment {
  final double amount;
  final String status;
  final String transactionDate;

  Payment({
    required this.amount,
    required this.status,
    required this.transactionDate,
  });

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "status": status,
    "transactionDate": transactionDate,
  };
}

class MakeOrderModel {
  final String paymentMethodId;
  final int id;
  final double totalAmount;
  final String orderDate;
  final String status;
  final List<Makeorder> products;
  final List<VendorGroup> vendorGroups;
  final Payment payment;

  MakeOrderModel({
    required this.paymentMethodId,
    required this.id,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    required this.products,
    required this.vendorGroups,
    required this.payment,
  });

  Map<String, dynamic> toJson() => {
    "paymentMethodId": paymentMethodId,
    "id": id,
    "totalAmount": totalAmount,
    "orderDate": orderDate,
    "status": status,
    "products": products.map((e) => e.toJson()).toList(),
    "vendorGroups": vendorGroups.map((e) => e.toJson()).toList(),
    "payment": payment.toJson(),
  };
}
