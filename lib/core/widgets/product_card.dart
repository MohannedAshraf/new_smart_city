import 'package:citio/screens/product_details_view.dart';
import 'package:flutter/material.dart';
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
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
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
          padding: const EdgeInsets.only(bottom: 5.0, right: 5, left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 182,
                height: 130,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
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
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  productName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description.isNotEmpty ? description : 'لا يوجد وصف',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                        child: const Text(
                          '...',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),

              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
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
              // const SizedBox(height: 10),
              // Padding(
              //   padding: const EdgeInsets.only(right: 60),
              //   child: RatingBarIndicator(
              //     rating: rating,
              //     itemBuilder:
              //         (context, index) =>
              //             const Icon(Icons.star, color: Colors.amber),
              //     itemCount: 5,
              //     itemSize: 20.0,
              //     direction: Axis.horizontal,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
