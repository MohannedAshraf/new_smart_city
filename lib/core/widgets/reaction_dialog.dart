import 'package:flutter/material.dart';
import 'package:citio/core/widgets/reaction_icon_mapper.dart';

class ReactionDialog extends StatelessWidget {
  const ReactionDialog({super.key});

  final List<String> reactionTypes = const [
    'like',
    'love',
    'care',
    'laugh',
    'sad',
    'hate',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04), // تقريباً 16
        boxShadow: [
          BoxShadow(
            blurRadius: screenWidth * 0.025, // تقريباً 10
            color: Colors.black12,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.03, // تقريباً 12
        horizontal: screenWidth * 0.05, // تقريباً 20
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children:
            reactionTypes.map((type) {
              return InkWell(
                borderRadius: BorderRadius.circular(
                  screenWidth * 0.075,
                ), // تقريباً 30
                onTap: () => Navigator.pop(context, type),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02, // تقريباً 8
                    vertical: screenWidth * 0.015, // تقريباً 6
                  ),
                  child: ReactionIconMapper.getReactionIcon(
                    type,
                    size: screenWidth * 0.08,
                  ), // تقريباً 32
                ),
              );
            }).toList(),
      ),
    );
  }
}
