// ignore_for_file: use_build_context_synchronously

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/helper/api_cart.dart';
import 'package:citio/helper/api_discount.dart';
import 'package:citio/helper/api_edit_cart.dart';
import 'package:citio/models/cart_model.dart';
import 'package:citio/screens/checkout_view.dart';
import 'package:citio/screens/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      return const Scaffold(body: Center(child: Text('العربة فارغة')));
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
        title: Text(
          "العربة ",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.025,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.025,
          bottom: MediaQuery.of(context).size.height * 0.015,
          right: MediaQuery.of(context).size.width * 0.03,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 5.0.w,
            vertical: MediaQuery.of(context).size.height * 0.0125,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "قائمة التسوق ",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.0125),

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

              SizedBox(height: MediaQuery.of(context).size.height * 0.0250),

              // ✅ خانة كود الخصم
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.025,
                  vertical: MediaQuery.of(context).size.height * 0.015,
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
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04,
                          vertical: MediaQuery.of(context).size.height * 0.015,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.02,
                          ),
                        ),
                      ),
                      child: Text(
                        'تفعيل',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.height * 0.025,
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                    Expanded(
                      child: TextField(
                        controller: discountController,
                        decoration: InputDecoration(
                          hintText: 'ادخل كود الخصم',
                          hintStyle: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.0175,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.03,
                            vertical:
                                MediaQuery.of(context).size.height * 0.0125,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.02,
                            ),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.02,
                            ),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.02,
                            ),
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

              SizedBox(height: MediaQuery.of(context).size.height * 0.0250),

              // ✅ الملخص
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.025,
                  vertical: MediaQuery.of(context).size.height * 0.0125,
                ),
                decoration: BoxDecoration(
                  color: MyAppColors.background,
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.025,
                  ),
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
                    Row(
                      children: [
                        Text(
                          "ملخص  الطلب",
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.01875,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.0075,
                    ),
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.0075,
                    ),
                    const Row(
                      children: [Text("التوصيل"), Spacer(), Text("LE 2.00")],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.0075,
                    ),
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
                        Text(
                          "المجموع  ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "LE ${total.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.03125),

              // ✅ زر Checkout
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.06875,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.01,
                  ),
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
                  child: Text(
                    "الدفع",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.03125,
                      fontWeight: FontWeight.bold,
                      color: MyAppColors.background,
                    ),
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.0250),
            ],
          ),
        ),
      ),
    );
  }
}
