import 'package:city/core/utils/assets_image.dart';
import 'package:city/core/utils/mycolors.dart';
import 'package:city/screens/checkout_view.dart';
import 'package:city/screens/order_card.dart';
import 'package:flutter/material.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

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
            const OrderCard(
              image: MyAssetsImage.burger,
              ordername: "  Women’s Casual Wear  ",
              orderrate: "  4.8",
              orderprice: "  LE 34.00  ",
              orderoldprice: " LE 64.00",
            ),
            const OrderCard(
              image: MyAssetsImage.nescalop,
              ordername: "Men’s Jacket",
              orderrate: "4.7",
              orderprice: "LE 45.00  ",
              orderoldprice: "LE 67.00",
            ),
            const Text(
              style: TextStyle(color: MyAppColors.gray),
              "_______________________________________________________",
            ),
            const Row(
              children: [Text("Subtotal"), Spacer(), Text(" LE 79.00 ")],
            ),
            const Row(
              children: [Text("Tax and Fees"), Spacer(), Text(" LE 3.00 ")],
            ),
            const Row(
              children: [Text("Delivery Fee"), Spacer(), Text("LE 2.00")],
            ),
            const Text(
              style: TextStyle(color: MyAppColors.gray),
              "_______________________________________________________",
            ),
            const Row(
              children: [Text("Order Total"), Spacer(), Text("LE 84.00")],
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
      ),
    );
  }
}
