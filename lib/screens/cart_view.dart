import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/helper/api_cart.dart';
import 'package:citio/helper/api_edit_cart.dart';
import 'package:citio/models/cart_model.dart';
import 'package:citio/screens/checkout_view.dart';
import 'package:citio/screens/order_card.dart';
import 'package:flutter/material.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late Future<CartModel> cartFuture;

  @override
  void initState() {
    super.initState();
    cartFuture = ApiCartModel.fetchCart();
  }

  void refreshCart() {
    setState(() {
      cartFuture = ApiCartModel.fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Cart",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder<CartModel>(
        future: cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          final cart = snapshot.data!;
          final items = cart.items;
          double subtotal = items.fold(
            0,
            (sum, item) => sum + (item.price * item.quantity),
          );

          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Shopping List",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return OrderCard(
                        ordername: item.nameEn,
                        orderprice: item.price,
                        quantity: item.quantity,
                        orderpic:
                            "https://service-provider.runasp.net${item.mainImageUrl}",
                        productId: item.productId,
                        onQuantityChanged: (newQty) async {
                          await EditCartService.editCartItem(
                            productId: item.productId,
                            quantity: newQty,
                          );
                          refreshCart(); // تحدث الشاشة بالكامل وتعيد تحميل السعر الجديد
                        },
                      );
                    },
                  ),
                ),
                const Divider(),
                Row(
                  children: [
                    const Text("Subtotal"),
                    const Spacer(),
                    Text("LE ${subtotal.toStringAsFixed(2)}"),
                  ],
                ),
                const Row(
                  children: [Text("Tax and Fees"), Spacer(), Text("LE 3.00")],
                ),
                const Row(
                  children: [Text("Delivery Fee"), Spacer(), Text("LE 2.00")],
                ),
                const Divider(),
                Row(
                  children: [
                    const Text("Order Total"),
                    const Spacer(),
                    Text("LE ${(subtotal + 3 + 2).toStringAsFixed(2)}"),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 17),
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: MyAppColors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckoutView(),
                        ),
                      );
                    },
                    child: const Text(
                      "Checkout",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: MyAppColors.background,
                      ),
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
}
