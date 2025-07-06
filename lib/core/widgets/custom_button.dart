import 'package:citio/core/utils/mycolors.dart';
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
    final double height = MediaQuery.of(context).size.height * 0.065;
    final double topMargin = MediaQuery.of(context).size.height * 0.025;
    final double fontSize = MediaQuery.of(context).size.width * 0.06;

    return Container(
      height: height,
      margin: EdgeInsets.only(top: topMargin),
      decoration: BoxDecoration(
        color: MyColors.gray,
        borderRadius: BorderRadius.circular(10),
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
            text, // 🔁 يمكن إضافته في AppStrings
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: MyColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
