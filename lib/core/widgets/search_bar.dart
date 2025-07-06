import 'package:citio/core/utils/mycolors.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final double borderRadius;
  final String hintText;
  final double height;
  final void Function(dynamic)? onSubmitted;

  const CustomSearchBar({
    super.key,
    required this.borderRadius,
    required this.hintText,
    required this.height,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: height,
      width: screenWidth * 0.5, // بديل عن 200.w
      child: TextField(
        onChanged: (value) => onSubmitted?.call(value),
        decoration: InputDecoration(
          hintText: hintText, // مثال: AppStrings.searchHint
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.zero,
          isDense: true,
          hintStyle: TextStyle(
            height: 1.0,
            color: MyColors.gray,
            fontSize: screenWidth * 0.035, // تقريباً 14
          ),
          prefixIcon: Icon(
            Icons.search,
            color: MyColors.gray,
            size: screenWidth * 0.05,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MyColors.whiteSmoke),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MyColors.whiteSmoke),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          filled: true,
          fillColor: MyColors.whiteSmoke,
        ),
      ),
    );
  }
}
