import 'package:flutter/material.dart';

class CategoryCircle extends StatelessWidget {
  final String name; // اسم الكاتيجوري من الـ API
  final String imageUrl; // رابط الصورة من الـ API
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
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: const Color(0xFF3D6643), // اللون الثابت
            backgroundImage: NetworkImage(
              'https://service-provider.runasp.net$imageUrl', // تحميل الصورة من الـ URL
            ),
            child:
                imageUrl
                        .isEmpty // إذا كانت الصورة فارغة، نعرض الأيقونة
                    ? const Icon(Icons.category, color: Colors.white)
                    : null,
          ),
          const SizedBox(height: 5),
          Text(
            name, // الاسم اللي جاي من الـ API
            style: TextStyle(
              color:
                  isSelected
                      ? Colors.red
                      : Colors.black, // تغيير لون النص إذا كانت مختارة
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
