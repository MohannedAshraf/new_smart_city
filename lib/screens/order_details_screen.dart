// ignore_for_file: deprecated_member_use, avoid_print, curly_braces_in_flow_control_structures

import 'package:citio/helper/api_order_details.dart';
import 'package:citio/models/order_details_moel.dart';
import 'package:citio/screens/track_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderDetailsView extends StatefulWidget {
  final int orderId;
  final String vendorId;

  const OrderDetailsView({
    super.key,
    required this.orderId,
    required this.vendorId,
  });

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  final Map<int, double> tempRatedProducts = {};

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
          orderId: widget.orderId,
          vendorId: widget.vendorId,
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
          final orderInfo = order.vendorOrderDto;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(orderInfo),
                const SizedBox(height: 16),
                _buildOrderedItems(
                  order.vendorOrderItemResponse,
                  orderInfo.orderStatus,
                ),
                const SizedBox(height: 16),
                _buildDeliveryDetails(order),
                const SizedBox(height: 150),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  TrackOrderView(orderId: widget.orderId),
                        ),
                      );
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
    switch (order.orderStatus.toLowerCase()) {
      case "pending":
        badgeColor = Colors.amber;
        break;
      case "processing":
        badgeColor = Colors.blue;
        break;
      case "delivered":
        badgeColor = Colors.green;
        break;
      default:
        badgeColor = Colors.grey;
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
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                "${order.totalAmount} جنيه",
                style: const TextStyle(
                  fontSize: 14,
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

  Widget _buildOrderedItems(List<OrderItem> items, String orderStatus) {
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
          for (var item in items) _buildItemRow(item, orderStatus),
        ],
      ),
    );
  }

  Widget _buildItemRow(OrderItem item, String orderStatus) {
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
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                );
              },
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
                if (orderStatus.toLowerCase() == "delivered" &&
                    !tempRatedProducts.containsKey(item.productId)) ...[
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemSize: 20,
                    itemCount: 5,
                    unratedColor: Colors.grey.shade300,
                    itemBuilder:
                        (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) async {
                      setState(() {
                        tempRatedProducts[item.productId] = rating;
                      });

                      try {
                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString('token');
                        if (token == null) throw Exception("Token not found");

                        final url = Uri.parse(
                          "https://service-provider.runasp.net/api/Products/${item.productId}/reviews",
                        );
                        final response = await http.post(
                          url,
                          headers: {
                            'Authorization': 'Bearer $token',
                            'Content-Type': 'application/json',
                          },
                          body: jsonEncode({"rating": rating, "comment": ""}),
                        );

                        print("⭐ تم إرسال التقييم: ${response.statusCode}");
                      } catch (e) {
                        print("❌ خطأ أثناء إرسال التقييم: $e");
                      }
                    },
                  ),
                ],
                if (tempRatedProducts.containsKey(item.productId)) ...[
                  Text(
                    "تم التقييم بـ ${tempRatedProducts[item.productId]!.toStringAsFixed(1)} نجوم",
                    style: const TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ],
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
