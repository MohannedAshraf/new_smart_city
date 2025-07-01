import 'package:citio/core/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.borderRadius,
    required this.hintText,
    required this.height,
    this.onSubmitted,
  });
  final double borderRadius;
  final String hintText;
  final double height;
  final void Function(dynamic)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: 200.w,
      child: TextField(
        onSubmitted: (value) {
          onSubmitted;
        },
        decoration: InputDecoration(
          //hintTextDirection: textDirectionToAxisDirection(textDirection),
          hintText: hintText,
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.zero,
          isDense: true,
          hintStyle: const TextStyle(height: 1.0, color: MyColors.gray),
          prefixIcon: const Icon(Icons.search, color: MyColors.gray),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MyColors.whiteSmoke),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: MyColors.whiteSmoke),
          ),
          filled: true,
          fillColor: MyColors.whiteSmoke,
        ),
      ),
    );
  }
}
