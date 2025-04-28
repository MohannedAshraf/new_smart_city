import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.image,
    required this.price,
    required this.rating,
    required this.description,
  });

  final String image;
  final String price;
  final double rating;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 175,
            height: 150,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.asset(image, fit: BoxFit.fitHeight),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              children: [
                Text("اسم المنتج "),
                SizedBox(width: 40),
                Text("اسم المالك "),
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
                  description.length > 15
                      ? '${description.substring(0, 15)}...'
                      : description,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                if (description.length > 15)
                  InkWell(
                    onTap: () {
                      // ignore: avoid_print
                      print("clik");
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
    );
  }
}
