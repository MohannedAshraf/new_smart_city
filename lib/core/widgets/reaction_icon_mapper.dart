// core/widgets/reaction_icon_mapper.dart

import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class ReactionIconMapper {
  static Widget getReactionIcon(String? type, {double size = 20}) {
    switch (type) {
      case 'like':
        return Icon(Icons.thumb_up_alt_outlined, color: Colors.blue, size: size);
      case 'love':
        return Icon(Icons.favorite, color: Colors.red, size: size);
      case 'care':
        return Icon(Icons.emoji_emotions, color: Colors.orange, size: size);
      case 'laugh':
        return Icon(Icons.sentiment_very_satisfied, color: Colors.amber, size: size);
      case 'sad':
        return Icon(Icons.sentiment_dissatisfied, color: Colors.teal, size: size);
      case 'hate':
        return Icon(Icons.heart_broken, color: Colors.black, size: size);
      default:
        return Icon(FluentIcons.emoji_28_regular, color: Colors.grey, size: size);
    }
  }
}
