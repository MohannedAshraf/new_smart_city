import 'package:citio/core/utils/mycolors.dart';
import 'package:flutter/material.dart';

class ServiceContainer extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> content;

  const ServiceContainer({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.025,
              screenWidth * 0.04,
              screenWidth * 0.04,
              screenWidth * 0.03,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: MyColors.white,
                  radius: screenWidth * 0.035,
                  child: Icon(
                    icon,
                    color: MyColors.primary,
                    size: screenWidth * 0.07,
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                  child: Text(
                    title, // يمكنك استبداله لاحقًا بـ AppStrings.title
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.05,
              0,
              screenWidth * 0.05,
              screenWidth * 0.05,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content,
            ),
          ),
        ],
      ),
    );
  }
}
