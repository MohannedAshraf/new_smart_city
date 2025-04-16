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
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: Image.asset(image, fit: BoxFit.cover),
          ),
          const SizedBox(height: 10),
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
        ],
      ),
    );
  }
}
