import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/helper/api_track_order.dart';
import 'package:citio/models/track_order_model.dart';
import 'package:flutter/material.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.trackOrderTitle,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : orderDetails == null
              ? const Center(child: Text(AppStrings.failedToLoadOrder))
              : ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.02,
                ),
                itemCount: orderDetails!.vendorGroups.length,
                itemBuilder: (context, index) {
                  final vendor = orderDetails!.vendorGroups[index];
                  return _buildOrderCard(vendor, screenWidth, screenHeight);
                },
              ),
    );
  }

  Widget _buildOrderCard(
    VendorGroup vendor,
    double screenWidth,
    double screenHeight,
  ) {
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
      margin: EdgeInsets.only(bottom: screenHeight * 0.03),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
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
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.025,
                  vertical: screenHeight * 0.005,
                ),
                decoration: BoxDecoration(
                  color: MyColors.primary,
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                ),
                child: Text(
                  vendor.shipementStatus ?? AppStrings.pendingStatus,
                  style: TextStyle(
                    fontSize: screenWidth * 0.03,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.005),
          Text(
            "${AppStrings.estimatedDelivery}: ${vendor.estimatedDeliveryDate ?? AppStrings.noEstimation}",
            style: TextStyle(fontSize: screenWidth * 0.032, color: Colors.grey),
          ),
          SizedBox(height: screenHeight * 0.02),

          // Products
          ...vendor.items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.012),
              child: _buildItemRow(item, screenWidth, screenHeight),
            ),
          ),

          SizedBox(height: screenHeight * 0.015),

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
                      ? MyColors.primary
                      : Colors.grey.shade400;

              IconData icon =
                  isDone
                      ? Icons.check_circle
                      : isCurrent
                      ? Icons.local_shipping
                      : Icons.radio_button_unchecked;

              return Column(
                children: [
                  Icon(icon, color: color, size: screenWidth * 0.07),
                  SizedBox(height: screenHeight * 0.007),
                  Text(
                    statusSteps[index],
                    style: TextStyle(
                      fontSize: screenWidth * 0.028,
                      color: color,
                    ),
                  ),
                ],
              );
            }),
          ),

          SizedBox(height: screenHeight * 0.025),

          // Contact Button
          Container(
            decoration: BoxDecoration(
              color: MyColors.primary,
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
            child: TextButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.contactVendor,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.015),
                  Icon(
                    Icons.phone,
                    color: Colors.white,
                    size: screenWidth * 0.05,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(Item item, double screenWidth, double screenHeight) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(screenWidth * 0.015),
          child: Image.network(
            "${Urls.serviceProviderbaseUrl}${item.productImageUrl}",
            width: screenWidth * 0.1,
            height: screenWidth * 0.1,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: screenWidth * 0.03),
        Expanded(
          child: Text(
            item.nameAr,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          "${AppStrings.quantity} ${item.quantity}",
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
