import 'package:citio/models/cart_model.dart';
import 'package:flutter/material.dart';

class CheckoutView extends StatefulWidget {
  final List<CartItem> cartItems;

  const CheckoutView({super.key, required this.cartItems});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String selectedPayment = 'card';

  @override
  Widget build(BuildContext context) {
    double subtotal = widget.cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    double deliveryFee = 2.99;
    double tax = 2.30;
    double total = subtotal + deliveryFee + tax;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "الدفع ",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟢 Delivery Address
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: -8,
                    offset: Offset(0, 6),
                    //color: MyAppColors.shadow,
                  ),
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: -8,
                    offset: Offset(0, -4),
                    //  color: MyAppColors.shadow,
                  ),
                ],
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " عنوان التسليم",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text("123 Main Street\nNew York, NY 10001"),
                      ],
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text("تعديل")),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 🟣 Order Items
            const Text(
              "العناصر المطلوبه ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: -8,
                    offset: Offset(0, 6),
                    //color: MyAppColors.shadow,
                  ),
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: -8,
                    offset: Offset(0, -4),
                    //  color: MyAppColors.shadow,
                  ),
                ],
              ),
              child: Column(
                children:
                    widget.cartItems.map((item) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                "https://service-provider.runasp.net${item.mainImageUrl}",
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.nameEn,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "X: ${item.quantity}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "LE ${(item.price * item.quantity).toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 5),

            // 🟡 Payment Method
            const Text(
              "طريقة الدفع",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: -8,
                    offset: Offset(0, 6),
                    //color: MyAppColors.shadow,
                  ),
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: -8,
                    offset: Offset(0, -4),
                    //  color: MyAppColors.shadow,
                  ),
                ],
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    value: 'card',
                    groupValue: selectedPayment,
                    onChanged:
                        (value) => setState(() => selectedPayment = value!),
                    title: const Text("بطاقة الإتمان/الخصم"),
                    secondary: const Icon(
                      Icons.credit_card,
                      color: Colors.blueAccent,
                    ),
                  ),
                  RadioListTile<String>(
                    value: 'cash',
                    groupValue: selectedPayment,
                    onChanged:
                        (value) => setState(() => selectedPayment = value!),
                    title: const Text("الدفع عند الإستلام"),
                    secondary: const Icon(
                      Icons.money,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔵 Order Summary
            const Text(
              " ملخص  الطلب ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: -8,
                    offset: Offset(0, 6),
                    //  color: MyAppColors.shadow,
                  ),
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: -8,
                    offset: Offset(0, -4),
                    //color: MyAppColors.shadow,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text("المجموع الفرعي"),
                      const Spacer(),
                      Text("LE ${subtotal.toStringAsFixed(2)}"),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Text(" الضريبة"),
                      const Spacer(),
                      Text("LE ${deliveryFee.toStringAsFixed(2)}"),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Text("التوصيل"),
                      const Spacer(),
                      Text("LE ${tax.toStringAsFixed(2)}"),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    children: [
                      const Text(
                        "المجموع",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "LE ${total.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔘 Confirm Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // تنفيذ الطلب
                },
                child: const Text(
                  "تأكيد الطلب",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
