// ignore_for_file: deprecated_member_use

import 'package:citio/core/utils/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:citio/core/widgets/reaction_icon_mapper.dart';
import 'package:citio/core/widgets/reaction_dialog.dart';
import 'package:citio/services/socialmedia_reactions_api.dart';

class ReactionButton extends StatefulWidget {
  final String postId;
  final String? currentUserReaction;
  final int totalCount;
  final Function(String newReaction, int newTotal)? onReacted;

  const ReactionButton({
    super.key,
    required this.postId,
    this.currentUserReaction,
    required this.totalCount,
    this.onReacted,
  });

  @override
  State<ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<ReactionButton> {
  late String? _userReaction;
  late int _totalCount;

  @override
  void initState() {
    super.initState();
    _userReaction = widget.currentUserReaction;
    _totalCount = widget.totalCount;
  }

  Future<void> _sendReaction(String reactionType) async {
    final success = await SocialMediaReactionsApi.sendReaction(
      postId: widget.postId,
      reactionType: reactionType,
    );

    if (success != null) {
      setState(() {
        if (_userReaction == reactionType) {
          _userReaction = null;
        } else {
          _userReaction = reactionType;
        }
        _totalCount = success.total ?? _totalCount;
      });

      widget.onReacted?.call(_userReaction ?? '', _totalCount);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () async {
        if (_userReaction != null) {
          await _sendReaction(_userReaction!);
        } else {
          await _sendReaction('like');
        }
      },
      onLongPressStart: (details) async {
        final selected = await showReactionDialogAtTap(
          context: context,
          position: details.globalPosition,
        );

        if (selected != null) {
          await _sendReaction(selected);
        }
      },
      child: Row(
        children: [
          ReactionIconMapper.getReactionIcon(
            _userReaction,
            size: screenWidth * 0.06,
          ), // تقريبًا 24
          SizedBox(width: screenWidth * 0.01), // تقريبًا 4
          Text(
            // استخرجنا النص:
            // ignore: unnecessary_string_interpolations
            '${_totalCount.toString()}',
            style: TextStyle(
              color: MyColors.gray,
              fontSize: screenWidth * 0.025, // تقريبًا 10
            ),
          ),
        ],
      ),
    );
  }
}

Future<String?> showReactionDialogAtTap({
  required BuildContext context,
  required Offset position,
}) {
  return showGeneralDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'ReactionDialog',
    barrierColor: Colors.black.withOpacity(0.05),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) {
      return Stack(
        children: [
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 120,
            top: position.dy - 80,
            child: const Material(
              color: Colors.transparent,
              child: ReactionDialog(),
            ),
          ),
        ],
      );
    },
  );
}
