// ignore_for_file: avoid_print, use_build_context_synchronously, deprecated_member_use

import 'package:citio/models/cart_model.dart';
import 'package:citio/helper/api_make_order.dart';
import 'package:citio/models/make_order_model.dart';
import 'package:citio/screens/my_order_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:citio/helper/api_cash_payment.dart'; // أضفه مع باقي الـ imports

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
  bool showCardForm = false;

  Future<void> handleCardPayment() async {
    if (_cardDetails == null || !_cardDetails!.complete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('من فضلك ادخل بيانات البطاقة كاملة')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      Stripe.publishableKey =
          'pk_test_51RMc4kQriOXVGKDZnUxKbTjZoKuUwRxq496I0hnnhU9zVqTm2FBLJ21UBT25yldR3Oo4qW3agfQcbjqIXMsNXJao00PWV0nNbg';
      await Stripe.instance.applySettings();
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );

      paymentMethodId = paymentMethod.id;
      print("✅ paymentMethodId: $paymentMethodId");

      await sendOrder();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ تم الدفع بنجاح")));

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MyOrdersPage()),
      );
    } catch (e) {
      print("❌ Stripe Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ فشل الدفع: $e")));
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
      totalAmount: subtotal + 3 + 2,
      orderDate: now,
      status: "Pending",
      products: products,
      vendorGroups: [vendorGroup],
      payment: Payment(
        amount: subtotal + 3 + 2,
        status: "Pending",
        transactionDate: now,
      ),
    );

    if (selectedPayment == 'cash') {
      await ApiCashPaymentHelper.sendCashOrder(model);
    } else {
      await ApiMakeOrder.sendOrder(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = widget.cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    double deliveryFee = 2;
    double tax = 3;
    double total = subtotal + deliveryFee + tax;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "الدفع ",
          style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
        ),
        leading: const BackButton(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAddressSection(),
                SizedBox(height: 10.h),
                _buildItemsSection(),
                SizedBox(height: 10.h),
                _buildPaymentMethodSection(),
                SizedBox(height: 10.h),
                _buildSummarySection(subtotal, deliveryFee, tax, total),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : () async {
                              if (selectedPayment == 'card') {
                                setState(() {
                                  showCardForm = true;
                                });
                              } else {
                                setState(() => isLoading = true);
                                try {
                                  await sendOrder();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("✅ تم إرسال الطلب"),
                                    ),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MyOrdersPage(),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("❌ فشل إرسال الطلب: $e"),
                                    ),
                                  );
                                }
                                setState(() => isLoading = false);
                              }
                            },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
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
                SizedBox(height: 40.h),
              ],
            ),
          ),

          /// ✅ Card Form فوق الشاشة
          if (showCardForm)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: 24.w,
                        right: 24.w,
                        top: 40.h,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "ادخل بيانات البطاقة",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            CardFormField(
                              style: CardFormStyle(
                                backgroundColor: Colors.grey.shade100,
                                borderColor: Colors.blue,
                                textColor: Colors.black,
                                placeholderColor: Colors.grey,
                                borderRadius: 8,
                              ),
                              onCardChanged: (card) {
                                _cardDetails = card;
                              },
                            ),
                            SizedBox(height: 20.h),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : handleCardPayment,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child:
                                    isLoading
                                        ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        : Text(
                                          "ادفع الآن",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  showCardForm = false;
                                });
                              },
                              child: const Text(
                                "إلغاء",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "عنوان التسليم",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                const Text("123 Main Street\nNew York, NY 10001"),
              ],
            ),
          ),
          TextButton(onPressed: () {}, child: const Text("تعديل")),
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "العناصر المطلوبة",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            children:
                widget.cartItems.map((item) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 6.h),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            "https://service-provider.runasp.net${item.mainImageUrl}",
                            width: 60.w,
                            height: 60.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12.w),
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
                              SizedBox(height: 4.h),
                              Text(
                                "X: ${item.quantity}",
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "LE ${(item.price * item.quantity).toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "طريقة الدفع",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
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
      ],
    );
  }

  Widget _buildSummarySection(
    double subtotal,
    double deliveryFee,
    double tax,
    double total,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ملخص الطلب",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            children: [
              rowText("المجموع الفرعي", subtotal),
              rowText("الضريبة", deliveryFee),
              rowText("التوصيل", tax),
              Divider(height: 20.h),
              rowText("المجموع", total, bold: true),
            ],
          ),
        ),
      ],
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
