import 'package:citio/helper/api_track_order.dart';
import 'package:citio/models/track_order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrackOrderView extends StatefulWidget {
  final int orderId;

  const TrackOrderView({super.key, required this.orderId});

  @override
  State<TrackOrderView> createState() => _TrackOrderViewState();
}

class _TrackOrderViewState extends State<TrackOrderView> {
  TrackOrderModel? orderDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrder();
  }

  Future<void> fetchOrder() async {
    final data = await ApiTrackOrder.fetchOrderDetails(widget.orderId);
    setState(() {
      orderDetails = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تتبع الطلب", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : orderDetails == null
              ? const Center(child: Text("فشل تحميل الطلب"))
              : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                itemCount: orderDetails!.vendorGroups.length,
                itemBuilder: (context, index) {
                  final vendor = orderDetails!.vendorGroups[index];
                  return _buildOrderCard(vendor);
                },
              ),
    );
  }

  Widget _buildOrderCard(VendorGroup vendor) {
    const List<String> statusSteps = [
      "Ordered",
      "Preparing",
      "Shipped",
      "Delivery",
      "Delivered",
    ];

    int currentStepIndex = statusSteps.indexWhere(
      (step) =>
          step.toLowerCase() == (vendor.shipementStatus ?? "").toLowerCase(),
    );
    currentStepIndex = currentStepIndex == -1 ? 0 : currentStepIndex;

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                vendor.businessName,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  vendor.shipementStatus ?? "Pending",
                  style: TextStyle(fontSize: 12.sp, color: Colors.blue),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            "Est. delivery: ${vendor.estimatedDeliveryDate ?? 'غير متوفر'}",
            style: TextStyle(fontSize: 13.sp, color: Colors.grey),
          ),
          SizedBox(height: 16.h),

          // Products
          ...vendor.items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _buildItemRow(item),
            ),
          ),

          SizedBox(height: 12.h),

          // Timeline
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(statusSteps.length, (index) {
              bool isDone = index < currentStepIndex;
              bool isCurrent = index == currentStepIndex;

              Color color =
                  isDone
                      ? Colors.green
                      : isCurrent
                      ? Colors.blue
                      : Colors.grey.shade400;

              IconData icon =
                  isDone
                      ? Icons.check_circle
                      : isCurrent
                      ? Icons.local_shipping
                      : Icons.radio_button_unchecked;

              return Column(
                children: [
                  Icon(icon, color: color, size: 28.sp),
                  SizedBox(height: 6.h),
                  Text(
                    statusSteps[index],
                    style: TextStyle(fontSize: 11.sp, color: color),
                  ),
                ],
              );
            }),
          ),

          SizedBox(height: 20.h),

          // Contact Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // ممكن تضيف launchPhoneCall هنا لو حبيت
              },
              icon: const Icon(Icons.phone),
              label: const Text("Contact Provider"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(Item item) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Image.network(
            "https://service-provider.runasp.net${item.productImageUrl}",
            width: 40.w,
            height: 40.h,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            item.nameAr,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          "Qty: ${item.quantity}",
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
