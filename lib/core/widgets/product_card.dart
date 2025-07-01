import 'package:citio/screens/product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.image,
    required this.price,
    required this.rating,
    required this.description,
    required this.productName,
    required this.productId,
  });

  final String image;
  final String price;
  final double rating;
  final String description;
  final String productName;
  final int productId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsView(productId: productId),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: 5.0.h, right: 5.w, left: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 182,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                  ),
                  child: Image.network(
                    image,
                    fit: BoxFit.fitHeight,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                        fit: BoxFit.fitHeight,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.h),
                child: Text(
                  productName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description.isNotEmpty ? description : 'لا يوجد وصف',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2, // عرض سطرين فقط
                    ),
                    if (description.length >
                        60) // شرط تقريبي لطول نص يحتاج لأكثر من سطرين
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      ProductDetailsView(productId: productId),
                            ),
                          );
                        },
                        child: Text(
                          '...',
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),

              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.h),
                child: Row(
                  children: [
                    Text("$rating"),
                    const Icon(Icons.star, color: Colors.amber),

                    const Spacer(),
                    Text(
                      price,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
