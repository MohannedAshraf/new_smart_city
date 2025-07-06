// ignore_for_file: deprecated_member_use

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/helper/api_myorder.dart';
import 'package:citio/main.dart';
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
  List<OrderItem> allOrders = [];
  List<OrderItem> filteredOrders = [];
  bool isLoading = true;

  final List<String> categories = [
    AppStrings.categoryAll,
    AppStrings.categoryPending,
    AppStrings.categoryProcessing,
    AppStrings.categoryDelivered,
  ];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final result = await OrdersApiHelper.fetchOrders();
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage(initialIndex: 0)),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.myOrdersTitle,
            style: const TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomePage(initialIndex: 0),
                ),
                (route) => false,
              );
            },
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: height * 0.01),
            SizedBox(
              height: height * 0.05,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => SizedBox(width: width * 0.02),
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () => onCategorySelected(index),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? MyColors.primary
                                : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: width * 0.035,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: height * 0.015),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                  child:
                      filteredOrders.isEmpty
                          ? Center(child: Text(AppStrings.noOrdersFound))
                          : ListView.builder(
                            padding: EdgeInsets.all(width * 0.04),
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
                                child: buildOrderCard(context, order),
                              );
                            },
                          ),
                ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderCard(BuildContext context, OrderItem order) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    Color badgeColor;
    switch (order.orderStatus.toLowerCase()) {
      case "pending":
        badgeColor = Colors.amber;
        break;
      case "processing":
        badgeColor = MyColors.primary;
        break;
      case "delivered":
        badgeColor = Colors.green;
        break;
      default:
        badgeColor = Colors.grey;
    }

    final orderDate = order.orderDate.toLocal().toString().split(' ')[0];

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.015),
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: height * 0.015,
      ),
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
              "${Urls.serviceProviderbaseUrl}${order.vendorImageUrl}",
              width: width * 0.18,
              height: width * 0.18,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                  width: width * 0.18,
                  height: width * 0.18,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          SizedBox(width: width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${AppStrings.orderNumberPrefix}${order.orderId}",
                  style: TextStyle(fontSize: width * 0.032),
                ),
                SizedBox(height: height * 0.004),
                Text(
                  order.vendorName,
                  style: TextStyle(
                    fontSize: width * 0.042,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.004),
                Text(
                  "$orderDate\n${order.totalItems} ${AppStrings.productUnit} • ${order.totalAmount.toStringAsFixed(0)} ${AppStrings.currency1}",
                  style: TextStyle(fontSize: width * 0.032),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: height * 0.008,
            ),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: badgeColor, width: 1.2),
            ),
            child: Text(
              order.orderStatus,
              style: TextStyle(
                fontSize: width * 0.033,
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
