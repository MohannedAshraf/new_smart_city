// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use

import 'package:citio/helper/api_myorder.dart';
import 'package:citio/models/myorder_model.dart';
import 'package:citio/screens/order_details_screen.dart';
import 'package:flutter/material.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  int selectedIndex = 0;
  List<OrderItem> allOrders = []; // كل الطلبات
  List<OrderItem> filteredOrders = []; // الطلبات المفلترة
  bool isLoading = true;

  final List<String> categories = ['All', 'Pending', 'Processing', 'Delivered'];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final result = await OrdersApiHelper.fetchOrders(); // بدون فلترة
      setState(() {
        allOrders = result;
        filteredOrders = filterOrders(result);
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  List<OrderItem> filterOrders(List<OrderItem> orders) {
    final selectedStatus = categories[selectedIndex].toLowerCase();
    if (selectedStatus == 'all') return orders;
    return orders
        .where((o) => o.orderStatus.toLowerCase() == selectedStatus)
        .toList();
  }

  void onCategorySelected(int index) {
    setState(() {
      selectedIndex = index;
      filteredOrders = filterOrders(allOrders);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طلباتي', style: TextStyle(color: Colors.black)),
        centerTitle: true,
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
                return GestureDetector(
                  onTap: () => onCategorySelected(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                child:
                    filteredOrders.isEmpty
                        ? const Center(child: Text("لا يوجد طلبات"))
                        : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredOrders.length,
                          itemBuilder: (context, index) {
                            final order = filteredOrders[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => OrderDetailsView(
                                          orderId: order.orderId,
                                          vendorId: order.vendorId,
                                        ),
                                  ),
                                );
                              },
                              child: buildOrderCard(order),
                            );
                          },
                        ),
              ),
        ],
      ),
    );
  }

  Widget buildOrderCard(OrderItem order) {
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

    final orderDate = order.orderDate.toLocal().toString().split(' ')[0];

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
              "https://service-provider.runasp.net${order.vendorImageUrl}",
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                  width: 70,
                  height: 70,
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
                  "رقم الطلب: #${order.orderId}",
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  order.vendorName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$orderDate\n${order.totalItems} منتج • ${order.totalAmount.toStringAsFixed(0)} جنيه",
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: badgeColor, width: 1.2),
            ),
            child: Text(
              order.orderStatus,
              style: TextStyle(
                fontSize: 13,
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
