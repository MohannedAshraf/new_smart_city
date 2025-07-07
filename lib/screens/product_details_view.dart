// ignore_for_file: use_build_context_synchronously

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
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
  late Future<ProductDetails> _productDetailsFuture;

  Color buttonColor = MyColors.primary;
  String buttonText = AppStrings.addToCart;
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
        buttonColor = MyColors.primary;
        buttonText = AppStrings.addToCart;
        buttonIcon = Icons.add_shopping_cart;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppStrings.productDetails),
      ),
      floatingActionButton: Container(
        width: width * 0.18,
        height: height * 0.07,
        decoration: const BoxDecoration(
          color: MyColors.primary,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartView()),
            );
          },
          icon: Icon(
            Icons.shopping_bag_sharp,
            color: Colors.white,
            size: width * 0.07,
          ),
        ),
      ),
      body: FutureBuilder<ProductDetails>(
        future: _productDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${AppStrings.errorOccurred}: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text(AppStrings.notFound));
          }

          final product = snapshot.data!;
          final hasDiscount = product.discountPercentage > 0;
          final discountedPrice = product.price;
          final oldPrice =
              hasDiscount
                  ? (product.price * 100) / (100 - product.discountPercentage)
                  : product.price;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.01),
                ClipRRect(
                  borderRadius: BorderRadius.circular(width * 0.05),
                  child: Image.network(
                    '${ProductDetailsService.imageBaseUrl}${product.mainImageUrl}',
                    height: height * 0.3,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  product.nameAr,
                  style: TextStyle(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.01),
                Row(
                  children: [
                    Text(
                      product.vendorBusinessName,
                      style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.star, color: Colors.orange, size: width * 0.05),
                    SizedBox(width: width * 0.015),
                    Text(
                      "${product.rating}",
                      style: TextStyle(fontSize: width * 0.035),
                    ),
                    Text(
                      " (120 ${AppStrings.ratingText1})",
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.01),
                Row(
                  children: [
                    Text(
                      "LE ${discountedPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: width * 0.05,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (hasDiscount) ...[
                      SizedBox(width: width * 0.03),
                      Text(
                        "LE${oldPrice.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(width: width * 0.02),
                      Text(
                        "${product.discountPercentage.toStringAsFixed(0)}% OFF",
                        style: TextStyle(
                          fontSize: width * 0.035,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: height * 0.01),
                Text(
                  AppStrings.description,
                  style: TextStyle(
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: width * 0.04,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: height * 0.025),

                /// ✅ العداد + زر الإضافة
                Row(
                  children: [
                    /// ✅ العداد
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          _quantityButton(
                            width,
                            height,
                            icon: Icons.remove,
                            onPressed: () {
                              if (itemCount > 1) {
                                setState(() {
                                  itemCount--;
                                });
                              }
                            },
                          ),
                          Text(
                            '$itemCount',
                            style: TextStyle(
                              fontSize: width * 0.030,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _quantityButton(
                            width,
                            height,
                            icon: Icons.add,
                            onPressed: () {
                              if (itemCount < 10) {
                                setState(() {
                                  itemCount++;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    /// ✅ زر Add to Cart
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            await AddToCartService.addToCart(
                              productId: product.id,
                              quantity: itemCount,
                            );
                            updateButton(
                              Colors.green,
                              AppStrings.added,
                              Icons.check,
                            );
                          } catch (e) {
                            updateButton(
                              Colors.red,
                              AppStrings.failed,
                              Icons.error,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.018,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(width * 0.025),
                          ),
                        ),
                        icon: Icon(buttonIcon, color: Colors.white),
                        label: Text(
                          buttonText,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.04,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height * 0.04),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _quantityButton(
    double width,
    double height, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.02),
      width: width * 0.1,
      height: width * 0.1,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: MyColors.primary,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: width * 0.05),
        onPressed: onPressed,
      ),
    );
  }
}
