import 'package:flutter/material.dart';

class Categorysubcategory extends StatelessWidget {
  const Categorysubcategory({
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
    // ضفناهم كلهم في List
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

    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(category),
          SizedBox(height: MediaQuery.of(context).size.height * 0.0125),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  subcategories
                      .where((sub) => sub != null) // استبعدنا الـ null
                      .map(
                        (sub) => Container(
                          width: MediaQuery.of(context).size.width * 0.025,
                          height: MediaQuery.of(context).size.height * 0.075,
                          margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.01,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.02,
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(sub!), // آمِن لأننا فلترنا null فوق
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
