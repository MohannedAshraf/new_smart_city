// ignore_for_file: deprecated_member_use

import 'package:citio/helper/api_order_details.dart';
import 'package:citio/models/order_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OrderDetailsView extends StatelessWidget {
  final int orderId;
  final String vendorId;

  const OrderDetailsView({
    super.key,
    required this.orderId,
    required this.vendorId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تفاصيل الطلب',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<VendorOrderDetailsResponse>(
        future: OrderDetailsApiHelper.fetchOrderDetails(
          orderId: orderId,
          vendorId: vendorId,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('لا توجد بيانات'));
          }

          final order = snapshot.data!;
          final orderInfo = order.vendorOrder;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(orderInfo),
                const SizedBox(height: 16),
                _buildOrderedItems(order.items),
                const SizedBox(height: 16),
                _buildDeliveryDetails(order),
                const SizedBox(height: 220),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // لوجيك تتبع الطلب
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'تتبع الطلب',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(VendorOrderDto order) {
    Color badgeColor;
    switch (order.orderStatus) {
      case "المعلقة":
        badgeColor = Colors.amberAccent;
        break;
      case "قيد التقدم":
        badgeColor = Colors.blue;
        break;
      case "المكتملة":
        badgeColor = Colors.green;
        break;
      default:
        badgeColor = Colors.amberAccent;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "رقم الطلب: ${order.orderId}",
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                order.vendorName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: badgeColor),
                ),
                child: Text(
                  order.orderStatus,
                  style: TextStyle(
                    color: badgeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                "إجمالي المبلغ: ",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                "${order.totalAmount} جنيه",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "تاريخ الطلب: ${order.orderDate.toLocal().toString().split(' ')[0]}",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderedItems(List<OrderItem> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "المنتجات المطلوبة",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          for (var item in items) _buildItemRow(item),
        ],
      ),
    );
  }

  Widget _buildItemRow(OrderItem item) {
    double userRating = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://service-provider.runasp.net${item.productImageUrl}',
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nameAr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "الكمية: ${item.quantity}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    RatingBar.builder(
                      initialRating: userRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemSize: 20,
                      itemCount: 5,
                      unratedColor: Colors.grey.shade300,
                      itemBuilder:
                          (context, _) =>
                              const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        setState(() {
                          userRating = rating;
                        });
                        print("⭐ تقييم ${item.nameAr}: $rating");
                      },
                    ),
                  ],
                ),
              ),
              Text(
                "${item.price.toStringAsFixed(0)} جنيه",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeliveryDetails(VendorOrderDetailsResponse order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "تفاصيل التوصيل",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(child: Text(order.userAddress)),
            ],
          ),
          if (order.vendorPhone != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.phone, size: 18, color: Colors.blue),
                const SizedBox(width: 8),
                Text(order.vendorPhone!),
              ],
            ),
          ],
          if (order.estimatedDeliveryDate != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.timer, size: 18, color: Colors.blue),
                const SizedBox(width: 8),
                Text(order.estimatedDeliveryDate!),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
