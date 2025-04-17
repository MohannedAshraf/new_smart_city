import 'package:flutter/material.dart';

class CategoryCircle extends StatelessWidget {
  const CategoryCircle({super.key, required this.circlename});
  final String circlename;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: const Color(0xFF3D6643),
        child: Text(circlename, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
