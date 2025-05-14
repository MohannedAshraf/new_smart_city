import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/models/cart_model.dart';

import 'package:citio/screens/order_card2.dart';
import 'package:flutter/material.dart';

class CheckoutView extends StatelessWidget {
  final List<CartItem> cartItems;

  const CheckoutView({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    double subtotal = cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Checkout",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 20, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // ignore: avoid_print
                    print("هنفتح الخريطه او نخليه يكتب  العنوان ايهما افضل ");
                  },
                  child: const Icon(Icons.location_on, size: 30),
                ),
                const Text(
                  "عنوان التوصيل ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            // نفس كود العنوان هنا ...
            const SizedBox(height: 10),

            const Text(
              "قائمه المنتجات ",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return OrderCard2(
                    ordername: item.nameEn,
                    orderprice: item.price,
                    quantity: item.quantity,
                    orderpic:
                        "https://service-provider.runasp.net${item.mainImageUrl}",
                    // No edit in checkout
                  );
                },
              ),
            ),

            const SizedBox(height: 15),
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
            const SizedBox(height: 20),
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
                  // تنفيذ الطلب
                },
                child: const Text(
                  "Confirm Order",
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
