import 'package:city/core/utils/assets_image.dart';
import 'package:city/core/utils/mycolors.dart';
import 'package:city/screens/order_card2.dart';
import 'package:flutter/material.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_ios),
        centerTitle: true,
        title: const Text(
          "Checkout",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [Icon(Icons.map), Text("Delivery Address")]),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.64,
                  height: MediaQuery.of(context).size.width * 0.2,
                  decoration: BoxDecoration(
                    color: MyAppColors.background,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Address"),
                        Text("Type address here \nor pick from map"),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.22,
                  height: MediaQuery.of(context).size.width * 0.2,
                  decoration: BoxDecoration(
                    color: MyAppColors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.map, color: MyAppColors.background),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "    Shopping List",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),

            const OrderCard2(
              image: MyAssetsImage.burger,
              ordername: "  Women’s Casual Wear  ",
              orderrate: "  4.8  ",
              orderprice: "LE 34.00",
              orderoldprice: "LE 64.00",
            ),
            const OrderCard2(
              image: MyAssetsImage.nescalop,
              ordername: "Men’s Jacket",
              orderrate: "  4.7",
              orderprice: "LE 45.00",
              orderoldprice: "LE 67.00",
            ),
            const SizedBox(height: 50),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        ' عملية ناجحه \n \n \n \n  طلبك سيصل بعد يومين والدفع عند الاستلام ',
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text(
                  "Place Order",
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
