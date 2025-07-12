import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ReactionIconMapper {
  static Widget getReactionIcon(String? type, {double size = 24}) {
    return Builder(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final scaledSize = screenWidth * 0.06;
        final iconSize = size != 24 ? size : scaledSize;

        final isSupported = _isSupportedType(type);

        if (isSupported) {
          final imagePath = 'assets/reactions/$type.png';
          return Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 3,
                  offset: const Offset(0, 1.5),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return _defaultIcon(iconSize);
                },
              ),
            ),
          );
        } else {
          return _defaultIcon(iconSize);
        }
      },
    );
  }

  static bool _isSupportedType(String? type) {
    const supported = ['like', 'love', 'care', 'laugh', 'sad', 'hate'];
    return supported.contains(type);
  }

  static Widget _defaultIcon(double size) {
    return Icon(
      Symbols.emoji_emotions,
      color: Colors.grey.shade500,
      size: size,
    );
  }
}
