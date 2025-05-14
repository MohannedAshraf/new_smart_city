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
  late CartModel? cart;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final fetchedCart = await ApiCartModel.fetchCart();
      setState(() {
        cart = fetchedCart;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (error != null) {
      return Scaffold(body: Center(child: Text('Error: $error')));
    }

    if (cart == null || cart!.items.isEmpty) {
      return const Scaffold(body: Center(child: Text('Your cart is empty')));
    }

    final items = cart!.items;
    double subtotal = items.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Cart",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
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

                      setState(() {
                        item.quantity = newQty; // ✅ تحديث مباشر
                      });
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
                      builder:
                          (context) => CheckoutView(cartItems: cart!.items),
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
      ),
    );
  }
}
