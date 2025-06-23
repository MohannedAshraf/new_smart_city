import 'package:flutter/material.dart';
import 'package:citio/screens/my_order_page.dart';

class TrackOrderView extends StatelessWidget {
  final List<Order> orders;

  TrackOrderView({super.key, required this.orders});

  final Map<String, int> orderStatusIndexes = {
    "#ORD-2024-002": 3, // Coffee Corner → Delivery
    "#ORD-2024-003": 1, // Fresh Market → Preparing
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("تتبع الطلب", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final currentStepIndex = orderStatusIndexes[order.orderId] ?? 0;
          return _buildOrderCard(order, currentStepIndex);
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order, int currentStepIndex) {
    const List<String> statusSteps = [
      "Ordered",
      "Preparing",
      "Shipped",
      "Delivery",
      "Delivered",
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                order.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:
                      currentStepIndex == 1
                          ? Colors.amber.shade100
                          : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  currentStepIndex == 1 ? "Preparing" : "Out for Delivery",
                  style: TextStyle(
                    fontSize: 12,
                    color: currentStepIndex == 1 ? Colors.orange : Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Est. delivery: Today",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),

          const SizedBox(height: 16),

          // Products
          ...List.generate(order.itemCount, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildItemRow("Product ${index + 1}", 1),
            );
          }),

          const SizedBox(height: 12),

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
                  Icon(icon, color: color, size: 28),
                  const SizedBox(height: 6),
                  Text(
                    statusSteps[index],
                    style: TextStyle(fontSize: 11, color: color),
                  ),
                ],
              );
            }),
          ),

          const SizedBox(height: 20),

          // Contact Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.phone),
              label: const Text("Contact Provider"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(String title, int qty) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            "https://cdn-icons-png.flaticon.com/512/924/924514.png",
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Text("Qty: $qty", style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
