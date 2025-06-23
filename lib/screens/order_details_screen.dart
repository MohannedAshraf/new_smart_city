import 'package:citio/screens/my_order_page.dart';
import 'package:citio/screens/track_order_screen.dart';
import 'package:flutter/material.dart';

class OrderDetailsView extends StatelessWidget {
  final Order order;

  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تفاصيل الطلب',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(order),
            const SizedBox(height: 16),
            _buildOrderedItems(),
            const SizedBox(height: 16),
            _buildDeliveryDetails(),
            const SizedBox(height: 70),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => TrackOrderView(
                            orders: [
                              order, // نفس الأوردر الحالي
                              Order(
                                orderId: "#ORD-2024-003",
                                title: "Fresh Market",
                                date: "Dec 17, 2024",
                                itemCount: 2,
                                price: 85,
                                imageUrl:
                                    "https://cdn-icons-png.flaticon.com/512/3081/3081559.png",
                                status: "قيد التقدم",
                              ),
                            ],
                          ),
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
      ),
    );
  }

  Widget _buildHeader(Order order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.orderId,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                order.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'قيد التقدم',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
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
                'إجمالي المبلغ:',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(width: 8),
              Text(
                "EGP ${order.price.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderedItems() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'المنتجات المطلوبة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          _buildItemRow('Cappuccino', 'Large • Extra shot • Oat milk', 1, 65),
          const SizedBox(height: 12),
          _buildItemRow('Chocolate Croissant', 'Fresh baked • Warm', 1, 60),
        ],
      ),
    );
  }

  Widget _buildItemRow(String name, String description, int qty, double price) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://cdn-icons-png.flaticon.com/512/924/924514.png',
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text('Qty: $qty', style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
        Text(
          'EGP ${price.toStringAsFixed(0)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDeliveryDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تفاصيل التوصيل',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.location_on, size: 18, color: Colors.blue),
              SizedBox(width: 8),
              Expanded(
                child: Text("123 Main Street, Apt 4B\nDowntown, Cairo 11511"),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.phone, size: 18, color: Colors.blue),
              SizedBox(width: 8),
              Text("+20 123 456 7890"),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.timer, size: 18, color: Colors.blue),
              SizedBox(width: 8),
              Text("Today, 3:15 PM - 3:30 PM"),
            ],
          ),
        ],
      ),
    );
  }
}
