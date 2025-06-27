// ignore_for_file: avoid_print, use_build_context_synchronously, unused_import

import 'package:citio/models/cart_model.dart';

import 'package:citio/helper/api_make_order.dart';
import 'package:citio/models/make_order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutView extends StatefulWidget {
  final List<CartItem> cartItems;

  const CheckoutView({super.key, required this.cartItems});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String selectedPayment = 'card';
  CardFieldInputDetails? _cardDetails;
  String? paymentMethodId;
  bool isLoading = false;
  bool showCardField = false;

  Future<void> handleCardPayment() async {
    if (_cardDetails == null || !_cardDetails!.complete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('من فضلك ادخل بيانات البطاقة كاملة')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );

      paymentMethodId = paymentMethod.id;
      print("✅ paymentMethodId: $paymentMethodId");

      await sendOrder();
    } catch (e) {
      print("❌ Stripe Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("حدث خطأ: $e")));
    }

    setState(() => isLoading = false);
  }

  Future<void> sendOrder() async {
    double subtotal = widget.cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    final products =
        widget.cartItems
            .map(
              (e) => Makeorder(
                productId: e.productId,
                nameEn: e.nameEn,
                nameAr: e.nameAr,
                price: e.price,
                quantity: e.quantity,
              ),
            )
            .toList();

    final vendorGroup = VendorGroup(
      businessName: "Vendor Group Name",
      totalPrice: subtotal,
      itemCount: widget.cartItems.length,
      items: products,
    );

    final now = DateTime.now().toIso8601String();

    final model = MakeOrderModel(
      paymentMethodId: paymentMethodId ?? "",
      id: 0,
      totalAmount: subtotal + 2.99 + 2.30,
      orderDate: now,
      status: "Pending",
      products: products,
      vendorGroups: [vendorGroup],
      payment: Payment(
        amount: subtotal + 2.99 + 2.30,
        status: "Pending",
        transactionDate: now,
      ),
    );

    await ApiMakeOrder.sendOrder(model);
  }

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
            // 🟢 العنوان
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Row(
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

            const Text(
              "العناصر المطلوبه ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
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
                                    style: const TextStyle(fontSize: 15),
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

            const SizedBox(height: 10),

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
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    value: 'card',
                    groupValue: selectedPayment,
                    onChanged: (value) {
                      setState(() {
                        selectedPayment = value!;
                      });
                    },
                    title: const Text("بطاقة الإتمان/الخصم"),
                    secondary: const Icon(Icons.credit_card),
                  ),
                  RadioListTile<String>(
                    value: 'cash',
                    groupValue: selectedPayment,
                    onChanged: (value) {
                      setState(() {
                        selectedPayment = value!;
                      });
                    },
                    title: const Text("الدفع عند الإستلام"),
                    secondary: const Icon(Icons.money),
                  ),
                ],
              ),
            ),

            if (showCardField)
              Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "ادخل بيانات البطاقة",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  CardField(
                    onCardChanged: (card) {
                      _cardDetails = card;
                    },
                  ),
                ],
              ),

            const SizedBox(height: 20),

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
              ),
              child: Column(
                children: [
                  rowText("المجموع الفرعي", subtotal),
                  rowText("الضريبة", deliveryFee),
                  rowText("التوصيل", tax),
                  const Divider(height: 20),
                  rowText("المجموع", total, bold: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : () async {
                          if (selectedPayment == 'card') {
                            setState(() {
                              showCardField = true;
                            });
                            if (_cardDetails != null &&
                                _cardDetails!.complete) {
                              await handleCardPayment();
                            }
                          } else {
                            await sendOrder();
                          }
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
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

  Widget rowText(String title, double value, {bool bold = false}) {
    return Row(
      children: [
        Text(
          title,
          style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null,
        ),
        const Spacer(),
        Text(
          "LE ${value.toStringAsFixed(2)}",
          style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null,
        ),
      ],
    );
  }
}
