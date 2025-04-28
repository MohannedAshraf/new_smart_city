import 'package:flutter/material.dart';

class CategoryCircle extends StatelessWidget {
  final String circlename;
  final bool isSelected;

  const CategoryCircle({
    super.key,
    required this.circlename,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFF3D6643), // ثابت أخضر
            child: Icon(Icons.category, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            circlename,
            style: TextStyle(
              color:
                  isSelected ? Colors.red : Colors.black, // بس النص اللي يتغير
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
