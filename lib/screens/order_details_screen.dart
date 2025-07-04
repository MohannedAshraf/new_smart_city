// ignore_for_file: deprecated_member_use, avoid_print, prefer_const_constructors, use_build_context_synchronously

import 'package:citio/helper/api_order_details.dart';
import 'package:citio/helper/api_rate_product.dart';
import 'package:citio/models/order_details_model.dart';
import 'package:citio/models/rate_product_model.dart';
import 'package:citio/screens/track_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(orderInfo),
                SizedBox(height: 16.h),
                _buildOrderedItems(
                  order.vendorOrderItemResponse,
                  orderInfo.orderStatus,
                ),
                SizedBox(height: 16.h),
                _buildDeliveryDetails(order),
                SizedBox(height: 100.h),
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
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'تتبع الطلب',
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "رقم الطلب: ${order.orderId}",
            style: TextStyle(fontSize: 13.sp),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Text(
                order.vendorName,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
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
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                "إجمالي المبلغ: ",
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
              Text(
                "${order.totalAmount} جنيه",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 4.h),
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "المنتجات المطلوبة",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          for (var item in items) _buildItemRow(item, orderStatus),
        ],
      ),
    );
  }

  Widget _buildItemRow(OrderItem item, String orderStatus) {
    return FutureBuilder<ProductReview?>(
      future: ProductReviewApi.getReview(item.productId),
      builder: (context, snapshot) {
        final alreadyRated = snapshot.hasData && snapshot.data != null;
        if (alreadyRated && !item.isRated) {
          item.rating = snapshot.data!.rating.toDouble();
          item.isRated = true;
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  'https://service-provider.runasp.net${item.productImageUrl}',
                  width: 55.w,
                  height: 55.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                      width: 55.w,
                      height: 55.h,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nameAr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "الكمية: ${item.quantity}",
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    SizedBox(height: 4.h),
                    if (orderStatus.toLowerCase() == "delivered") ...[
                      if (!item.isRated) ...[
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemSize: 20.sp,
                          itemCount: 5,
                          unratedColor: Colors.grey.shade300,
                          itemBuilder:
                              (context, _) =>
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
                                SnackBar(content: Text("فشل إرسال التقييم")),
                              );
                            }
                          },
                        ),
                      ] else ...[
                        Text(
                          "تم التقييم بـ ${item.rating.toStringAsFixed(1)} نجوم",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.green,
                          ),
                        ),
                      ],
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
      },
    );
  }

  Widget _buildDeliveryDetails(VendorOrderDetailsResponse order) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "تفاصيل التوصيل",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.location_on, size: 18.sp, color: Colors.blue),
              SizedBox(width: 8.w),
              Expanded(child: Text(order.userAddress)),
            ],
          ),
          if (order.vendorPhone != null) ...[
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(Icons.phone, size: 18.sp, color: Colors.blue),
                SizedBox(width: 8.w),
                Text(order.vendorPhone!),
              ],
            ),
          ],
          if (order.estimatedDeliveryDate != null) ...[
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(Icons.timer, size: 18.sp, color: Colors.blue),
                SizedBox(width: 8.w),
                Text(order.estimatedDeliveryDate!),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
