import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ReactionIconMapper {
  static Widget getReactionIcon(String? type, {double size = 24}) {
    switch (type) {
      case 'like':
        return _buildIcon(
          icon: Symbols.thumb_up, // Thumbs up for "like"
          color: Colors.blue, // Classic blue for like
          size: size,
          shadowColor: Colors.blueAccent,
        );
      case 'love':
        return _buildIcon(
          icon: Symbols.favorite, // Heart for "love"
          color: Colors.red, // Red for love
          size: size,
          shadowColor: Colors.redAccent,
        );
      case 'care':
        return _buildIcon(
          icon: Symbols.volunteer_activism, // Hands holding heart for "care"
          color: Colors.orange, // Warm orange for care
          size: size,
          shadowColor: Colors.orangeAccent,
        );
      case 'laugh':
        return _buildIcon(
          icon: Symbols.sentiment_very_satisfied, // Laughing face
          color: Colors.yellow.shade700, // Bright yellow for laugh
          size: size,
          shadowColor: Colors.yellow.shade300,
        );
      case 'sad':
        return _buildIcon(
          icon: Symbols.sentiment_dissatisfied, // Sad face
          color: Colors.blueGrey, // Blue-grey for sadness
          size: size,
          shadowColor: Colors.blueGrey.shade200,
        );
      case 'hate':
        return _buildIcon(
          icon: Symbols.heart_broken, // Broken heart for hate
          color: const Color.fromARGB(255, 1, 0, 3), // Deep purple for hate
          size: size,
          shadowColor: Colors.deepPurpleAccent,
        );
      default:
        return Icon(
          Symbols.emoji_emotions, // Default smiley
          color: Colors.grey.shade500,
          size: size,
        );
    }
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
