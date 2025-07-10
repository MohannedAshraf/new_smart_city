// ignore_for_file: avoid_print, use_build_context_synchronously, deprecated_member_use

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/models/cart_model.dart';
import 'package:citio/helper/api_make_order.dart';
import 'package:citio/models/make_order_model.dart';
import 'package:citio/screens/my_order_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:citio/helper/api_cash_payment.dart';
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
  bool showCardForm = false;
  bool isEditingAddress = false;

  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAddress = prefs.getString('fullAddress') ?? "";
    setState(() {
      addressController.text = savedAddress;
    });
  }

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
          "pk_test_51RMc4kQriOXVGKDZnUxKbTjZoKuUwRxq496I0hnnhU9zVqTm2FBLJ21UBT25yldR3Oo4qW3agfQcbjqIXMsNXJao00PWV0nNbg"; // 🔐 مفتاحك هنا
      await Stripe.instance.applySettings();

      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );

      paymentMethodId = paymentMethod.id;

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
    final size = MediaQuery.of(context).size;
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
          AppStrings.checkout,
          style: TextStyle(
            fontSize: size.height * 0.035,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const BackButton(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(size.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAddressSection(size),
                SizedBox(height: size.height * 0.02),
                _buildItemsSection(size),
                SizedBox(height: size.height * 0.02),
                _buildPaymentMethodSection(size),
                SizedBox(height: size.height * 0.02),
                _buildSummarySection(size, subtotal, deliveryFee, tax, total),
                SizedBox(height: size.height * 0.03),
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.07,
                  child: ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : () async {
                              if (selectedPayment == 'card') {
                                setState(() => showCardForm = true);
                              } else {
                                setState(() => isLoading = true);
                                try {
                                  await sendOrder();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(AppStrings.paymentSuccess),
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
                                      content: Text(
                                        "${AppStrings.paymentFailed} $e",
                                      ),
                                    ),
                                  );
                                }
                                setState(() => isLoading = false);
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(size.width * 0.025),
                      ),
                    ),
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              AppStrings.confirmOrder,
                              style: TextStyle(
                                fontSize: size.height * 0.022,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
              ],
            ),
          ),
          if (showCardForm) _buildCardFormOverlay(size),
        ],
      ),
    );
  }

  Widget _buildAddressSection(Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size.width * 0.03),
        color: Colors.white,
      ),
      child:
          isEditingAddress
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.editAddress,
                    style: TextStyle(
                      fontSize: size.height * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                        vertical: size.height * 0.015,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(size.width * 0.02),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.015),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              () => setState(() => isEditingAddress = false),
                          child: const Text(AppStrings.cancel),
                        ),
                      ),
                      SizedBox(width: size.width * 0.03),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              () => setState(() => isEditingAddress = false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.primary,
                          ),
                          child: const Text(
                            AppStrings.save,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
              : Row(
                children: [
                  const Icon(Icons.location_on_outlined),
                  SizedBox(width: size.width * 0.02),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.deliveryAddress,
                          style: TextStyle(
                            fontSize: size.height * 0.018,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: size.height * 0.005),
                        Text(addressController.text),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => isEditingAddress = true),
                    style: TextButton.styleFrom(
                      foregroundColor: MyColors.primary,
                    ),
                    child: const Text(AppStrings.edit),
                  ),
                ],
              ),
    );
  }

  Widget _buildItemsSection(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.requestedItems,
          style: TextStyle(
            fontSize: size.height * 0.025,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Container(
          padding: EdgeInsets.all(size.width * 0.03),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size.width * 0.025),
          ),
          child: Column(
            children:
                widget.cartItems.map((item) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: size.height * 0.007),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            size.width * 0.02,
                          ),
                          child: Image.network(
                            "${Urls.serviceProviderbaseUrl}${item.mainImageUrl}",
                            width: size.width * 0.15,
                            height: size.width * 0.15,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
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
                              SizedBox(height: size.height * 0.005),
                              Text(
                                "${AppStrings.quantity}${item.quantity}",
                                style: TextStyle(fontSize: size.height * 0.018),
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

  Widget _buildPaymentMethodSection(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.paymentMethod,
          style: TextStyle(
            fontSize: size.height * 0.025,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Container(
          padding: EdgeInsets.all(size.width * 0.03),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size.width * 0.025),
          ),
          child: Column(
            children: [
              RadioListTile<String>(
                value: 'card',
                groupValue: selectedPayment,
                onChanged: (value) => setState(() => selectedPayment = value!),
                title: const Text(AppStrings.creditCard),
                secondary: const Icon(Icons.credit_card),
                activeColor: MyColors.primary,
              ),
              RadioListTile<String>(
                value: 'cash',
                groupValue: selectedPayment,
                onChanged: (value) => setState(() => selectedPayment = value!),
                title: const Text(AppStrings.cashOnDelivery),
                secondary: const Icon(Icons.money),
                activeColor: MyColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySection(
    Size size,
    double subtotal,
    double deliveryFee,
    double tax,
    double total,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.orderSummary,
          style: TextStyle(
            fontSize: size.height * 0.025,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Container(
          padding: EdgeInsets.all(size.width * 0.03),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size.width * 0.025),
          ),
          child: Column(
            children: [
              rowText(AppStrings.subTotal, subtotal),
              rowText(AppStrings.tax, deliveryFee),
              rowText(AppStrings.delivery, tax),
              Divider(height: size.height * 0.02),
              rowText(AppStrings.total, total, bold: true),
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

  Widget _buildCardFormOverlay(Size size) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: size.width * 0.06,
                right: size.width * 0.06,
                top: size.height * 0.05,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Container(
                padding: EdgeInsets.all(size.width * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size.width * 0.04),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.enterCardInfo,
                      style: TextStyle(
                        fontSize: size.height * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.025),
                    CardFormField(
                      style: CardFormStyle(
                        backgroundColor: Colors.grey.shade100,
                        borderColor: MyColors.primary,
                        textColor: Colors.black,
                        placeholderColor: Colors.grey,
                        borderRadius: 8,
                      ),
                      onCardChanged: (card) {
                        _cardDetails = card;
                      },
                    ),
                    SizedBox(height: size.height * 0.025),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : handleCardPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.primary,
                        ),
                        child:
                            isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : Text(
                                  AppStrings.payNow,
                                  style: TextStyle(
                                    fontSize: size.height * 0.022,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    TextButton(
                      onPressed: () => setState(() => showCardForm = false),
                      child: const Text(
                        AppStrings.cancel,
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
    );
  }
}
