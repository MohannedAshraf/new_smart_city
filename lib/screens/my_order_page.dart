// ignore_for_file: deprecated_member_use

import 'package:citio/screens/order_details_screen.dart';
import 'package:flutter/material.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  int selectedIndex = 0;

  final List<String> categories = ['الكل', 'المعلقة', 'قيد التقدم', 'المكتملة'];

  final List<Order> allOrders = [
    Order(
      orderId: "#ORD-2024-001",
      title: "Burger Palace",
      date: "Dec 15, 2024",
      itemCount: 3,
      price: 250,
      imageUrl: "https://cdn-icons-png.flaticon.com/512/3075/3075977.png",
      status: "المكتملة",
    ),
    Order(
      orderId: "#ORD-2024-002",
      title: "Coffee Corner",
      date: "Dec 16, 2024",
      itemCount: 2,
      price: 125,
      imageUrl: "https://cdn-icons-png.flaticon.com/512/924/924514.png",
      status: "قيد التقدم",
    ),
    Order(
      orderId: "#ORD-2024-003",
      title: "Fresh Market",
      date: "Dec 17, 2024",
      itemCount: 1,
      price: 65,
      imageUrl: "https://cdn-icons-png.flaticon.com/512/3081/3081559.png",
      status: "المعلقة",
    ),
    Order(
      orderId: "#ORD-2024-004",
      title: "Pizza House",
      date: "Dec 14, 2024",
      itemCount: 2,
      price: 290,
      imageUrl: "https://cdn-icons-png.flaticon.com/512/3132/3132693.png",
      status: "ملغي",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredOrders =
        selectedIndex == 0
            ? allOrders
            : allOrders
                .where((order) => order.status == categories[selectedIndex])
                .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('طلباتي', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        // backgroundColor: Colors.white,
        //elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;
                return ChoiceChip(
                  label: Text(categories[index]),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => selectedIndex = index);
                  },
                  selectedColor: Colors.blue,
                  backgroundColor: Colors.grey.shade200,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                OrderDetailsView(order: filteredOrders[index]),
                      ),
                    );
                  },
                  child: buildOrderCard(filteredOrders[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrderCard(Order order) {
    Color badgeColor;
    switch (order.status) {
      case "المكتملة":
        badgeColor = Colors.green;
        break;
      case "المعلقة":
        badgeColor = Colors.amber;
        break;
      case "قيد التقدم":
        badgeColor = Colors.blue;
        break;
      case "ملغي":
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black12)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              order.imageUrl,
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
                  order.orderId,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  order.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${order.date}\n${order.itemCount} عنصر • ${order.price.toStringAsFixed(0)} جنيه",
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              order.status,
              style: TextStyle(
                fontSize: 12,
                color: badgeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Order {
  final String orderId;
  final String title;
  final String date;
  final int itemCount;
  final double price;
  final String imageUrl;
  final String status;

  Order({
    required this.orderId,
    required this.title,
    required this.date,
    required this.itemCount,
    required this.price,
    required this.imageUrl,
    required this.status,
  });
}
