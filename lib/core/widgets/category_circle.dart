import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:flutter/material.dart';

class CategoryCircle extends StatelessWidget {
  final String name;
  final String imageUrl;
  final bool isSelected;
  final double radius;

  const CategoryCircle({
    super.key,
    required this.name,
    required this.imageUrl,
    this.isSelected = false,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(left: screenWidth * 0.025),
      child: Column(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: MyColors.primary,
            backgroundImage:
                imageUrl.isNotEmpty
                    ? NetworkImage('${Urls.serviceProviderbaseUrl}$imageUrl')
                    : null,
            child:
                imageUrl.isEmpty
                    ? Icon(
                      Icons.category,
                      color: Colors.white,
                      size: screenWidth * 0.06,
                    )
                    : null,
          ),
          SizedBox(height: screenHeight * 0.005),
          SizedBox(
            width: screenWidth * 0.22,
            child: Text(
              name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected ? Colors.red : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.03,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
