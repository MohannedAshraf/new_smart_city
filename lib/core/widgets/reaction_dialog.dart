import 'package:flutter/material.dart';
import 'package:citio/core/widgets/reaction_icon_mapper.dart';

class ReactionDialog extends StatelessWidget {
  const ReactionDialog({super.key});

  final List<String> reactionTypes = const [
    'like', 'love', 'care', 'laugh', 'sad', 'hate',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: reactionTypes.map((type) {
            return InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () => Navigator.pop(context, type),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: ReactionIconMapper.getReactionIcon(type, size: 32),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
