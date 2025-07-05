// ignore_for_file: use_build_context_synchronously

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/variables.dart';
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
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('العربة فارغة')),
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
          "العربة ",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 10.0.w, bottom: 12.h, right: 12.w),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "قائمة التسوق ",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),

              ...items.map((item) {
                return OrderCard(
                  ordername: item.nameEn,
                  orderprice: item.price,
                  quantity: item.quantity,
                  orderpic:
                      "${Urls.serviceProviderbaseUrl}${item.mainImageUrl}",
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

              SizedBox(height: 20.h),

              // ✅ خانة كود الخصم
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: MyColors.background,
                  borderRadius: BorderRadius.circular(10),
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
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'تفعيل',
                        style: TextStyle(color: Colors.white, fontSize: 20.sp),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        controller: discountController,
                        decoration: InputDecoration(
                          hintText: 'ادخل كود الخصم',
                          hintStyle: TextStyle(fontSize: 14.sp),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: const BorderSide(
                              color: MyColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // ✅ الملخص
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: MyColors.background,
                  borderRadius: BorderRadius.circular(10.r),
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
                    Row(
                      children: [
                        Text(
                          "ملخص  الطلب",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
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
                    SizedBox(height: 6.h),
                    const Row(
                      children: [Text("التوصيل"), Spacer(), Text("LE 2.00")],
                    ),
                    SizedBox(height: 6.h),
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
                            fontSize: 20.sp,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "LE ${total.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25.h),

              Container(
                width: double.infinity,
                height: 55.h,
                decoration: BoxDecoration(
                  color: MyColors.primary,
                  borderRadius: BorderRadius.circular(4.r),
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
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      color: MyColors.background,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
