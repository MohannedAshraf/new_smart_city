import 'package:citio/core/utils/variables.dart';
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
      height: MediaQuery.of(context).size.height * 0.0625,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.0250),
      decoration: BoxDecoration(
        color: MyColors.gray,
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width * 0.025,
        ),
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
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.03,
              fontWeight: FontWeight.bold,
              color: MyColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
