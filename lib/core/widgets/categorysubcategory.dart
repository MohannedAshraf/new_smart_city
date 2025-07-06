import 'package:flutter/material.dart';

class CategorySubcategory extends StatelessWidget {
  const CategorySubcategory({
    super.key,
    required this.category,
    this.subcat,
    this.subcat1,
    this.subcat2,
    this.subcat3,
    this.subcat4,
    this.subcat5,
    this.subcat6,
    this.subcat7,
    this.subcat8,
    this.subcat9,
  });

  final String category;
  final String? subcat;
  final String? subcat1;
  final String? subcat2;
  final String? subcat3;
  final String? subcat4;
  final String? subcat5;
  final String? subcat6;
  final String? subcat7;
  final String? subcat8;
  final String? subcat9;

  @override
  Widget build(BuildContext context) {
    final List<String?> subcategories = [
      subcat,
      subcat1,
      subcat2,
      subcat3,
      subcat4,
      subcat5,
      subcat6,
      subcat7,
      subcat8,
      subcat9,
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            child: Text(
              category,
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  subcategories
                      .where((sub) => sub != null)
                      .map(
                        (sub) => Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01,
                          ),
                          child: SizedBox(
                            width: screenWidth * 0.28,
                            height: screenHeight * 0.06,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.grey.shade200,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    screenWidth * 0.025,
                                  ),
                                  side: const BorderSide(color: Colors.grey),
                                ),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('تم الضغط على: $sub'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Text(
                                sub!,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
