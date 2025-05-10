import 'package:citio/screens/product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 182,
              height: 140,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(
                  image,
                  fit: BoxFit.fitHeight,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      productName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "المالك",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.start, // لضمان محاذاة العناصر بداية السطر
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description.isNotEmpty
                        ? (description.length > 13
                            ? '${description.substring(0, 13)}...'
                            : description)
                        : 'لا يوجد وصف',
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  if (description.length > 13)
                    InkWell(
                      onTap: () {
                        // ignore: avoid_print
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
                        'عرض المزيد',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ), // يمكنك تغيير اللون حسب الحاجة
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(price),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 60),
              child: RatingBarIndicator(
                rating: rating,
                itemBuilder:
                    (context, index) =>
                        const Icon(Icons.star, color: Colors.amber),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
