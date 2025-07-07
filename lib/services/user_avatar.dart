import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const UserAvatar({
    Key? key,
    this.imageUrl,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      // صورة افتراضية لو مفيش صورة
      return CircleAvatar(
        radius: size / 2,
        child: Icon(Icons.person, size: size * 0.6),
      );
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundImage: NetworkImage(imageUrl!),
      backgroundColor: Colors.grey[200],
    );
  }
}
