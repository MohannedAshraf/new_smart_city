import 'package:citio/core/utils/variables.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 200,
      child: TextField(
        decoration: InputDecoration(
          //hintTextDirection: textDirectionToAxisDirection(textDirection),
          hintText: 'ماذا تريد ',
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.zero,
          isDense: true,
          hintStyle: const TextStyle(height: 1.0, color: MyColors.gray),
          prefixIcon: const Icon(Icons.search, color: MyColors.gray),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MyColors.whiteSmoke),
            borderRadius: BorderRadius.circular(25.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(color: MyColors.whiteSmoke),
          ),
          filled: true,
          fillColor: MyColors.whiteSmoke,
        ),
      ),
    );
  }
}
