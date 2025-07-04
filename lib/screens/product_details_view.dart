// ignore_for_file: use_build_context_synchronously

import 'package:citio/helper/api_add_to_cart.dart';
import 'package:citio/helper/api_product_details.dart';
import 'package:citio/models/product_details_model.dart';
import 'package:citio/screens/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key, required this.productId});
  final int productId;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int itemCount = 1;
  late Future<ProductDetails> _productDetailsFuture;

  Color buttonColor = Colors.blue;
  String buttonText = "أضف إلي العربة";
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
        buttonText = "أضف إلي  العربة";
        buttonIcon = Icons.add_shopping_cart;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("تفاصيل المنتج ")),
      floatingActionButton: Container(
        width: 70.w,
        height: 50.h,
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
          icon: Icon(
            Icons.shopping_bag_sharp,
            color: Colors.white,
            size: 30.sp,
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
          final hasDiscount = product.discountPercentage > 0;
          final discountedPrice =
              hasDiscount
                  ? product.price
                  : product.price; // ممكن تعدلها لو السعر متغير
          final oldPrice =
              hasDiscount
                  ? (product.price * 100) /
                      (100 -
                          product
                              .discountPercentage) // الحساب العكسي للسعر قبل الخصم
                  : product.price;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.network(
                    '${ProductDetailsService.imageBaseUrl}${product.mainImageUrl}',
                    height: 250.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  product.nameAr,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text(
                      product.vendorBusinessName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.star, color: Colors.orange, size: 20.sp),
                    SizedBox(width: 5.w),
                    Text(
                      "${product.rating}",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    Text(
                      " (120 تقييم)",
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text(
                      "LE ${discountedPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (hasDiscount) ...[
                      SizedBox(width: 15.w),
                      Text(
                        "LE${oldPrice.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "${product.discountPercentage.toStringAsFixed(0)}% OFF",
                        style: TextStyle(fontSize: 14.sp, color: Colors.red),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  "الوصف",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  product.description,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                ),
                SizedBox(height: 20.h),

                /// ✅ عدد المنتجات + زر الإضافة
                Row(
                  children: [
                    /// ✅ العداد
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 5.h,
                              horizontal: 5.w,
                            ),
                            width: 40.w,
                            height: 40.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueAccent,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
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
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 5.h,
                              horizontal: 5.w,
                            ),
                            width: 40.w,
                            height: 40.h,
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
                            updateButton(Colors.green, "تم", Icons.check);
                          } catch (e) {
                            updateButton(Colors.red, "فشل", Icons.error);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 14.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
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

                SizedBox(height: 30.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
