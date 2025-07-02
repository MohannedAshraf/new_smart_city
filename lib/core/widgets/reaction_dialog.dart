// features/social_media/widgets/reaction_dialog.dart

import 'package:flutter/material.dart';
import 'package:citio/core/widgets/reaction_icon_mapper.dart';

class ReactionDialog extends StatelessWidget {
  const ReactionDialog({super.key});

  final List<String> reactionTypes = const [
    'like', 'love', 'care', 'laugh', 'sad', 'hate'
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('اختر تفاعلك'),
      content: SizedBox(
        width: double.maxFinite,
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: reactionTypes.map((type) {
            return GestureDetector(
              onTap: () => Navigator.pop(context, type),
              child: ReactionIconMapper.getReactionIcon(type, size: 35),
            );
          }).toList(),
        ),
      ),
    );
  }
}
