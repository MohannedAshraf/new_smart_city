// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ReactionIconMapper {
  static Widget getReactionIcon(String? type, {double size = 24}) {
    // استخدام media query بدل الحجم الثابت
    return Builder(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final scaledSize = screenWidth * 0.06; // يعادل تقريبًا 24

        final iconSize = size != 24 ? size : scaledSize;

        switch (type) {
          case 'like':
            return _buildIcon(
              icon: Symbols.thumb_up,
              color: Colors.blue,
              size: iconSize,
              shadowColor: Colors.blueAccent,
            );
          case 'love':
            return _buildIcon(
              icon: Symbols.favorite,
              color: Colors.red,
              size: iconSize,
              shadowColor: Colors.redAccent,
            );
          case 'care':
            return _buildIcon(
              icon: Symbols.volunteer_activism,
              color: Colors.orange,
              size: iconSize,
              shadowColor: Colors.orangeAccent,
            );
          case 'laugh':
            return _buildIcon(
              icon: Symbols.sentiment_very_satisfied,
              color: Colors.yellow.shade700,
              size: iconSize,
              shadowColor: Colors.yellow.shade300,
            );
          case 'sad':
            return _buildIcon(
              icon: Symbols.sentiment_dissatisfied,
              color: Colors.blueGrey,
              size: iconSize,
              shadowColor: Colors.blueGrey.shade200,
            );
          case 'hate':
            return _buildIcon(
              icon: Symbols.heart_broken,
              color: const Color.fromARGB(255, 1, 0, 3),
              size: iconSize,
              shadowColor: Colors.deepPurpleAccent,
            );
          default:
            return Icon(
              Symbols.emoji_emotions,
              color: Colors.grey.shade500,
              size: iconSize,
            );
        }
      },
    );
  }

  static Widget _buildIcon({
    required IconData icon,
    required Color color,
    required double size,
    required Color shadowColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: size),
    );
  }
}
