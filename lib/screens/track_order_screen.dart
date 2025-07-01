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
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: MediaQuery.of(context).size.height * 0.025,
                ),
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
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.03,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: MediaQuery.of(context).size.height * 0.025,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width * 0.04,
        ),
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
                  fontSize: MediaQuery.of(context).size.height * 0.02250,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.025,
                  vertical: MediaQuery.of(context).size.height * 0.005,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.05,
                  ),
                ),
                child: Text(
                  vendor.shipementStatus ?? "Pending",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.015,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.005),
          Text(
            "Est. delivery: ${vendor.estimatedDeliveryDate ?? 'غير متوفر'}",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.01625,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.025),

          // Products
          ...vendor.items.map(
            (item) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.0125,
              ),
              child: _buildItemRow(item),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.015),

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
                  Icon(
                    icon,
                    color: color,
                    size: MediaQuery.of(context).size.height * 0.0350,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.0075),
                  Text(
                    statusSteps[index],
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.01375,
                      color: color,
                    ),
                  ),
                ],
              );
            }),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.0250),

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
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.0175,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.03,
                  ),
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
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * 0.015,
          ),
          child: Image.network(
            "https://service-provider.runasp.net${item.productImageUrl}",
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.05,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.03),
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
