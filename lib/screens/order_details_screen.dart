// ignore_for_file: deprecated_member_use, avoid_print, prefer_const_constructors, use_build_context_synchronously

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/core/utils/app_strings.dart';
import 'package:citio/helper/api_order_details.dart';
import 'package:citio/helper/api_rate_product.dart';
import 'package:citio/models/order_details_model.dart';
import 'package:citio/models/rate_product_model.dart';
import 'package:citio/screens/track_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.orderDetails,
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
            return Center(child: Text('${AppStrings.error} ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text(AppStrings.noData));
          }

          final order = snapshot.data!;
          final orderInfo = order.vendorOrderDto;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screen.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screen.height * 0.015),
                _buildHeader(orderInfo, screen),
                SizedBox(height: screen.height * 0.02),
                _buildOrderedItems(
                  order.vendorOrderItemResponse,
                  orderInfo.orderStatus,
                  screen,
                ),
                SizedBox(height: screen.height * 0.02),
                _buildDeliveryDetails(order, screen),
                SizedBox(height: screen.height * 0.05),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => TrackOrderView(orderId: widget.orderId),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: screen.height * 0.02,
                      ),
                      backgroundColor: MyColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      AppStrings.trackOrder,
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

  Widget _buildHeader(VendorOrderDto order, Size screen) {
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
        vertical: screen.height * 0.02,
        horizontal: screen.width * 0.04,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${AppStrings.orderNumber} ${order.orderId}",
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
                padding: EdgeInsets.symmetric(
                  horizontal: screen.width * 0.03,
                  vertical: screen.height * 0.007,
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
                AppStrings.totalAmount,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                "${order.totalAmount} ${AppStrings.egp}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "${AppStrings.orderDate} ${order.orderDate.toLocal().toString().split(' ')[0]}",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderedItems(
    List<OrderItem> items,
    String orderStatus,
    Size screen,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: screen.height * 0.02,
        horizontal: screen.width * 0.04,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.orderedProducts,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          for (var item in items) _buildItemRow(item, orderStatus, screen),
        ],
      ),
    );
  }

  Widget _buildItemRow(OrderItem item, String orderStatus, Size screen) {
    return FutureBuilder<ProductReview?>(
      future: ProductReviewApi.getReview(item.productId),
      builder: (context, snapshot) {
        final alreadyRated = snapshot.hasData && snapshot.data != null;
        if (alreadyRated && !item.isRated) {
          item.rating = snapshot.data!.rating.toDouble();
          item.isRated = true;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  '${Urls.serviceProviderbaseUrl}${item.productImageUrl}',
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Image.network(
                        AppStrings.fallbackImage,
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                      ),
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
                      "${AppStrings.quantity1} ${item.quantity}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    if (orderStatus.toLowerCase() == "delivered")
                      item.isRated
                          ? Text(
                            "${AppStrings.alreadyRated} ${item.rating.toStringAsFixed(1)} ${AppStrings.ratingUnit}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                            ),
                          )
                          : RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemSize: 20,
                            itemCount: 5,
                            unratedColor: Colors.grey.shade300,
                            itemBuilder:
                                (_, __) =>
                                    const Icon(Icons.star, color: Colors.amber),
                            onRatingUpdate: (rating) async {
                              try {
                                await ProductReviewApi.postReview(
                                  item.productId,
                                  rating.toInt(),
                                );
                                setState(() {
                                  item.rating = rating;
                                  item.isRated = true;
                                });
                              } catch (e) {
                                print("❌ Rating error: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(AppStrings.rateFailed),
                                  ),
                                );
                              }
                            },
                          ),
                  ],
                ),
              ),
              Text(
                "${item.price.toStringAsFixed(0)} ${AppStrings.egp}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeliveryDetails(VendorOrderDetailsResponse order, Size screen) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: screen.height * 0.02,
        horizontal: screen.width * 0.04,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.deliveryDetails,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: MyColors.primary),
              const SizedBox(width: 8),
              Expanded(child: Text(order.userAddress)),
            ],
          ),
          if (order.vendorPhone != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.phone, size: 18, color: MyColors.primary),
                const SizedBox(width: 8),
                Text(order.vendorPhone!),
              ],
            ),
          ],
          if (order.estimatedDeliveryDate != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.timer, size: 18, color: MyColors.primary),
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
