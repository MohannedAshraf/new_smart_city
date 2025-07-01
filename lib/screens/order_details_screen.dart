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
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04,
              vertical: MediaQuery.of(context).size.height * 0.025,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(orderInfo),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                _buildOrderedItems(
                  order.vendorOrderItemResponse,
                  orderInfo.orderStatus,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                _buildDeliveryDetails(order),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1875),
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
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.0175,
                      ),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.03,
                        ),
                      ),
                    ),
                    child: Text(
                      'تتبع الطلب',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        color: Colors.white,
                      ),
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
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: MediaQuery.of(context).size.height * 0.025,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width * 0.03,
        ),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "رقم الطلب: ${order.orderId}",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.01625,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.0075),
          Row(
            children: [
              Text(
                order.vendorName,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.025,
                  vertical: MediaQuery.of(context).size.height * 0.0075,
                ),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.05,
                  ),
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Row(
            children: [
              Text(
                "إجمالي المبلغ: ",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.0175,
                  color: Colors.grey,
                ),
              ),
              Text(
                "${order.totalAmount} جنيه",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.0175,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.005),
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
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: MediaQuery.of(context).size.height * 0.025,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width * 0.03,
        ),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "المنتجات المطلوبة",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.02,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
          for (var item in items) _buildItemRow(item, orderStatus),
        ],
      ),
    );
  }

  Widget _buildItemRow(OrderItem item, String orderStatus) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.015,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width * 0.02,
            ),
            child: Image.network(
              'https://service-provider.runasp.net${item.productImageUrl}',
              width: MediaQuery.of(context).size.width * 0.1375,
              height: MediaQuery.of(context).size.height * 0.06875,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                  width: MediaQuery.of(context).size.width * 0.1375,
                  height: MediaQuery.of(context).size.height * 0.06875,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nameAr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Text(
                  "الكمية: ${item.quantity}",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.015,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                if (orderStatus.toLowerCase() == "delivered" &&
                    !tempRatedProducts.containsKey(item.productId)) ...[
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemSize: MediaQuery.of(context).size.height * 0.025,
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
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.015,
                      color: Colors.green,
                    ),
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
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: MediaQuery.of(context).size.height * 0.025,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width * 0.03,
        ),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "تفاصيل التوصيل",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.02,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: MediaQuery.of(context).size.height * 0.02250,
                color: Colors.blue,
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Expanded(child: Text(order.userAddress)),
            ],
          ),
          if (order.vendorPhone != null) ...[
            SizedBox(height: MediaQuery.of(context).size.height * 0.0125),
            Row(
              children: [
                Icon(
                  Icons.phone,
                  size: MediaQuery.of(context).size.height * 0.02250,
                  color: Colors.blue,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Text(order.vendorPhone!),
              ],
            ),
          ],
          if (order.estimatedDeliveryDate != null) ...[
            SizedBox(height: MediaQuery.of(context).size.height * 0.0125),
            Row(
              children: [
                Icon(
                  Icons.timer,
                  size: MediaQuery.of(context).size.height * 0.02250,
                  color: Colors.blue,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Text(order.estimatedDeliveryDate!),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
