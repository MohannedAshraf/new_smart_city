// ignore_for_file: use_build_context_synchronously

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/helper/api_cart.dart';
import 'package:citio/helper/api_discount.dart';
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
  final TextEditingController discountController = TextEditingController();
  double discountValue = 0.0;

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

  Future<void> applyDiscount() async {
    final code = discountController.text.trim();
    if (code.isEmpty) return;

    try {
      final discount = await ApiDiscount.getDiscount(code);
      if (discount != null && discount.isSuccess) {
        setState(() {
          discountValue = discount.value;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("تم تفعيل الخصم بنجاح")));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("كود الخصم غير صالح")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("حدث خطأ: $e")));
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
    double total = subtotal + 3 + 2 - discountValue;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "العربة ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 10.0, bottom: 12, right: 12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "قائمة التسوق ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              ...items.map((item) {
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
                      item.quantity = newQty;
                    });
                  },
                  onDelete: loadCart,
                );
              }),

              const SizedBox(height: 20),

              // ✅ خانة كود الخصم
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: MyAppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      spreadRadius: -8,
                      offset: Offset(0, 6),
                      color: MyAppColors.shadow,
                    ),
                    BoxShadow(
                      blurRadius: 4,
                      spreadRadius: -8,
                      offset: Offset(0, -4),
                      color: MyAppColors.shadow,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: applyDiscount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'تفعيل',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: discountController,
                        decoration: InputDecoration(
                          hintText: 'ادخل كود الخصم',
                          hintStyle: const TextStyle(fontSize: 14),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ✅ الملخص
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: MyAppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      spreadRadius: -8,
                      offset: Offset(0, 6),
                      color: MyAppColors.shadow,
                    ),
                    BoxShadow(
                      blurRadius: 4,
                      spreadRadius: -8,
                      offset: Offset(0, -4),
                      color: MyAppColors.shadow,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          "ملخص  الطلب",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text("المجموع الفرعي "),
                        const Spacer(),
                        Text("LE ${subtotal.toStringAsFixed(2)}"),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      children: [Text("الضريبة"), Spacer(), Text("LE 3.00")],
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      children: [Text("التوصيل"), Spacer(), Text("LE 2.00")],
                    ),
                    const SizedBox(height: 6),
                    if (discountValue > 0)
                      Row(
                        children: [
                          const Text("قيمة الخصم"),
                          const Spacer(),
                          Text("- LE ${discountValue.toStringAsFixed(2)}"),
                        ],
                      ),
                    const Divider(),
                    Row(
                      children: [
                        const Text(
                          "المجموع  ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "LE ${total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ✅ زر Checkout
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
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
                    "الدفع",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: MyAppColors.background,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
