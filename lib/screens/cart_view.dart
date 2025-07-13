// ignore_for_file: use_build_context_synchronously

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/core/utils/variables.dart';
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
      if (discount != null) {
        setState(() {
          discountValue = discount.value;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.discountApplied)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("${AppStrings.errorOccurred} $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (error != null) {
      return Scaffold(body: Center(child: Text('Error: $error')));
    }

    if (cart == null || cart!.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text(AppStrings.cartEmpty)),
      );
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
          AppStrings.cart,
          style: TextStyle(
            fontSize: size.height * 0.025,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.03,
          vertical: size.height * 0.015,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.shoppingList,
              style: TextStyle(
                fontSize: size.height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.015),

            ...items.map((item) {
              return OrderCard(
                ordername: item.nameEn,
                orderprice: item.price,
                quantity: item.quantity,
                orderpic: "${Urls.serviceProviderbaseUrl}${item.mainImageUrl}",
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

            SizedBox(height: size.height * 0.02),

            // ✅ خانة كود الخصم
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03,
                vertical: size.height * 0.015,
              ),
              decoration: BoxDecoration(
                color: MyColors.background,
                borderRadius: BorderRadius.circular(size.width * 0.02),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: -8,
                    offset: Offset(0, 6),
                    color: MyColors.shadow,
                  ),
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: -8,
                    offset: Offset(0, -4),
                    color: MyColors.shadow,
                  ),
                ],
              ),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: applyDiscount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primary,
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                        vertical: size.height * 0.015,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(size.width * 0.02),
                      ),
                    ),
                    child: Text(
                      AppStrings.activate,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.height * 0.022,
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.02),
                  Expanded(
                    child: TextField(
                      controller: discountController,
                      decoration: InputDecoration(
                        hintText: AppStrings.enterDiscountCode,
                        hintStyle: TextStyle(fontSize: size.height * 0.018),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.03,
                          vertical: size.height * 0.015,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            size.width * 0.02,
                          ),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            size.width * 0.02,
                          ),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            size.width * 0.02,
                          ),
                          borderSide: const BorderSide(color: MyColors.primary),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: size.height * 0.025),

            // ✅ الملخص
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03,
                vertical: size.height * 0.015,
              ),
              decoration: BoxDecoration(
                color: MyColors.background,
                borderRadius: BorderRadius.circular(size.width * 0.02),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: -8,
                    offset: Offset(0, 6),
                    color: MyColors.shadow,
                  ),
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: -8,
                    offset: Offset(0, -4),
                    color: MyColors.shadow,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.orderSummary,
                    style: TextStyle(
                      fontSize: size.height * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      const Text(AppStrings.subtotal),
                      const Spacer(),
                      Text("LE ${subtotal.toStringAsFixed(2)}"),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  const Row(
                    children: [Text(AppStrings.tax), Spacer(), Text("LE 3.00")],
                  ),
                  SizedBox(height: size.height * 0.01),
                  const Row(
                    children: [
                      Text(AppStrings.delivery),
                      Spacer(),
                      Text("LE 2.00"),
                    ],
                  ),
                  if (discountValue > 0)
                    Row(
                      children: [
                        const Text(AppStrings.discountValue),
                        const Spacer(),
                        Text("- LE ${discountValue.toStringAsFixed(2)}"),
                      ],
                    ),
                  const Divider(),
                  Row(
                    children: [
                      Text(
                        AppStrings.total,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.height * 0.027,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "LE ${total.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.height * 0.027,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: size.height * 0.03),

            Container(
              width: double.infinity,
              height: size.height * 0.07,
              decoration: BoxDecoration(
                color: MyColors.primary,
                borderRadius: BorderRadius.circular(size.width * 0.01),
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
                  AppStrings.pay,
                  style: TextStyle(
                    fontSize: size.height * 0.03,
                    fontWeight: FontWeight.bold,
                    color: MyColors.background,
                  ),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.02),
          ],
        ),
      ),
    );
  }
}
