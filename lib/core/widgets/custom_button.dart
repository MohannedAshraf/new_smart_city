import 'package:city/core/utils/variables.dart';
import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    super.key,
    required this.text,
    this.newscreen,
    this.onPressed,
  });

  final String text;
  final Widget? newscreen;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: MyColors.gray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: TextButton(
          onPressed: () {
            if (onPressed != null) {
              onPressed!(); // ✅ تنفيذ الدالة إن وجدت
            }
            if (newscreen != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => newscreen!),
              );
            }
          },
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: MyColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
