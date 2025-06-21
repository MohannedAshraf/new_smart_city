// ignore_for_file: use_build_context_synchronously

import 'package:citio/helper/api_add_to_cart.dart';
import 'package:citio/helper/api_product_details.dart';
import 'package:citio/models/product_details_model.dart';
import 'package:citio/screens/cart_view.dart';
import 'package:flutter/material.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key, required this.productId});
  final int productId;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int itemCount = 1;
  String selectedSize = 'Regular';
  late Future<ProductDetails> _productDetailsFuture;

  Color buttonColor = Colors.blue;
  String buttonText = "Add to Cart";
  IconData buttonIcon = Icons.add_shopping_cart;

  @override
  void initState() {
    super.initState();
    _productDetailsFuture = ProductDetailsService.fetchProductDetails(
      widget.productId,
    );
  }

  void updateButton(Color color, String text, IconData icon) {
    setState(() {
      buttonColor = color;
      buttonText = text;
      buttonIcon = icon;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        buttonColor = Colors.blue;
        buttonText = "Add to Cart";
        buttonIcon = Icons.add_shopping_cart;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Product Details")),
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
          final oldPrice = product.price + 3;
          final discount = ((1 - product.price / oldPrice) * 100).round();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    '${ProductDetailsService.imageBaseUrl}${product.mainImageUrl}',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  product.nameAr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      product.vendorBusinessName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.star, color: Colors.orange, size: 20),
                    const SizedBox(width: 5),
                    const Text("4.8", style: TextStyle(fontSize: 14)),
                    const Text(
                      " (120 reviews)",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "LE ${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      "LE${oldPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "$discount% OFF",
                      style: const TextStyle(fontSize: 14, color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Description",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  product.description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 20),

                /// ✅ عدد المنتجات + زر الإضافة
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// ✅ Custom Item Counter
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(5),
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueAccent,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.remove, color: Colors.white),
                            onPressed: () {
                              if (itemCount > 1) {
                                setState(() {
                                  itemCount--;
                                });
                              }
                            },
                          ),
                        ),
                        Text(
                          '$itemCount',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueAccent,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: () {
                              if (itemCount < 10) {
                                setState(() {
                                  itemCount++;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    /// ✅ زر Add to Cart بحالة متغيرة
                    Container(
                      width: 250,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            await AddToCartService.addToCart(
                              productId: product.id,
                              quantity: itemCount,
                            );
                            updateButton(Colors.green, "Added", Icons.check);
                          } catch (e) {
                            updateButton(Colors.red, "Failed", Icons.error);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: Icon(buttonIcon, color: Colors.white),
                        label: Text(
                          buttonText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
