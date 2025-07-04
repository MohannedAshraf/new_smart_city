import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      height: 50.h,
      margin: EdgeInsets.only(top: 20.h),
      decoration: BoxDecoration(
        color: MyColors.gray,
        borderRadius: BorderRadius.circular(10.r),
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
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: MyColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
