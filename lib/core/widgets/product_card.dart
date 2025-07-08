// ignore_for_file: deprecated_member_use

import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/screens/product_details_view.dart';
import 'package:flutter/material.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
        margin: EdgeInsets.only(top: screenHeight * 0.010),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: screenHeight * 0.002,
            right: screenWidth * 0.015,
            left: screenWidth * 0.015,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 182,
                height: screenHeight * 0.16,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(screenWidth * 0.025),
                    topRight: Radius.circular(screenWidth * 0.025),
                  ),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.003),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.006),
                child: Text(
                  productName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.006),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description.isNotEmpty
                          ? description
                          : AppStrings.noDescription,
                      style: TextStyle(
                        fontSize: screenHeight * 0.01,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    if (description.length > 60)
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
                          style: TextStyle(
                            fontSize: screenHeight * 0.01,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.006),
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
