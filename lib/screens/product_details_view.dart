// ignore_for_file: use_build_context_synchronously

import 'package:citio/helper/api_add_to_cart.dart';
import 'package:citio/helper/api_product_details.dart';
import 'package:citio/models/product_details_model.dart';
import 'package:citio/screens/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:item_count_number_button/item_count_number_button.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key, required this.productId});
  final int productId;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int itemCount = 1;
  late Future<ProductDetails> _productDetailsFuture;
  double currentPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _productDetailsFuture = ProductDetailsService.fetchProductDetails(
      widget.productId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("تفاصيل المنتج")),
      floatingActionButton: Container(
        width: 70,
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartView()),
            );
          },
          icon: const Icon(
            Icons.shopping_bag_sharp,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      body: FutureBuilder<ProductDetails>(
        future: _productDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("حدث خطأ: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("لم يتم العثور على المنتج"));
          }

          final product = snapshot.data!;
          currentPrice = product.price * itemCount;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    '${ProductDetailsService.imageBaseUrl}${product.mainImageUrl}',
                    height: MediaQuery.of(context).size.height * 0.40,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                        height: MediaQuery.of(context).size.height * 0.40,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),

                /// ✅ الاسم + البائع
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.nameAr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      product.vendorBusinessName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                /// ✅ الوصف
                Text(product.description, style: const TextStyle(fontSize: 14)),

                const SizedBox(height: 15),

                /// ✅ السعر + عدد المنتجات
                Row(
                  children: [
                    Text(
                      "${(product.price * itemCount).toStringAsFixed(2)} ج",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    ItemCount(
                      color: Colors.red,
                      initialValue: itemCount,
                      step: 1,
                      minValue: 1,
                      maxValue: 10,
                      decimalPlaces: 0,
                      onChanged: (value) {
                        setState(() {
                          itemCount = value.toInt();
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// ✅ زر الإضافة إلى العربة
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.064,
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.red,
                  ),
                  child: TextButton(
                    onPressed: () async {
                      try {
                        await AddToCartService.addToCart(
                          productId: product.id,
                          quantity: itemCount,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'تم إضافة $itemCount منتج إلى العربة بنجاح!',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('خطأ في الإضافة: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "أضف إلي العربة",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
