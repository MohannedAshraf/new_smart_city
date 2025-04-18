import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.image,
    required this.price,
    required this.rating,
  });
  final String image;
  final String price;
  final double rating;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 165,
            height: 100,
            child: Image.asset(image, fit: BoxFit.contain),
          ),
          const SizedBox(height: 10),
          const Text("اسم المنتج "),
          const Text(" الوصف "),
          Text(price),
          const SizedBox(height: 10),
          RatingBarIndicator(
            rating: rating, // هنا بتحط القيمة اللي جاية من الـ API
            itemBuilder:
                (context, index) => const Icon(Icons.star, color: Colors.amber),
            itemCount: 5,
            itemSize: 30.0,
            direction: Axis.horizontal,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
